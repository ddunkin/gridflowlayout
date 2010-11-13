#import "LayoutTestViewController.h"
#import <Three20/Three20.h>
#import "DDCell.h"
#import "DDGridFlowLayout.h"
#import "DDGridFlowLayoutView.h"


@interface LayoutTestViewController ()

- (void)updateLayoutFromInterfaceOrientation;

@end


@implementation LayoutTestViewController

- (DDCell *)cellWithNumber:(int)i
{
	DDCell *cellInfo = [[[DDCell alloc] init] autorelease];
	cellInfo.headingText = [NSString stringWithFormat:@"Heading %d", i];
	NSString *line1 = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel magna in purus consectetur porttitor sed eget diam. In quis nulla diam, nec varius erat. Cras pharetra gravida tellus, vitae posuere quam mattis vitae. Nunc sed lectus massa, non venenatis tortor. Aliquam aliquet interdum libero id sollicitudin. Integer id arcu vitae diam tempor adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas sed felis non turpis tincidunt egestas. Etiam aliquet turpis vel sem accumsan congue. Nulla venenatis pharetra tellus sed egestas. Sed massa turpis, pharetra quis rutrum vestibulum, semper ac augue. Morbi molestie luctus nisl pellentesque vulputate. Vivamus sem odio, aliquam vitae feugiat sed, blandit ac neque. Vivamus vel arcu arcu. Sed porttitor volutpat nibh, sed tristique libero pretium iaculis.";
	NSString *line2 = @"Fusce interdum ullamcorper risus ultricies aliquam. Cras ornare, turpis ac porttitor laoreet, eros sem rutrum sem, eget posuere diam lacus id ante. Donec sit amet est massa. Aenean a eros eu lorem porta sodales. Mauris bibendum magna nec neque rutrum molestie. Nunc elementum blandit nibh, vitae blandit risus aliquet at. Proin posuere lorem nec libero vulputate mollis. Aenean tristique fringilla ligula, a elementum turpis mattis vel. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Curabitur elementum ultrices nisl, eu hendrerit nulla lacinia a. Nulla facilisi. Aenean viverra nunc eu nisl posuere non sagittis tortor malesuada. Aliquam et odio neque. Vestibulum rutrum aliquet orci, nec tempor diam rhoncus sit amet. Aenean sit amet justo enim. Sed a laoreet odio. Sed mollis venenatis lacus quis feugiat.";
	NSString *line3 = @"Duis non enim orci, nec semper metus. Aenean laoreet, ante quis vehicula ornare, erat nulla semper sapien, vel porta lorem arcu et lacus. Vivamus nec ligula dui. Mauris tempor, lectus sit amet aliquet consectetur, velit velit lacinia lacus, a mollis est sapien at diam. Etiam elit lacus, aliquet eget consequat sed, congue nec dui. Sed sagittis ante ut nulla ultrices nec condimentum nisi placerat. Mauris lectus enim, vehicula in hendrerit vitae, congue at nunc. Ut mauris arcu, interdum quis porttitor eget, molestie quis velit. Nulla non justo magna. Donec lorem neque, sodales quis venenatis eu, bibendum a massa. Aliquam convallis ultrices sapien vitae malesuada. Quisque rhoncus tincidunt sapien at rhoncus. Fusce dignissim augue id tortor iaculis id ullamcorper sapien ultricies. Fusce in dui at lacus scelerisque ornare id at nisi. Sed in rutrum diam. Praesent lectus leo, tempus eu placerat at, auctor vel nunc. Proin vel lacinia erat. Nullam a consequat ligula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi condimentum vestibulum leo at accumsan.";
	NSString *line4 = @"Donec sed ipsum vitae augue placerat sagittis. Donec mollis dictum odio, eget consectetur odio vestibulum ut. Vivamus sagittis augue molestie arcu volutpat vitae consequat neque porta. Duis a ipsum id magna tempor bibendum ut in sapien. In hac habitasse platea dictumst. Curabitur varius, tellus id bibendum elementum, nunc nisi scelerisque nisi, ac dignissim arcu nulla ut metus. Nam sit amet tellus enim, vel euismod odio. Duis sed massa tortor, sit amet pharetra urna. Maecenas vitae scelerisque neque. Sed tincidunt pellentesque ultricies. Nullam neque tellus, sagittis et aliquet at, vestibulum vel felis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse vel velit sem, a tristique risus. Duis id elit in arcu vehicula feugiat. Suspendisse potenti.";
	cellInfo.bodyText = [NSString stringWithFormat:@"\t%@\n\n\t%@\n\n\t%@\n\n\t%@", line1, line2, line3, line4];
	return cellInfo;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	m_layout = [[DDGridFlowLayout alloc] init];
	[self updateLayoutFromInterfaceOrientation];
	
	DDCell *cell = [self cellWithNumber:1];
	cell.rowSpan = 3;
	cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
	cell.padding = 5;
	[m_layout addCell:cell];

	cell = [self cellWithNumber:2];
	cell.columnSpan = 4;
	[m_layout addCell:cell];
	
	cell = [self cellWithNumber:3];
	cell.columnSpan = 3;
	cell.headingText = @"Heading 3 is a longer headline than the others";
	[m_layout addCell:cell];

	[m_layout addCell:[self cellWithNumber:4]];

	cell = [self cellWithNumber:5];
	cell.rowSpan = 2;
	cell.columnSpan = 2;
	[m_layout addCell:cell];
	
	cell = [self cellWithNumber:6];
	cell.rowSpan = 2;
	cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
	cell.padding = 5;
	[m_layout addCell:cell];
	
	for (int i = 7; i < 15; i++)
	{
		DDCell *cell = [self cellWithNumber:i];
		[m_layout addCell:cell];
	}

	((DDGridFlowLayoutView *)self.view).layout = m_layout;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self updateLayoutFromInterfaceOrientation];
	[self.view setNeedsLayout];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)dealloc
{
	[m_layout release];
    [super dealloc];
}

- (void)updateLayoutFromInterfaceOrientation
{
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
	{
		m_layout.rows = 5;
		m_layout.columns = 4;
	}
	else if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
	{
		m_layout.rows = 4;
		m_layout.columns = 5;
	}
}

@end
