#import <UIKit/UIKit.h>


@interface NSString (Sizing)

- (NSString *)stringThatFitsWithFont:(UIFont *)font constrainedToSize:(CGSize)constraintSize;
- (NSString *)stringByRightTrimmingCharactersInSet:(NSCharacterSet *)set;

@end
