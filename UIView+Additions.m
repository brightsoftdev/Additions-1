//
//  UIView+Additions.m
//  
//
//  Created by Wess Cope on 3/2/11.
//  Copyright 2012 Tapmosphere, Inc. All rights reserved.
//

#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

#pragma mark - Draw Rect with Block
@interface FLView : UIView {
    __strong UIViewDrawRect block;
}

- (void)setBlock:(UIViewDrawRect)_block;
@end

@implementation FLView

- (void)setBlock:(UIViewDrawRect)_block
{
    block = [_block copy];
}

- (void)drawRect:(CGRect)rect
{
    if(block)
        block(rect);
}

@end

#pragma mark - Noise Layer

#define kNoiseTileDimension 40
#define kNoiseIntensity 250
#define kNoiseDefaultOpacity 0.4
#define kNoisePixelWidth 0.3

#define JM_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface NoiseLayer : CALayer
+ (UIImage *)noiseTileImage;
+ (void)drawPixelInContext:(CGContextRef)context point:(CGPoint)point width:(CGFloat)width opacity:(CGFloat)opacity whiteLevel:(CGFloat)whiteLevel;
@end

@implementation NoiseLayer

static UIImage * JMNoiseImage;

- (void)setFrame:(CGRect)frame;
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

+ (void)drawPixelInContext:(CGContextRef)context point:(CGPoint)point width:(CGFloat)width opacity:(CGFloat)opacity whiteLevel:(CGFloat)whiteLevel;
{
    CGColorRef fillColor = [UIColor colorWithWhite:whiteLevel alpha:opacity].CGColor;
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGRect pointRect = CGRectMake(point.x - (width/2), point.y - (width/2), width, width);
    CGContextFillEllipseInRect(context, pointRect);
}

+ (UIImage *)noiseTileImage;
{
    if (!JMNoiseImage)
    {
#ifndef __clang_analyzer__
        CGFloat imageScale;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            imageScale = [[UIScreen mainScreen] scale];
        }
        else 
        {
            imageScale = 1;
        }
        
        NSUInteger imageDimension = imageScale * kNoiseTileDimension;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(nil,imageDimension,imageDimension,8,0,
                                                     colorSpace,kCGImageAlphaPremultipliedLast);
        CFRelease(colorSpace);
        
        for (int i=0; i<(kNoiseTileDimension * kNoiseIntensity); i++)
        {
            int x = arc4random() % (imageDimension + 1);
            int y = arc4random() % (imageDimension + 1);
            int opacity = arc4random() % 100;
            CGFloat whiteLevel = arc4random() % 100;
            [NoiseLayer drawPixelInContext:context point:CGPointMake(x, y) width:(kNoisePixelWidth * imageScale) opacity:(opacity) whiteLevel:(whiteLevel / 100.)];
        }
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        if (JM_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0"))
        {
            JMNoiseImage = [[UIImage alloc] initWithCGImage:imageRef scale:imageScale orientation:UIImageOrientationUp];
        }
        else
        {
            JMNoiseImage = [[UIImage alloc] initWithCGImage:imageRef];
        }
#endif
    }
    return JMNoiseImage;
}

- (void)drawInContext:(CGContextRef)ctx;
{
    UIGraphicsPushContext(ctx);
    [[NoiseLayer noiseTileImage] drawAsPatternInRect:self.bounds];
    UIGraphicsPopContext();
}

@end


@implementation UIView(Additions)
-(void)setRoundedCorners:(UIViewRoundedCornerMask)corners radius:(CGFloat)radius 
{
    CGRect rect = self.bounds;
	
	CGFloat minx = CGRectGetMinX(rect);
	CGFloat midx = CGRectGetMidX(rect);
	CGFloat maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect);
	CGFloat midy = CGRectGetMidY(rect);
	CGFloat maxy = CGRectGetMaxY(rect);
    
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, minx, midy);
	CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, (corners & UIViewRoundedCornerUpperLeft) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, (corners & UIViewRoundedCornerUpperRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, (corners & UIViewRoundedCornerLowerRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, (corners & UIViewRoundedCornerLowerLeft) ? radius : 0);
	CGPathCloseSubpath(path);
    
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	[maskLayer setPath:path];
	[[self layer] setMask:nil];
	[[self layer] setMask:maskLayer];
	[maskLayer release];
	CFRelease(path);
}

+ (UIView *)topView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

	if (keyWindow.subviews.count > 0) {
		return [keyWindow.subviews objectAtIndex:0];
	} else {
		return keyWindow;
	}
}

#pragma mark - positioning
- (CGPoint)frameOrigin 
{
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin 
{
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize 
{
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize 
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newSize.width, newSize.height);
}

- (CGFloat)frameX 
{
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX 
{
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY 
{
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY 
{
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight 
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight 
{
	self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom 
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom 
{
	self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth 
{
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth 
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight 
{
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight 
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							self.frame.size.width, newHeight);
}

#pragma mark - Noise
- (void)applyNoise;
{
    [self applyNoiseWithOpacity:kNoiseDefaultOpacity];
}

- (void)applyNoiseWithOpacity:(CGFloat)opacity atLayerIndex:(NSUInteger) layerIndex;
{
    NoiseLayer * noiseLayer = [[[NoiseLayer alloc] init] autorelease];
    [noiseLayer setFrame:self.bounds];
    noiseLayer.masksToBounds = YES;
    noiseLayer.opacity = opacity;
    [self.layer insertSublayer:noiseLayer atIndex:layerIndex];
}

- (void)applyNoiseWithOpacity:(CGFloat)opacity;
{
    [self applyNoiseWithOpacity:opacity atLayerIndex:0];
}

- (void)drawCGNoise;
{
    [self drawCGNoiseWithOpacity:kNoiseDefaultOpacity];
}

- (void)drawCGNoiseWithOpacity:(CGFloat)opacity;
{
    [self drawCGNoiseWithOpacity:opacity blendMode:kCGBlendModeNormal];
}

- (void)drawCGNoiseWithOpacity:(CGFloat)opacity blendMode:(CGBlendMode)blendMode;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, opacity);
    [[NoiseLayer noiseTileImage] drawAsPatternInRect:self.bounds];
    CGContextRestoreGState(context);    
}

#pragma mark - FLView with Draw block

+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(UIViewDrawRect)block
{
    FLView *view = [[FLView alloc] initWithFrame:frame];
    [view setBlock:block];
    
    return view;
}

@end
