//
//  UIImage+UIImage_FTAdditions.h
//  Leef
//
//  Created by Kyle Hickinson on 11-08-27.
//  Copyright (c) 2011 Kyle Hickinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FTAdditions)
+ (UIImage *)roundedImage:(UIImage *)image cornerRadius:(CGFloat)radius;
+ (UIImage *)roundedImage:(UIImage *)image cornerRadius:(CGFloat)radius resizeTo:(CGSize)size;
@end
