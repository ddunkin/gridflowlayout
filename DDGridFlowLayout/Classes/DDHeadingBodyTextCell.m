#import "DDHeadingBodyTextCell.h"
#import "NSString+Sizing.h"
#import "UILabel+VerticalAlign.h"


@implementation DDHeadingBodyTextCell

@synthesize headingText = m_headingText,
	bodyText = m_bodyText,
	headingFont = m_headingFont,
	bodyFont = m_bodyFont,
	backgroundColor = m_backgroundColor,
	padding = m_padding;

- (id)init
{
	if (self = [super init])
	{
		m_headingFont = [[UIFont boldSystemFontOfSize:24] retain];
		m_bodyFont = [[UIFont systemFontOfSize:12] retain];
	}
	return self;
}

- (void)dealloc
{
	[m_headingText release];
	[m_bodyText release];
	[m_headingFont release];
	[m_bodyFont release];
	[m_backgroundColor release];
	[super dealloc];
}

- (UIView *)viewWithFrame:(CGRect)frame columnWidth:(CGFloat)colWidth spacing:(CGSize)spacing
{
	UIView *cellView = [[[UIView alloc] initWithFrame:frame] autorelease];
	
	if (m_backgroundColor)
		cellView.backgroundColor = m_backgroundColor;
	
	CGFloat headingHeight = m_headingFont.lineHeight;
	CGFloat headingWidth = frame.size.width - (2 * m_padding);
	CGSize headingSize = [m_headingText sizeWithFont:m_headingFont constrainedToSize:CGSizeMake(headingWidth, frame.size.height)];
	headingHeight = headingSize.height;
	
	UILabel *headingView = [[[UILabel alloc] initWithFrame:CGRectMake(m_padding, m_padding, headingWidth, headingHeight)] autorelease];
	headingView.backgroundColor = [UIColor clearColor];
	headingView.font = m_headingFont;
	headingView.text = m_headingText;
	headingView.lineBreakMode = UILineBreakModeWordWrap;
	headingView.numberOfLines = headingHeight / m_headingFont.lineHeight;
	[cellView addSubview:headingView];
	
	NSString *fullBodyText = m_bodyText;
	
	for (NSUInteger col = 0; col < self.effectiveColumnSpan; col++)
	{
		CGFloat blockHeight = frame.size.height - headingHeight - m_padding;
		UILabel *body = [[[UILabel alloc] initWithFrame:CGRectMake(col * (colWidth + spacing.width) + m_padding,
																   headingHeight + m_padding,
																   colWidth - (2 * m_padding),
																   blockHeight)] autorelease];
		body.backgroundColor = [UIColor clearColor];
		body.font = m_bodyFont;
		body.text = fullBodyText;
		body.numberOfLines = blockHeight / m_bodyFont.lineHeight;
		
		// if there is more than one column, split the text at column breaks
		if (col < self.effectiveColumnSpan - 1)
		{
			body.lineBreakMode = UILineBreakModeWordWrap;
			
			CGSize blockLayoutSize = CGSizeMake(colWidth - (2 * m_padding), blockHeight + m_bodyFont.lineHeight);
			NSString *blockText = [fullBodyText stringThatFitsWithFont:m_bodyFont constrainedToSize:blockLayoutSize];
			
			body.text = blockText;
			fullBodyText = [fullBodyText substringFromIndex:[blockText length]];
			
			// trim leading whitespace, but preserve whitespace after a newline
			NSRange range = [fullBodyText rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
			if (range.location == 0)
				fullBodyText = [fullBodyText substringFromIndex:(range.location + range.length)];
			
			range = [fullBodyText rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
			while (range.location == 0)
			{
				fullBodyText = [fullBodyText substringFromIndex:(range.location + range.length)];
				range = [fullBodyText rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
			}
		}
		
		[body alignTop];
		
		[cellView addSubview:body];
	}
	
	return cellView;
}

@end
