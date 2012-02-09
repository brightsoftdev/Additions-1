//
//  UIImage+Additions.m
//
//  Created by Wess Cope on 2/11/11.
//  Copyright 2012. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage(Additions)

+ (UIImage *)scaleImage:(UIImage *)incomingImage ToWidth:(CGFloat)width
{
	UIImage *targetImage = nil;
	CGFloat imageWidth = incomingImage.size.width;
	CGFloat imageHeight = incomingImage.size.height;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    CGFloat newHeight = (width*imageHeight)/imageWidth;

	CGSize newSize = CGSizeMake(width, newHeight);
	
	UIGraphicsBeginImageContext(newSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = width;
	thumbnailRect.size.height = newHeight;
	
	[incomingImage drawInRect:thumbnailRect];
	
	targetImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//if(targetImage == nil) NSLog(@"could not scale image");
    
	return targetImage;
}

+ (UIImage *)scaleImage:(UIImage *)incomingImage ToHeight:(CGFloat)height
{
	UIImage *targetImage = nil;
	CGFloat imageWidth = incomingImage.size.width;
	CGFloat imageHeight = incomingImage.size.height;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    CGFloat newWidth = (imageWidth*height)/imageHeight;
    
	CGSize newSize = CGSizeMake(newWidth, height);
	
	UIGraphicsBeginImageContext(newSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = newWidth;
	thumbnailRect.size.height = height;
	
	[incomingImage drawInRect:thumbnailRect];
	
	targetImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//if(targetImage == nil) NSLog(@"could not scale image");
	
	return targetImage;
	
}

+ (UIImage *)resizeImage:(UIImage *)image ToSize:(CGSize)size
{
	UIImage *resultImage = nil;
	
	UIGraphicsBeginImageContext(size);
	CGRect targetFrame = CGRectZero;
	targetFrame.size = size;
	[image drawInRect:targetFrame];
	resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

+ (UIImage *)scaleToSize:(UIImage *)incomingImage targetSize:(CGSize)targetSize
{
	UIImage *sourceImage = incomingImage;
	UIImage *newImage = nil;

	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;

	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;

	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;

		scaleFactor = (widthFactor < heightFactor)? widthFactor : heightFactor;
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;

		if (widthFactor < heightFactor) 
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		else if (widthFactor > heightFactor) 
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
	}

// this is actually the interesting part:

	UIGraphicsBeginImageContext(targetSize);

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if(newImage == nil) NSLog(@"could not scale image");


	return newImage;
}

- (UIImage *)resizeTo:(CGSize)targetSize
{
    return [UIImage resizeImage:self ToSize:targetSize];
}

+ (UIImage *)cropImage:(UIImage *)img toInset:(CGFloat)inset
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
    CGRect newImgFrame = CGRectInset(imageRect, inset, inset);
    
    CGImageRef cropped = CGImageCreateWithImageInRect(img.CGImage, newImgFrame);
    UIImage *returnImage = [UIImage imageWithCGImage:cropped];
    CGImageRelease(cropped);
    
    return returnImage;
}

+ (UIImage *)cropImage:(UIImage *)img toSize:(CGSize)size
{
	CGRect newImgFrame = CGRectZero;
	newImgFrame.size = size;
	
	CGImageRef cropped = CGImageCreateWithImageInRect(img.CGImage, newImgFrame);
	UIImage *returnImage = [UIImage imageWithCGImage:cropped];
	CGImageRelease(cropped);
	
	return returnImage;
}

+ (UIImage *)cropImage:(UIImage *)img toSize:(CGSize)size atPoint:(CGPoint)point
{
	CGRect newImgFrame = CGRectZero;
	newImgFrame.size	= size;
	newImgFrame.origin	= point;
	
	CGImageRef cropped = CGImageCreateWithImageInRect(img.CGImage, newImgFrame);
	UIImage *returnImage = [UIImage imageWithCGImage:cropped];
	CGImageRelease(cropped);
	
	return returnImage;
	
}

+ (UIImage *)ratioScale:(UIImage *)image toRect:(CGRect)frame fromSize:(CGSize)size
{
	CGSize frameSize = frame.size;
	CGSize imageSize = (CGSizeEqualToSize(size, CGSizeZero))? image.size : size;
	
	CGFloat ratio = imageSize.width/imageSize.height;
	
	CGFloat newWidth;
	CGFloat newHeight;
	
	CGFloat widthDifference;
	CGFloat heightDifference;
	
	if(imageSize.width > frameSize.width && imageSize.height > frameSize.height)
	{
		widthDifference = imageSize.width - frameSize.width;

		if(imageSize.height > frameSize.height)
			heightDifference = imageSize.height - frameSize.height;
		
		if(heightDifference >= widthDifference)
		{
			newHeight = frameSize.height;
			newWidth = newHeight*ratio;
		}
		else
		{
			newWidth = frameSize.width;
			newHeight = newWidth/ratio;
		}

	}
	else if(imageSize.width > frameSize.width)
	{
		newWidth = frameSize.width;
		newHeight = newWidth/ratio;		
	}
	else if(imageSize.height > frameSize.height)
	{
		newHeight = frameSize.height;
		newWidth = newHeight*ratio;		
	}
	else 
	{
		newWidth = imageSize.width;
		newHeight = imageSize.height;
	}

	return [UIImage resizeImage:image ToSize:CGSizeMake(newWidth, newHeight)];
}

+ (UIImage *)fillImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions([image size], NO, 0.0);
    CGRect rect = CGRectZero;
    rect.size = image.size;
    
    [color set];
    UIRectFill(rect);
    
    [image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];

    UIImage *filledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filledImage;
}

- (UIImage *)fillImageWithColor:(UIColor *)color
{
    return [UIImage fillImage:self withColor:color];
}

+ (UIImage *)imageFromURL:(NSString *)urlString
{
    UIImage *incoming = nil;
    @try 
    {
        incoming = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    }
    @catch (NSException *exception) 
    {
    }
    
    return incoming;
}

+ (UIImage *)imageNamed:(NSString *)name withShadowColor:(UIColor *)color
{
    UIImage *tmpImage = [UIImage imageNamed:name];
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, tmpImage.size.width + 10, tmpImage.size.height + 10, CGImageGetBitsPerComponent(tmpImage.CGImage), 0, 
                                                       colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(5, -5), 5, color.CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0, 10, tmpImage.size.width, tmpImage.size.height), tmpImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

@end
