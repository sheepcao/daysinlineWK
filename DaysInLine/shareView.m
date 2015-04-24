//
//  shareView.m
//  DaysInLine
//
//  Created by 张力 on 14-6-15.
//  Copyright (c) 2014年 cao yang. All rights reserved.
//

#import "shareView.h"

@implementation shareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.25f); //设置线的宽度 为1个像素
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    CGContextMoveToPoint(context,36+5, self.frame.origin.y);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.origin.y);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 0.25f); //设置线的宽度 为1.5个像素
    CGContextMoveToPoint(context, self.frame.size.width/2+18+0.1, self.frame.origin.y-10);
    CGContextAddLineToPoint(context, self.frame.size.width/2+18+0.1, self.frame.size.height-20);
    CGContextStrokePath(context);
    
    //  CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    
}

@end
