//
//  statisticViewController.m
//  DaysInLine
//
//  Created by 张力 on 14-1-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "statisticViewController.h"

@interface statisticViewController ()


@end

@implementation statisticViewController

double moodAverage;
double growthAverage;
double work_life[2];
double incomeAll;
double expendAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        moodAverage = 0.0f;
        growthAverage = 0.0f;
        work_life[0] = 0.0f;
        work_life[1] = 0.0f;
        incomeAll = 0.0f;
        expendAll = 0.0f;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backImage;


    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
        backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        NSLog(@"586height:%.2f",self.view.bounds.size.height);
        [backImage setImage:[UIImage imageNamed:@"result586.png"]];
 

    }else{
        backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"height:%.2f",self.view.bounds.size.height);
        [backImage setImage:[UIImage imageNamed:@"result.png"]];
      
    }

    [self.view addSubview:backImage];
    [self.view sendSubviewToBack:backImage];
    
    //AD...
    
    //AD...
    
    
    self.bannerView = [[GADBannerView alloc] init];
    GADRequest *request = [GADRequest request];
    self.bannerView.frame = kAdViewPortraitRect;
    [self.view addSubview:self.bannerView];
    
    
    self.bannerView.adUnitID = ADMOB_ID;
    self.bannerView.delegate  = self;
    //    request.testDevices = @[
    //                                @"bf69fad09ecd3e30b0db75ebdd3570ec"  // Eric's iPod Touch
    //                                ];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:request];
    

//    sharedAdView = [[BaiduMobAdView alloc] init];
//    //sharedAdView.AdUnitTag = @"myAdPlaceId1";
//    //此处为广告位id，可以不进行设置，如需设置，在百度移动联盟上设置广告位id，然后将得到的id填写到此处。
//    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
//    sharedAdView.frame = kAdViewPortraitRect;
//    sharedAdView.delegate = self;
//    [self.view addSubview:sharedAdView];
//    [sharedAdView start];
//    self.gAdBannerView = [[GADBannerView alloc]
//              initWithFrame:CGRectMake(0.0,self.view.frame.size.height - GAD_SIZE_320x50.height,GAD_SIZE_320x50.width,GAD_SIZE_320x50.height)];
//    
//    self.gAdBannerView.adUnitID = ADMOB_ID;//调用id
//    
//    self.gAdBannerView.rootViewController = self;
//    self.gAdBannerView.backgroundColor = [UIColor clearColor];
//    
//    [self.gAdBannerView loadRequest:[GADRequest request]];
//     [self.view addSubview:self.gAdBannerView];
//
//    NSLog(@"admob:%.2f,%.2f",self.gAdBannerView.frame.origin.y,self.gAdBannerView.frame.size.height);
//    
    resultView *my_result = [[resultView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:my_result];
    

    [my_result.continueButton addTarget:self action:@selector(continueButton:) forControlEvents:UIControlEventTouchUpInside];
    //创建或打开数据库
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    databasePath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"infoNew.sqlite"]];
    
    NSLog(@"$$$$$$ %@ , %@$$$$$$",self.startDate,self.endDate);
    

    int days = 0;
    
    sqlite3_stmt *statement_event;
    sqlite3_stmt *statement_days;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,income,expend,startTime,endTime from event where DATE>=\"%@\" AND DATE<=\"%@\"",self.startDate,self.endDate];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement_event, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement_event)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement_event, 0)];
                NSNumber *income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,1)];
                NSNumber *expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,2)];
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,3)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_event,4)];
                
                incomeAll+=[income doubleValue];
                expendAll+=[expend doubleValue];
                work_life[ [evtType intValue] ]+=([endTm doubleValue]-[startTm doubleValue]);
               
            }
            
        }
        
        sqlite3_finalize(statement_event);
        
        //在day表中查询心情和成长指数
        
      
        NSString *queryDayButton = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE>=\"%@\" AND DATE<=\"%@\"",self.startDate,self.endDate];
        const char *queryDaystatement = [queryDayButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryDaystatement, -1, &statement_days, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement_days)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                
                NSNumber *mood = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement_days, 0)];
                NSNumber *growth = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement_days,1)];
                
                moodAverage+=[mood doubleValue];
                growthAverage+=[growth doubleValue];
                days++;
                
            }
            
        }
        
        sqlite3_finalize(statement_days);
        
        
    }else {
        NSLog(@"数据库打开失败aaaa啊啊啊");
        
    }
    
    
    
    
    sqlite3_close(dataBase);
    
    NSLog(@"{%.2f,%.2f,%.2f,%.2f}",incomeAll,expendAll,work_life[0],work_life[1]);
    NSLog(@"{-----%.2f,%.2f-----}",moodAverage,growthAverage);

    
    my_result.daysCount.text = [NSString stringWithFormat:@"%d",days];
    
    int y = self.view.frame.origin.y ;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        y += 5;
    }
    
    /* fit for 4-inch screen */
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        y += 50;
    }else{
    
        y-=10;
    }
    
    
    if (days > 0) {
        
        double workOfAll = 0.0f;
        double lifeOfAll = 0.0f;
        if ((work_life[1]+work_life[0])>0.001) {
            
            workOfAll =work_life[0]/(work_life[1]+work_life[0]);
            lifeOfAll =work_life[1]/(work_life[1]+work_life[0]);
            
        }

        
       // my_result.workingTime.text = [NSString stringWithFormat:@"%.2f小时",work_life[0]/60];
        my_result.workingTime.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f小时",nil),work_life[0]/60];

        my_result.workingLong.frame = CGRectMake(78,y +150, workOfAll*164 , 11);
        
        my_result.lifingTime.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f小时",nil),work_life[1]/60];
        my_result.lifeLong.frame = CGRectMake(78+workOfAll*164,y +150, lifeOfAll*164 , 11);
        
        my_result.moodLong.frame = CGRectMake(78, y+ 212,211*moodAverage/(5*days), 11);
        my_result.mood.frame = CGRectMake(2+my_result.moodLong.frame.origin.x+my_result.moodLong.frame.size.width*7/8, my_result.moodLong.frame.origin.y-19, 30, 16) ;
        my_result.mood.textAlignment = NSTextAlignmentLeft;
        my_result.mood.text = [NSString stringWithFormat:@"%d%%",(int)(100*moodAverage/(5*days))];
        
        my_result.growLong.frame = CGRectMake(78, y+ 257,211*growthAverage/(5*days), 11);
        my_result.grow.frame = CGRectMake(2+my_result.growLong.frame.origin.x+my_result.growLong.frame.size.width*7/8, my_result.growLong.frame.origin.y-19, 30, 16) ;
        my_result.grow.textAlignment = NSTextAlignmentLeft;
        my_result.grow.text = [NSString stringWithFormat:@"%d%%",(int)(100*growthAverage/(5*days))];
        
        NSLog(@"income:%.2f",incomeAll);
        NSLog(@"expend:%.2f",expendAll);

        if (incomeAll >= expendAll) {
            
            if (incomeAll <0.0001) {
                return;
            }
            my_result.incomingLong.frame = CGRectMake(78, y+ 307,211, 11);
            
            my_result.incoming.frame = CGRectMake(2+my_result.incomingLong.frame.origin.x+my_result.incomingLong.frame.size.width*3/4, my_result.incomingLong.frame.origin.y-19, 60, 16) ;
            my_result.incoming.textAlignment = NSTextAlignmentLeft;
            my_result.incoming.text = [NSString stringWithFormat:@"%.2f",incomeAll];
            
            
            my_result.expendingLong.frame = CGRectMake(78, y+ 352,211*expendAll/(incomeAll+0.0001), 11);
            
            [self.view bringSubviewToFront:my_result.expendingLong];
            my_result.expending.frame = CGRectMake(2+my_result.expendingLong.frame.origin.x+my_result.expendingLong.frame.size.width*3/4, my_result.expendingLong.frame.origin.y-19, 60, 16) ;
            my_result.expending.textAlignment = NSTextAlignmentLeft;
            my_result.expending.text = [NSString stringWithFormat:@"%.2f",expendAll];
            
        }else{
            
            my_result.expendingLong.frame = CGRectMake(78, y+ 352,211, 11);
            my_result.expending.frame = CGRectMake(2+my_result.expendingLong.frame.origin.x+my_result.expendingLong.frame.size.width*3/4, my_result.expendingLong.frame.origin.y-19, 60, 16) ;
            my_result.expending.textAlignment = NSTextAlignmentLeft;
            my_result.expending.text = [NSString stringWithFormat:@"%.2f",expendAll];
            
            
            my_result.incomingLong.frame = CGRectMake(78, y+ 307,211*incomeAll/(expendAll+0.0001), 11);
            my_result.incoming.frame = CGRectMake(2+my_result.incomingLong.frame.origin.x+my_result.incomingLong.frame.size.width*3/4, my_result.incomingLong.frame.origin.y-19, 60, 16) ;
            my_result.incoming.textAlignment = NSTextAlignmentLeft;
            my_result.incoming.text = [NSString stringWithFormat:@"%.2f",incomeAll];
            
        }
    }else{
        //所选时段没有任何纪录。
    }
    /*
    self.brifeLabel.text = [NSString stringWithFormat:@"本阶段共有%d天的纪录，各项数据为：",days];
    self.moodScore.text = [NSString stringWithFormat:@"%d分",(int)(100*moodAverage/(5*days))];
    self.growthScore.text = [NSString stringWithFormat:@"%d分",(int)(100*growthAverage/(5*days))];
    self.workTime.text = [NSString stringWithFormat:@"%d小时%d分钟",(int)work_life[0]/60,(int)work_life[0]%60];
    self.lifeTime.text = [NSString stringWithFormat:@"%d小时%d分钟",(int)work_life[1]/60,(int)work_life[1]%60];

    self.incomeTotal.text = [NSString stringWithFormat:@"%.2f元",incomeAll];
    self.expendTotal.text = [NSString stringWithFormat:@"%.2f元",expendAll];
*/



    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    //  NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    //  NSLog(@"current appear tab title %@", cName);
    //[[Frontia getStatistics] pageviewStartWithName:@"statisticView"];
}

-(void) viewDidDisappear:(BOOL)animated
{
    // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    // NSLog(@"current disappear tab title %@", cName);
    //[[Frontia getStatistics] pageviewEndWithName:@"statisticView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueButton:(id)sender {
    if (soundSwitch) {
        
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_dlt;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_dlt);
        AudioServicesPlaySystemSound(soundObject_dlt);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
