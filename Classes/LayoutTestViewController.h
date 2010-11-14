#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@class DDGridFlowLayout;

@interface LayoutTestViewController : UIViewController <MWFeedParserDelegate>
{
	DDGridFlowLayout *m_layout;
	NSMutableArray *m_feedItems;
}

@end

