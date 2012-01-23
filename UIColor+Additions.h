//
//  UIColor+Additions.h
//
//  Created by Wess Cope on 2/11/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor(Additions)
+ (UIColor *)fromHexString:(NSString *)inColorString;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;
- (UIColor *)invertColor;
- (BOOL)isDark;
@end
