//
//  ViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAd.h>
//#import "GADBannerView.h"
#import "sqlite3.h"
#import "redrawButtonDelegate.h"
#import "drawTagDelegate.h"
#import "reloadTableDelegate.h"
#import "setMainTextDelegate.h"
#import <StoreKit/SKStoreProductViewController.h>

//#define ADMOB_ID @"a1531ddc35a4db2"

@class homeView;
@class daylineView;

@interface ViewController : UIViewController <redrawButtonDelegate,reloadTableDelegate,setMainTextDelegate,ADBannerViewDelegate,GADBannerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
{
    sqlite3 *dataBase;
    NSString *databasePath;
    
    enum WXScene _scene;  //for weixin share.


   
}


@property (strong, nonatomic) GADBannerView  *bannerView;

@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
@property (weak, nonatomic) NSObject <drawTagDelegate> *drawLabelDelegate;


@property (nonatomic,strong) UIView *finalShare;
@property (nonatomic,strong) UIImage *shareImg;
@property (nonatomic,strong) UIActionSheet *shareSheet;

//@property (strong, nonatomic) ADBannerView *iAdBannerView;
//@property (strong, nonatomic) GADBannerView *gAdBannerView;
//@property (strong, nonatomic) NSNumber *failLoadiAD;
@property (nonatomic, assign) BOOL bannerIsVisible;
@end
