//
//  UIView+Additions.h
//
//  Created by Wess Cope on 3/2/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^UIViewDrawRect)(UIView *view, CGRect rect);

enum {
    UIViewRoundedCornerNone = 0,
    UIViewRoundedCornerUpperLeft = 1 << 0,
    UIViewRoundedCornerUpperRight = 1 << 1,
    UIViewRoundedCornerLowerLeft = 1 << 2,
    UIViewRoundedCornerLowerRight = 1 << 3,
    UIViewRoundedCornerAll = (1 << 4) - 1,
};
typedef NSInteger UIViewRoundedCornerMask;

@interface UIView(Additions)
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

// Can be used directly on UIView
- (void)applyNoise;
- (void)applyNoiseWithOpacity:(CGFloat)opacity atLayerIndex:(NSUInteger) layerIndex;
- (void)applyNoiseWithOpacity:(CGFloat)opacity;

// Can be invoked from a drawRect() method
- (void)drawCGNoise;
- (void)drawCGNoiseWithOpacity:(CGFloat)opacity;
- (void)drawCGNoiseWithOpacity:(CGFloat)opacity blendMode:(CGBlendMode)blendMode;

-(void)setRoundedCorners:(UIViewRoundedCornerMask)corners radius:(CGFloat)radius;
+ (UIView *)topView;

+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(UIViewDrawRect)block;
@end
