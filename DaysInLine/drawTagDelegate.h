//
//  drawTagDelegate.h
//  DaysInLine
//
//  Created by 张力 on 13-12-29.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#ifndef DaysInLine_drawTagDelegate_h
#define DaysInLine_drawTagDelegate_h

@protocol drawTagDelegate <NSObject>

@optional
-(void)drawTag:(NSString *)oldTags;

@end

#endif
