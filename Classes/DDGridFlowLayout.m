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
	
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSMutableArray *flowedCells;

- (void)reflow;

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

- (void)layoutInView:(UIView *)view
{
	[self reflow];

	CGSize viewSize = view.bounds.size;
	CGFloat colWidth = floorf((viewSize.width - (2 * m_margin.width) - ((m_columns - 1) * m_spacing.width)) / m_columns);
	CGFloat rowHeight = floorf((viewSize.height - (2 * m_margin.height) - ((m_rows - 1) * m_spacing.height)) / m_rows);
	
	for (NSUInteger row = 0; row < m_rows; row++)
	{
		for (NSUInteger col = 0; col < m_columns;)
		{
			NSUInteger cellNumber = row * m_columns + col;
			
			id obj = [m_flowedCells objectAtIndex:cellNumber];
			if ([obj isKindOfClass:[DDCell class]])
			{
				DDCell *cell = obj;
				CGFloat cellWidth = cell.columnSpan * colWidth + ((cell.columnSpan - 1) * m_spacing.width);
				CGFloat cellHeight = cell.rowSpan * rowHeight + ((cell.rowSpan - 1) * m_spacing.height);
				
				CGRect frame = CGRectMake(m_margin.width + col * (colWidth + m_spacing.width),
										  m_margin.height + row * (rowHeight + m_spacing.height),
										  cellWidth,
										  cellHeight);
				NSLog(@"Cell %d, x=%f, y=%f, w=%f, h=%f", cellNumber, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
				
				UIView *cellView = [cell viewWithFrame:frame columnWidth:colWidth spacing:m_spacing];
				
				[view addSubview:cellView];
				
				col += cell.columnSpan;
			}
			else
			{
				col++;
			}
		}
	}
}

#pragma mark private

- (void)reflow
{
	self.flowedCells = [NSMutableArray arrayWithCapacity:(m_rows * m_columns)];

	for (NSUInteger i = 0; i < m_rows * m_columns; i++)
	{
		[m_flowedCells addObject:[NSNull null]];
	}
	
	NSMutableArray *cellsToFlow = [NSMutableArray arrayWithArray:m_cells];
	
	for (NSUInteger row = 0; row < m_rows; row++)
	{
		for (NSUInteger col = 0; col < m_columns;)
		{
			NSUInteger cellNumber = row * m_columns + col;
			
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
				NSUInteger columnsAvailable = m_columns - col;
				
				for (int i = 1; i < columnsAvailable; i++)
				{
					NSUInteger j = row * m_columns + col + i;
					id obj = [m_flowedCells objectAtIndex:j];
					if (![obj isKindOfClass:[NSNull class]])
					{
						columnsAvailable = i;
						break;
					}
				}
				
				NSUInteger cellIndex = -1;
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
					NSLog(@"No remaining cells fit");
					goto done;
				}
				
				DDCell *cell = [cellsToFlow objectAtIndex:cellIndex];
				[cellsToFlow removeObjectAtIndex:cellIndex];
				
				for (NSUInteger blankRow = row; blankRow < row + cell.rowSpan; blankRow++)
				{
					for (NSUInteger blankCol = col; blankCol < col + cell.columnSpan; blankCol++)
					{
						NSUInteger blankCellNumber = blankRow * m_columns + blankCol;
						[m_flowedCells replaceObjectAtIndex:blankCellNumber withObject:[DDBlank blank]];
					}
				}

				[m_flowedCells replaceObjectAtIndex:cellNumber withObject:cell];

				col += cell.columnSpan;
			}
		}
	}
	
done:
	NSLog(@"flowedCells: %@", m_flowedCells);
}

@end
