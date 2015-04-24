//
//  settingView.h
//  DaysInLine
//
//  Created by 张力 on 14-2-23.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "globalVars.h"

@interface settingView : UIView<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (strong , nonatomic) SevenSwitch *soundSwitch ;
//@property (strong , nonatomic) SevenSwitch *icloudSwitch ;
@property (strong , nonatomic) SevenSwitch *remindSoundSwitch ;
@property (strong , nonatomic) UIView *tipsView;
@property (strong , nonatomic) UIView *passwordView;
@property (strong , nonatomic) UIButton *tips;
@property (strong , nonatomic) UIButton *modifyPassword;
@property (strong , nonatomic) UILabel *tipText;
@property (strong , nonatomic) UITextField *password;
@property (strong , nonatomic) UITextField *password2;
@property (strong , nonatomic) UITextField *userTip;
@property (strong , nonatomic) UIButton *confirmButton;

@property (strong , nonatomic) UITableView *settingTable;
@end
