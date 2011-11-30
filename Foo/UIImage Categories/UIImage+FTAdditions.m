//
//  UIImage+UIImage_FTAdditions.m
//  Leef
//
//  Created by Kyle Hickinson on 11-08-27.
//  Copyright (c) 2011 Kyle Hickinson. All rights reserved.
//

#import "UIImage+FTAdditions.h"

@implementation UIImage (FTAdditions)

+ (UIImage *)roundedImage:(UIImage *)image cornerRadius:(CGFloat)radius
{
    return [self roundedImage:image cornerRadius:radius resizeTo:CGSizeZero];
}

+ (UIImage *)roundedImage:(UIImage *)image cornerRadius:(CGFloat)radius resizeTo:(CGSize)size
{
	UIImage * newImage = nil;
    
    int w = (size.width == 0 ? image.size.width : size.width);
	int h = (size.height == 0 ? image.size.height : size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, w, h) cornerRadius:radius];
    CGContextAddPath(context, roundedPath.CGPath);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    newImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return newImage;
}


@end