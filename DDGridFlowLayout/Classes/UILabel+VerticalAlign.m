#import "UILabel+VerticalAlign.h"


@implementation UILabel (VerticalAlign)

- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGFloat finalHeight = fontSize.height * self.numberOfLines;
    CGFloat finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    NSInteger newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for (NSInteger i = 0; i < newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGFloat finalHeight = fontSize.height * self.numberOfLines;
    CGFloat finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    NSInteger newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for (NSInteger i = 0; i < newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@", self.text];
}

@end