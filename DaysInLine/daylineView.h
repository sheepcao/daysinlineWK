//
//  daylineView.h
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dayLineScoller.h"
#import "globalVars.h"

@interface daylineView : UIView

@property (nonatomic,strong) NSMutableArray *starArray;
@property (nonatomic,strong) UIButton *shareBtn ;
@property (nonatomic,strong) UIButton *addMoreWork ;
@property (nonatomic,strong) UIButton *addMoreLife ;
@property (nonatomic,strong) UILabel *dateNow;

@property (nonatomic,strong) dayLineScoller *my_scoller;
@end
