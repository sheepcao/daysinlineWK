//
//  UIImage+image_scale.h
//  DaysInLine
//
//  Created by 张力 on 14-7-27.
//  Copyright (c) 2014年 cao yang. All rights reserved.

//



#import <UIKit/UIKit.h>




@interface UIImage (image_scale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;

@end
