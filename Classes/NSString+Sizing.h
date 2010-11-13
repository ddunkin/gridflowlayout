#import <UIKit/UIKit.h>


@interface NSString (Sizing)

- (NSString *)stringThatFitsWithFont:(UIFont *)font constrainedToSize:(CGSize)constraintSize;

@end
