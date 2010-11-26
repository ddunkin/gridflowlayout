#import <UIKit/UIKit.h>
#import <Three20/Three20.h>


@class DDGridFlowLayout;

@interface DDGridFlowView : UIView <TTScrollViewDataSource>
{
	TTScrollView *m_scrollView;
}

@property (nonatomic, retain) DDGridFlowLayout *layout;

@end
