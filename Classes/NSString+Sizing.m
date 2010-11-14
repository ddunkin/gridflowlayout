#import "NSString+Sizing.h"


@implementation NSString (Sizing)

- (NSString *)stringThatFitsWithFont:(UIFont *)font constrainedToSize:(CGSize)constraintSize
{
	NSString *text = self;
	CGFloat maxHeight = constraintSize.height - font.lineHeight;
	
#if 0
	
	// trim off the last word until it fits
	CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize];
	while (size.height > maxHeight)
	{
		NSRange range = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch];
		if (range.location == NSNotFound)
			break;
		
		text = [text substringToIndex:range.location];
		size = [text sizeWithFont:font constrainedToSize:constraintSize];
	}
	
#else

	// search by splitting the text in half until it fits
	NSRange range = NSMakeRange(0, [text length]);
	NSUInteger startIndex = 0;
	BOOL found = NO;
	while (!found)
	{
		NSUInteger previousEndIndex = 0;
		NSString *substring = [text substringWithRange:[text rangeOfComposedCharacterSequencesForRange:range]];
		CGSize size = [substring sizeWithFont:font constrainedToSize:constraintSize];
		while (size.height > maxHeight)
		{
			previousEndIndex = range.length;
			range = NSMakeRange(0, startIndex + ((range.length - startIndex) / 2));
			substring = [text substringWithRange:[text rangeOfComposedCharacterSequencesForRange:range]];
			size = [substring sizeWithFont:font constrainedToSize:constraintSize];
		}
		if (previousEndIndex > range.length + 1)
		{
			startIndex = range.length;
			range = NSMakeRange(0, previousEndIndex);
		}
		else
		{
			found = YES;
		}
	}
	
	NSRange rangeOfLastSpace = [text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch range:range];
	if (rangeOfLastSpace.location != NSNotFound)
		text = [text substringToIndex:rangeOfLastSpace.location];

#endif
	
	return [text stringByRightTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRightTrimmingCharactersInSet:(NSCharacterSet *)set
{
	NSString *text = self;
	NSRange range = [text rangeOfCharacterFromSet:set options:NSBackwardsSearch];
	if (range.location + range.length == [text length])
		text = [text substringToIndex:range.location];
	return text;
}

@end
