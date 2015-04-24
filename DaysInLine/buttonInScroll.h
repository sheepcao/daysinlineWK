//
//  buttonInScroll.h
//  DaysInLine
//
//  Created by 张力 on 13-10-21.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redrawButtonDelegate.h"

@interface buttonInScroll : UIView <redrawButtonDelegate> 
@property (nonatomic,strong) UIButton *oneWork ;
@property (nonatomic,strong) UIButton *oneLife ;

@end
