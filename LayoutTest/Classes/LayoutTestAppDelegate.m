#import "LayoutTestAppDelegate.h"
#import "LayoutTestViewController.h"

@implementation LayoutTestAppDelegate

@synthesize window = m_window;
@synthesize viewController = m_viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after app launch. 
    [self.window addSubview:m_viewController.view];
    [self.window makeKeyAndVisible];

	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    [m_viewController release];
    [m_window release];
    [super dealloc];
}

@end
