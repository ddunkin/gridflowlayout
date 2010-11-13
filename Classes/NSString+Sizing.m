#import "NSString+Sizing.h"


@implementation NSString (Sizing)

- (NSString *)stringThatFitsWithFont:(UIFont *)font constrainedToSize:(CGSize)constraintSize
{
	NSString *text = self;
	CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize];
	while (size.height > constraintSize.height - font.lineHeight)
	{
		NSRange range = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch];
		if (range.location == NSNotFound)
			break;
		
		text = [text substringToIndex:range.location];
		size = [text sizeWithFont:font constrainedToSize:constraintSize];
	}
	
	// right trim whitespace
	NSRange range = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch];
	if (range.location + range.length == [text length])
		text = [text substringToIndex:range.location];
	
	return text;
}

@end
