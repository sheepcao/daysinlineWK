//
//  statisticView.h
//  DaysInLine
//
//  Created by 张力 on 14-1-26.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface statisticView : UIView

@property (strong,nonatomic) UIButton *resultButton;
//@property (strong,nonatomic) NSString *startDate;
//@property (strong,nonatomic) NSString *endDate;
@property (strong,nonatomic) UIDatePicker *dateEnd;
@property (strong,nonatomic) UIDatePicker *dateStart;
@end
