#import <Foundation/Foundation.h>


@interface DDCell : NSObject {

}

@property (nonatomic, assign) NSUInteger columnSpan;
@property (nonatomic, assign) NSUInteger rowSpan;
@property (nonatomic, readonly) NSUInteger area;
@property (nonatomic, assign) BOOL flexibleLayout;
@property (nonatomic, assign) NSUInteger effectiveColumnSpan;
@property (nonatomic, assign) NSUInteger effectiveRowSpan;
@property (nonatomic, readonly) NSUInteger effectiveArea;
@property (nonatomic, copy) NSString *headingText;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, retain) UIFont *headingFont;
@property (nonatomic, retain) UIFont *bodyFont;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat padding;

- (UIView *)viewWithFrame:(CGRect)frame columnWidth:(CGFloat)colWidth spacing:(CGSize)spacing;

@end
