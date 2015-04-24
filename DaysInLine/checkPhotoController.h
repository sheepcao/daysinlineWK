//
//  checkPhotoController.h
//  DaysInLine
//
//  Created by 张力 on 14-2-9.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>
#import "globalVars.h"
//#import "GADBannerView.h"

//#define ADMOB_ID @"a1531ddc35a4db2"


@interface checkPhotoController : UIViewController

//<ADBannerViewDelegate,GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fullPhoto;
- (IBAction)backToEdit:(UIButton *)sender;


//@property (strong, nonatomic) ADBannerView *adView;
//@property (strong, nonatomic) ADBannerView *iAdBannerView;
//@property (strong, nonatomic) GADBannerView *gAdBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@end
