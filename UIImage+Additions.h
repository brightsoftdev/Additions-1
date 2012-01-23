//
//  UIImage+Additions.h
//
//  Created by Wess Cope on 2/11/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(Additions) 

+ (UIImage *)scaleImage:(UIImage *)incomingImage ToWidth:(CGFloat)width;
+ (UIImage *)scaleImage:(UIImage *)incomingImage ToHeight:(CGFloat)height;
+ (UIImage *)scaleToSize:(UIImage *)incomingImage targetSize:(CGSize)targetSize;
+ (UIImage *)resizeImage:(UIImage *)image ToSize:(CGSize)size;
+ (UIImage *)cropImage:(UIImage *)img toInset:(CGFloat)inset;
+ (UIImage *)cropImage:(UIImage *)img toSize:(CGSize)size;
+ (UIImage *)cropImage:(UIImage *)img toSize:(CGSize)size atPoint:(CGPoint)point;
+ (UIImage *)ratioScale:(UIImage *)image toRect:(CGRect)frame fromSize:(CGSize)size;
+ (UIImage *)fillImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageFromURL:(NSString *)urlString;

- (UIImage *)resizeTo:(CGSize)targetSize;
- (UIImage *)fillImageWithColor:(UIColor *)color;
+ (UIImage *)imageNamed:(NSString *)name withShadowColor:(UIColor *)color;
@end
