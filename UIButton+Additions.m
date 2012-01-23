//
//  UIButton+Additions.m
//
//  Created by Wess Cope on 5/18/11.
//  Copyright 2012. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIButton+Additions.h"


@implementation UIButton(Additions)

+ (UIButton *) withColor:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.5f] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0.0f, 0.0f, 300.0f, 46.0f);
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    button.layer.cornerRadius = 6.0f;
    
    return button;
}

+ (UIButton *) withStartColor:(UIColor *)startColor EndColor:(UIColor *)stopColor
{
    UIButton *button = [UIButton withColor:[UIColor whiteColor]];
    button.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = button.frame;
    gradient.cornerRadius = 6.0f;
    
    CGColorRef cgStop  = [stopColor CGColor];
    CGColorRef cgStart = [startColor CGColor];
    
    gradient.colors = [NSArray arrayWithObjects:(id)cgStart, (id)cgStop, nil];
    [button.layer insertSublayer:gradient below:button.titleLabel.layer];

    return button;
}

+ (UIButton *)inFieldButtonWithImage:(UIImage *)img target:(id)target action:(SEL)action
{
    UIImage *offImage = [UIImage scaleToSize:img targetSize:CGSizeMake(16.0f, 16.0f)];
    UIImage *onImage  = [UIImage fillImage:offImage withColor:[UIColor fromHexString:@"73aff8"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 16.0f, 16.0f);
    
    [button setImage:offImage forState:UIControlStateNormal];
    [button setImage:onImage forState:UIControlStateHighlighted];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
