//
//  addTagDelegate.h
//  DaysInLine
//
//  Created by 张力 on 13-12-25.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#ifndef DaysInLine_addTagDelegate_h
#define DaysInLine_addTagDelegate_h

@protocol addTagDelegate <NSObject>


@optional
-(void)addTagData:(NSString *)date;

@end

#endif
