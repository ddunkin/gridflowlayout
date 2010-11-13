#import "DDCell.h"
#import "NSString+Sizing.h"
#import "UILabel+VerticalAlign.h"


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

	UIFont *headingFont = [UIFont boldSystemFontOfSize:24];
	UIFont *bodyFont = [UIFont systemFontOfSize:12];

	CGFloat headingHeight = headingFont.lineHeight;
	CGFloat headingPadding = 2;

	UILabel *headingView = [[[UILabel alloc] initWithFrame:CGRectMake(m_padding, m_padding, frame.size.width, headingHeight)] autorelease];
	headingView.backgroundColor = [UIColor clearColor];
	headingView.font = headingFont;
	headingView.text = m_headingText;
	[cellView addSubview:headingView];
	
	NSString *fullBodyText = m_bodyText;

	for (NSUInteger col = 0; col < m_columnSpan; col++)
	{
		CGFloat blockHeight = frame.size.height - headingHeight - headingPadding - m_padding;
		UILabel *body = [[[UILabel alloc] initWithFrame:CGRectMake(col * (colWidth + spacing.width) + m_padding,
																   headingHeight - headingPadding,
																   colWidth - (2 * m_padding),
																   blockHeight)] autorelease];
		body.backgroundColor = [UIColor clearColor];
		body.font = bodyFont;
		body.text = fullBodyText;
		body.numberOfLines = blockHeight / body.font.lineHeight;
		
		// if there is more than one column, split the text at column breaks
		if (col < m_columnSpan - 1)
		{
			body.lineBreakMode = UILineBreakModeWordWrap;
			
			CGSize blockLayoutSize = CGSizeMake(colWidth - (2 * m_padding), blockHeight + bodyFont.lineHeight);
			NSString *blockText = [fullBodyText stringThatFitsWithFont:bodyFont constrainedToSize:blockLayoutSize];

			body.text = blockText;
			fullBodyText = [fullBodyText substringFromIndex:[blockText length]];
			
			// trim leading whitespace, but preserve whitespace after a newline
			NSRange range = [fullBodyText rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
			if (range.location == 0)
				fullBodyText = [fullBodyText substringFromIndex:(range.location + range.length)];
			range = [fullBodyText rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
			if (range.location == 0)
				fullBodyText = [fullBodyText substringFromIndex:(range.location + range.length)];
		}
		
		[body alignTop];
		
		[cellView addSubview:body];
	}
	
	return cellView;
}

@end
