#import <UIKit/UIKit.h>

@class LayoutTestViewController;

@interface LayoutTestAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *m_window;
    LayoutTestViewController *m_viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LayoutTestViewController *viewController;

@end

