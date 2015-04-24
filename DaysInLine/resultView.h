//
//  resultView.h
//  DaysInLine
//
//  Created by 张力 on 14-2-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultView : UIView

@property (strong , nonatomic) UILabel *daysCount ;
@property (strong , nonatomic) UILabel *workingLong ;
@property (strong , nonatomic) UILabel *workingTime ;
@property (strong , nonatomic) UILabel *lifeLong ;
@property (strong , nonatomic) UILabel *lifingTime ;
@property (strong , nonatomic) UILabel *mood ;
@property (strong , nonatomic) UILabel *moodLong;
@property (strong , nonatomic) UILabel *grow ;
@property (strong , nonatomic) UILabel *growLong ;
@property (strong , nonatomic) UILabel *incoming ;
@property (strong , nonatomic) UILabel *incomingLong ;
@property (strong , nonatomic) UILabel *expending ;
@property (strong , nonatomic) UILabel *expendingLong ;

@property (strong, nonatomic)  UIButton *continueButton;
@end
