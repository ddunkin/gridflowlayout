#import "DDGridFlowLayoutView.h"
#import "DDGridFlowLayout.h"


@implementation DDGridFlowLayoutView

@synthesize layout = m_layout;

- (void)dealloc
{
	[m_layout release];
	[super dealloc];
}

- (void)layoutSubviews
{
	for (UIView *subview in self.subviews)
	{
		[subview removeFromSuperview];
	}
	[m_layout layoutInView:self];
}

@end
