#import "DDGridFlowView.h"
#import "DDGridFlowLayout.h"


@interface DDGridFlowView ()

- (void)initSubviews;

@end

@implementation DDGridFlowView

@synthesize layout = m_layout;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self initSubviews];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self initSubviews];
	}
	return self;
}

- (void)initSubviews
{
	m_scrollView = [[TTScrollView alloc] initWithFrame:self.bounds];
	m_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth
		| UIViewAutoresizingFlexibleHeight;
	m_scrollView.zoomEnabled = NO;
	m_scrollView.dataSource = self;
	[self addSubview:m_scrollView];
}

- (void)dealloc
{
	[m_layout release];
	[m_scrollView release];
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[m_scrollView reloadData];
}

#pragma mark -
#pragma mark TTScrollViewDataSource

- (NSInteger)numberOfPagesInScrollView:(TTScrollView *)scrollView
{
	return m_layout.pages;
}

- (UIView *)scrollView:(TTScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex
{
	UIView *view = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
	[m_layout layoutPage:pageIndex inView:view];
	return view;
}

- (CGSize)scrollView:(TTScrollView *)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex
{
	return self.bounds.size;
}


@end
