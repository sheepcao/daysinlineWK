//
//  globalVars.h
//  DaysInLine
//
//  Created by 张力 on 13-11-5.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#ifndef DaysInLine_globalVars_h
#define DaysInLine_globalVars_h



#import "MobClick.h"
int workArea[96] ;
int lifeArea[96] ;
NSString *modifyDate;
NSString *userTips;
NSString *password;

//BOOL hasTheDay;

int modifying;
int modifyEventId;

BOOL soundSwitch;
BOOL remindSwitch;
//int startDay; //1 = sunday, 2 = monday

#define NR_IMAGEVIEW 5
#define IMAGEVIEW_TAG_BASE 200
#define mainHeight 150

#define kAdViewPortraitRect CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-48,[[UIScreen mainScreen] bounds].size.width,48)
#define VERSIONNUMBER   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ADMOB_ID @"ca-app-pub-3074684817942615/1126186689"
//#define IMAGEBUTTON_TAG_BASE 300

#define REVIEW_URL_CN @"http://itunes.apple.com/cn/app/daysinline/id844914780?mt=8"

#define REVIEW_URL_EN @"http://itunes.apple.com/us/app/daysinline/id844914780?mt=8"

#define ALLAPP_URL @"http://itunes.apple.com/us/artist/cao-guangxu/id844914783"

#endif
