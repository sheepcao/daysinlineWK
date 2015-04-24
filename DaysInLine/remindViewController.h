//
//  remindViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-12-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remindDataDelegate.h"
//#import <Frontia/Frontia.h>
//#import <iAd/iAd.h>
#import "globalVars.h"
//#import "GADBannerView.h"

//#define ADMOB_ID @"a1531ddc35a4db2"

@interface remindViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *remindMode;

@property (strong, nonatomic)  UIButton *returnButton;
@property (strong, nonatomic)  UIButton *okButton;

@property (strong, nonatomic) NSString *remindDate;
@property (strong, nonatomic) NSString *remindTime;

//@property (strong, nonatomic) ADBannerView *adView;
//@property (strong, nonatomic) ADBannerView *iAdBannerView;
//@property (strong, nonatomic) GADBannerView *gAdBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

@property (weak, nonatomic) NSObject <remindDataDelegate> *setRemindDelegate;
@end
