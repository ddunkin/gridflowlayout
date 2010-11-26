#import "DDCell.h"


@interface DDHeadingBodyTextCell : DDCell {

}

@property (nonatomic, copy) NSString *headingText;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, retain) UIFont *headingFont;
@property (nonatomic, retain) UIFont *bodyFont;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat padding;

@end
