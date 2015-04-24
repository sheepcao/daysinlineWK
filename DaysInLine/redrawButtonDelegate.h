//
//  redrawButtonDelegate.h
//  DaysInLine
//
//  Created by 张力 on 13-11-5.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol redrawButtonDelegate <NSObject>


@optional
-(void)redrawButton:(NSNumber *)startNum :(NSNumber *)endNum :(NSString *)title :(NSNumber *)eventType :(NSNumber *)oldStartNum;
-(void)modifyEvent:(NSNumber *)startArea;

@end
