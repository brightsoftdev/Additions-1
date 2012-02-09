//
//  UIColor+Additions.m
//
//  Created by Wess Cope on 2/11/11.
//  Copyright 2012. All rights reserved.
//

#import "UIColor+Additions.h"


@implementation UIColor(Additions)

+ (UIColor *)fromHexString:(NSString *)inColorString
{
    if([inColorString length] == 3)
        inColorString = [inColorString stringByAppendingString:inColorString];
    
	UIColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [UIColor
			  colorWithRed:		(float)redByte	/ 0xff
			  green:	(float)greenByte/ 0xff
			  blue:	(float)blueByte	/ 0xff
			  alpha:1.0];
	return result;
}



- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;
{
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	int numComponents = CGColorGetNumberOfComponents([self CGColor]);
	CGFloat newComponents[4];
    
	switch (numComponents)
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = newAlpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = newAlpha;
			break;
		}
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
	return retColor;
}

- (UIColor *)invertColor
{
    CGColorRef oldCGColor = self.CGColor;
    
    int numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);

    if (numberOfComponents == 1) 
        return [UIColor colorWithCGColor:oldCGColor];
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i];
    while (--i >= 0) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    return newColor;
}

- (BOOL)isDark
{
    CGColorRef cgColor = self.CGColor;
    const CGFloat *components = CGColorGetComponents(cgColor);
    
    float red       = components[0] / 255.0f;
    float green     = components[1] / 255.0f;
    float blue      = components[2] / 255.0f;
    float tmp       = red;
    float tmpAgain  = red;

    if (blue > tmp)         tmp = blue;
    if (green > tmp)        tmp = green;
    if (blue < tmpAgain)    tmpAgain = blue;
    if (green < tmpAgain)   tmpAgain = green;
    
    return (((tmp + tmpAgain) / 2.0f) < 0.5f);
}
@end
