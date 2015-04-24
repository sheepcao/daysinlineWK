//
//  statisticViewController.h
//  DaysInLine
//
//  Created by 张力 on 14-1-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//


@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "sqlite3.h"
#import "resultView.h"
#import <iAd/iAd.h>
#import "globalVars.h"



@interface statisticViewController : UIViewController<GADBannerViewDelegate>
{
    sqlite3 *dataBase;
    NSString *databasePath;
    
}


@property (strong, nonatomic) GADBannerView  *bannerView;


@property (weak, nonatomic) NSString *startDate;
@property (weak, nonatomic) NSString *endDate;


//@property (strong, nonatomic) ADBannerView *adView;
//@property (strong, nonatomic) ADBannerView *iAdBannerView;
//@property (strong, nonatomic) GADBannerView *gAdBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@end
