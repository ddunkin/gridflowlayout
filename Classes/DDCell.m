#import "DDCell.h"


@implementation DDCell

@synthesize rowSpan = m_rowSpan,
	columnSpan = m_columnSpan,
	headingText = m_headingText,
	bodyText = m_bodyText,
	backgroundColor = m_backgroundColor,
	padding = m_padding;

- (id)init
{
	if (self = [super init])
	{
		m_rowSpan = 1;
		m_columnSpan = 1;
	}
	return self;
}

- (void)dealloc
{
	[m_headingText release];
	[m_bodyText release];
	[m_backgroundColor release];
	[super dealloc];
}

- (UIView *)viewWithFrame:(CGRect)frame columnWidth:(CGFloat)colWidth spacing:(CGSize)spacing
{
	UIView *cellView = [[[UIView alloc] initWithFrame:frame] autorelease];
	
	if (m_backgroundColor)
		cellView.backgroundColor = m_backgroundColor;
	
	UILabel *headingView = [[[UILabel alloc] initWithFrame:CGRectMake(m_padding, m_padding, frame.size.width, 26)] autorelease];
	headingView.backgroundColor = [UIColor clearColor];
	headingView.font = [UIFont boldSystemFontOfSize:24];
	headingView.text = m_headingText;
	[cellView addSubview:headingView];

	NSString *fullBodyText = m_bodyText;

	for (NSUInteger col = 0; col < m_columnSpan; col++)
	{
		CGFloat blockHeight = frame.size.height - 26 - m_padding;
		UILabel *body = [[[UILabel alloc] initWithFrame:CGRectMake(col * (colWidth + spacing.width) + m_padding,
																   26 + m_padding,
																   colWidth - (2 * m_padding),
																   blockHeight)] autorelease];
		body.backgroundColor = [UIColor clearColor];
		body.font = [UIFont systemFontOfSize:12];
		body.text = fullBodyText;
		body.numberOfLines = blockHeight / 12;
		
		// if there is more than one column, split the text at column breaks
		if (col < m_columnSpan - 1)
		{
			body.lineBreakMode = UILineBreakModeWordWrap;
			
			NSString *blockText = fullBodyText;
			CGSize blockLayoutSize = CGSizeMake(colWidth - (2 * m_padding), blockHeight + 15);
			CGSize size = [blockText sizeWithFont:body.font constrainedToSize:blockLayoutSize];
			while (size.height > blockHeight)
			{
				NSRange range = [blockText rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch];
				if (range.location == NSNotFound)
					break;
				
				blockText = [blockText substringToIndex:range.location];
				size = [blockText sizeWithFont:body.font constrainedToSize:blockLayoutSize];
			}
			body.text = blockText;
			fullBodyText = [fullBodyText substringFromIndex:[blockText length]];
			NSRange range = [blockText rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if (range.location != NSNotFound)
				fullBodyText = [fullBodyText substringFromIndex:(range.location + range.length)];
		}
		
		[cellView addSubview:body];
	}
	
	return cellView;
}

@end
