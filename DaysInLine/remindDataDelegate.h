//
//  remindDataDelegate.h
//  DaysInLine
//
//  Created by 张力 on 13-12-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#ifndef DaysInLine_remindDataDelegate_h
#define DaysInLine_remindDataDelegate_h
#import <Foundation/Foundation.h>

@protocol remindDataDelegate <NSObject>


@optional
-(void)setRemindData:(NSString *)date :(NSString *)time;

@end


#endif
