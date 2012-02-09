//
//  UIButton+Additions.h
//
//  Created by Wess Cope on 5/18/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton(Additions)
@property (nonatomic, retain) NSMutableDictionary *backgrounds;

- (void) setBackgroundColor:(UIColor *)bgColor forState:(UIControlState)state;

+ (UIButton *) withColor:(UIColor *)color;
+ (UIButton *) withStartColor:(UIColor *)startColor EndColor:(UIColor *)stopColor; 
+ (UIButton *)inFieldButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action;
@end
