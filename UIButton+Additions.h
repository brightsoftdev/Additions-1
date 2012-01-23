//
//  UIButton+Additions.h
//
//  Created by Wess Cope on 5/18/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton(Additions)
+ (UIButton *) withColor:(UIColor *)color;
+ (UIButton *) withStartColor:(UIColor *)startColor EndColor:(UIColor *)stopColor; 
+ (UIButton *)inFieldButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action;
@end
