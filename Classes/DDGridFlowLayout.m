//
//  DDFlowLayout.m
//  LayoutTest
//
//  Created by Dave Dunkin on 11/9/10.
//  Copyright 2010 Dave Dunkin. All rights reserved.
//

#import "DDGridFlowLayout.h"
#import "DDCell.h"


@interface DDGridFlowLayout ()
	
@property (nonatomic, readwrite, assign) NSUInteger pages;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSMutableArray *flowedCells;

- (void)placeCell:(DDCell *)cell page:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col;
- (NSUInteger)rowsAvailableAtPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col;
- (NSUInteger)columnsAvailableAtPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col;

@end


@interface DDBlank : NSObject

+ (DDBlank *)blank;

@end


@implementation DDBlank

static DDBlank *blankInstance;

+ (void)initialize
{
	if (blankInstance == nil)
		blankInstance = [[DDBlank alloc] init];
}

+ (DDBlank *)blank
{
	return blankInstance;
}

@end


@implementation DDGridFlowLayout

@synthesize rows = m_rows,
	columns = m_columns,
	pages = m_pages,
	margin = m_margin,
	spacing = m_spacing,
	cells = m_cells,
	flowedCells = m_flowedCells;

- (id)init
{
	return [self initWithRows:1 columns:1];
}

- (id)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns
{
	if (self = [super init])
	{
		m_rows = rows;
		m_columns = columns;
		m_margin = CGSizeMake(20, 20);
		m_spacing = CGSizeMake(10, 10);
		m_cells = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[m_cells release];
	[m_flowedCells release];
	[super dealloc];
}

- (void)addCell:(DDCell *)cell
{
	[m_cells addObject:cell];
}

- (void)removeCell:(DDCell *)cell
{
	[m_cells removeObject:cell];
}

- (void)removeAllCells
{
	[m_cells removeAllObjects];
}

- (void)layoutPage:(NSUInteger)page inView:(UIView *)view
{
	CGSize viewSize = view.bounds.size;
	CGFloat colWidth = floorf((viewSize.width - (2 * m_margin.width) - ((m_columns - 1) * m_spacing.width)) / m_columns);
	CGFloat rowHeight = floorf((viewSize.height - (2 * m_margin.height) - ((m_rows - 1) * m_spacing.height)) / m_rows);
	
	NSUInteger pageCellCount = m_rows * m_columns;
	NSUInteger pageCellOffset = page * pageCellCount;
	
	for (NSUInteger row = 0; row < m_rows; row++)
	{
		for (NSUInteger col = 0; col < m_columns;)
		{
			NSUInteger cellNumber = pageCellOffset + (row * m_columns) + col;
			
			id obj = [m_flowedCells objectAtIndex:cellNumber];
			if ([obj isKindOfClass:[DDCell class]])
			{
				DDCell *cell = obj;
				
				CGFloat cellWidth = cell.effectiveColumnSpan * colWidth + ((cell.effectiveColumnSpan - 1) * m_spacing.width);
				CGFloat cellHeight = cell.effectiveRowSpan * rowHeight + ((cell.effectiveRowSpan - 1) * m_spacing.height);
				
				CGRect frame = CGRectMake(m_margin.width + col * (colWidth + m_spacing.width),
										  m_margin.height + row * (rowHeight + m_spacing.height),
										  cellWidth,
										  cellHeight);
				//NSLog(@"Cell %d, x=%f, y=%f, w=%f, h=%f", cellNumber, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
				
				UIView *cellView = [cell viewWithFrame:frame columnWidth:colWidth spacing:m_spacing];
				[view addSubview:cellView];
				
				col += cell.effectiveColumnSpan;
			}
			else
			{
				col++;
			}
		}
	}
}

- (void)reflow
{
	if ([m_cells count] == 0)
	{
		m_pages = 0;
		return;
	}
	
	NSUInteger pageCellCount = m_rows * m_columns;
	NSMutableArray *cellsToFlow = [NSMutableArray arrayWithArray:m_cells];
	self.flowedCells = [NSMutableArray array];
	
	NSUInteger page = 0;
	while ([cellsToFlow count] != 0)
	{
		NSUInteger pageCellOffset = page * pageCellCount;
		NSMutableArray *pageFlowedCells = [NSMutableArray arrayWithCapacity:pageCellCount];
		for (NSUInteger i = 0; i < pageCellCount; i++)
		{
			[pageFlowedCells addObject:[NSNull null]];
		}
		[m_flowedCells addObjectsFromArray:pageFlowedCells];
		
		for (NSUInteger row = 0; row < m_rows; row++)
		{
			for (NSUInteger col = 0; col < m_columns;)
			{
				NSUInteger cellNumber = pageCellOffset + (row * m_columns) + col;
				
				id obj = [m_flowedCells objectAtIndex:cellNumber];
				if ([obj isKindOfClass:[DDCell class]])
				{
					DDCell *cell = obj;
					col += cell.columnSpan;
				}
				else if ([obj isKindOfClass:[DDBlank class]])
				{
					col++;
				}
				else
				{
					if ([cellsToFlow count] == 0)
						goto done;

					// get the next cell that will fit
					NSUInteger rowsAvailable = m_rows - row;
					NSUInteger columnsAvailable = [self columnsAvailableAtPage:page row:row column:col];
					
					NSInteger cellIndex = -1;
					for (NSUInteger i = 0; i < [cellsToFlow count]; i++)
					{
						DDCell *cell = [cellsToFlow objectAtIndex:i];
						if (cell.rowSpan <= rowsAvailable && cell.columnSpan <= columnsAvailable)
						{
							cellIndex = i;
							break;
						}
					}
					
					if (cellIndex == -1)
					{
						// none of the remaining cells fit in this row
						// skip to the next
						col = m_columns;
					}
					else
					{
						DDCell *cell = [cellsToFlow objectAtIndex:cellIndex];
						[cellsToFlow removeObjectAtIndex:cellIndex];
						
						cell.effectiveRowSpan = cell.rowSpan;
						cell.effectiveColumnSpan = cell.columnSpan;
						
						[self placeCell:cell page:page row:row column:col];
						
						col += cell.columnSpan;
					}
				}
			}
		}
		
done:

		// try filling in the holes
		for (NSUInteger row = 0; row < m_rows; row++)
		{
			for (NSUInteger col = 0; col < m_columns;)
			{
				NSUInteger cellNumber = pageCellOffset + (row * m_columns) + col;
				
				id obj = [m_flowedCells objectAtIndex:cellNumber];
				if ([obj isKindOfClass:[DDCell class]])
				{
					DDCell *cell = obj;
					col += cell.columnSpan;
				}
				else if ([obj isKindOfClass:[DDBlank class]])
				{
					col++;
				}
				else
				{
					// find cells with flexible layout and the same area
					NSUInteger rowsAvailable = [self rowsAvailableAtPage:page row:row column:col];
					NSUInteger columnsAvailable = [self columnsAvailableAtPage:page row:row column:col];
					
					NSInteger cellIndex = -1;
					for (NSUInteger i = 0; i < [cellsToFlow count]; i++)
					{
						DDCell *cell = [cellsToFlow objectAtIndex:i];
						if (cell.flexibleLayout && (cell.area == rowsAvailable || cell.area == columnsAvailable))
						{
							cellIndex = i;
							break;
						}
					}
					
					if (cellIndex == -1)
					{
						// none of the remaining cells can be reshaped to fit this hole
						// try to extend a neighboring cell
						
						BOOL extendedNeighbor = NO;
						
						NSUInteger searchRow = row;
						while (searchRow > 0)
						{
							searchRow--;
							NSUInteger neighborCellNumber = pageCellOffset + (searchRow * m_columns) + col;
							id neighbor = [m_flowedCells objectAtIndex:neighborCellNumber];
							if ([neighbor isKindOfClass:[DDCell class]])
							{
								DDCell *neighborCell = (DDCell *)neighbor;
								if (neighborCell.flexibleLayout && neighborCell.effectiveColumnSpan == 1)
								{
									NSLog(@"Extending effectiveRowSpan of cell at %d", neighborCellNumber);
									neighborCell.effectiveRowSpan += 1;
									[m_flowedCells replaceObjectAtIndex:cellNumber withObject:[DDBlank blank]];
									extendedNeighbor = YES;
									break;
								}
							}
						}
						
						if (!extendedNeighbor)
						{
							NSUInteger searchCol = col;
							while (searchCol > 0)
							{
								searchCol--;
								NSUInteger neighborCellNumber = pageCellOffset + (row * m_columns) + searchCol;
								id neighbor = [m_flowedCells objectAtIndex:neighborCellNumber];
								if ([neighbor isKindOfClass:[DDCell class]])
								{
									DDCell *neighborCell = (DDCell *)neighbor;
									if (neighborCell.flexibleLayout && neighborCell.effectiveRowSpan == 1)
									{
										NSLog(@"Extending effectiveColumnSpan of cell at %d", neighborCellNumber);
										neighborCell.effectiveColumnSpan += 1;
										[m_flowedCells replaceObjectAtIndex:cellNumber withObject:[DDBlank blank]];
										extendedNeighbor = YES;
										break;
									}
								}
							}
						}
						
						col++;
					}
					else
					{
						NSLog(@"Reshaping cell at %d", cellIndex);

						DDCell *cell = [cellsToFlow objectAtIndex:cellIndex];
						[cellsToFlow removeObjectAtIndex:cellIndex];
						
						if (cell.area == rowsAvailable)
							cell.effectiveRowSpan = rowsAvailable;
						else if (cell.area == columnsAvailable)
							cell.effectiveColumnSpan = columnsAvailable;

						[self placeCell:cell page:page row:row column:col];
						
						col += cell.effectiveColumnSpan;
					}
				}
			}
		}
		
		page++;
	}
	
	m_pages = page;
}

- (void)placeCell:(DDCell *)cell page:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col
{
	NSUInteger pageCellCount = m_rows * m_columns;
	NSUInteger pageCellOffset = page * pageCellCount;
	NSUInteger cellNumber = pageCellOffset + (row * m_columns) + col;

	for (NSUInteger blankRow = row; blankRow < row + cell.effectiveRowSpan; blankRow++)
	{
		for (NSUInteger blankCol = col; blankCol < col + cell.effectiveColumnSpan; blankCol++)
		{
			NSUInteger blankCellNumber = pageCellOffset + (blankRow * m_columns) + blankCol;
			[m_flowedCells replaceObjectAtIndex:blankCellNumber withObject:[DDBlank blank]];
		}
	}
	
	[m_flowedCells replaceObjectAtIndex:cellNumber withObject:cell];
}

- (NSUInteger)rowsAvailableAtPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col
{
	NSUInteger pageCellCount = m_rows * m_columns;
	NSUInteger pageCellOffset = page * pageCellCount;
	
	NSUInteger rowsAvailable = m_rows - row;
	
	for (int i = 1; i < rowsAvailable; i++)
	{
		NSUInteger j = pageCellOffset + ((row + i) * m_columns) + col;
		id obj = [m_flowedCells objectAtIndex:j];
		if (![obj isKindOfClass:[NSNull class]])
		{
			rowsAvailable = i;
			break;
		}
	}
	
	return rowsAvailable;
}

- (NSUInteger)columnsAvailableAtPage:(NSUInteger)page row:(NSUInteger)row column:(NSUInteger)col
{
	NSUInteger pageCellCount = m_rows * m_columns;
	NSUInteger pageCellOffset = page * pageCellCount;

	NSUInteger columnsAvailable = m_columns - col;
	
	for (int i = 1; i < columnsAvailable; i++)
	{
		NSUInteger j = pageCellOffset + (row * m_columns) + col + i;
		id obj = [m_flowedCells objectAtIndex:j];
		if (![obj isKindOfClass:[NSNull class]])
		{
			columnsAvailable = i;
			break;
		}
	}
	
	return columnsAvailable;
}

@end
