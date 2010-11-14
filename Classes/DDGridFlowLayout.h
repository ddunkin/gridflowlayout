#import <Foundation/Foundation.h>


@class DDCell;

@interface DDGridFlowLayout : NSObject {

}

@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) CGSize margin;
@property (nonatomic, assign) CGSize spacing;

- (id)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns;
- (void)addCell:(DDCell *)cellInfo;
- (void)removeCell:(DDCell *)cellInfo;
- (void)removeAllCells;
- (void)layoutInView:(UIView *)view;

@end
