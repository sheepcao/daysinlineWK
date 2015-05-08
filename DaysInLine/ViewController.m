//
//  ViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "ViewController.h"
#import "homeView.h"
#import "daylineView.h"
#import "selectView.h"
#import "dayLineScoller.h"
#import "buttonInScroll.h"
#import "editingViewController.h"
#import "collectionView.h"
#import "statisticView.h"
#import "statisticViewController.h"
#import "settingView.h"
#import "contractView.h"
#import "buttonTranslate.h"
#import "rightTranslate.h"
#import "globalVars.h"


//#import "JSONKit.h"
//#import <Frontia/Frontia.h>



@interface ViewController ()<CKCalendarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIActionSheetDelegate>

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) daylineView *my_selectDay ;
//@property (nonatomic,strong) dayLineScoller *my_scoller;
//@property (nonatomic,strong) dayLineScoller *my_selectScoller;
@property (nonatomic,strong) selectView *my_select ;
@property (nonatomic,strong) collectionView *my_collect;
@property (nonatomic,strong) statisticView *my_analyse;
@property (nonatomic,strong) settingView *my_setting;
@property (nonatomic,strong) buttonTranslate *my_buttonTranslate;
@property (nonatomic,strong) contractView *my_contractView;
@property (nonatomic,strong) rightTranslate *my_rightTranslate;


@property (nonatomic,strong) NSString *today;
@property (nonatomic,strong) NSString *lastToday;
@property (nonatomic,strong) NSMutableArray *allTags;
@property(nonatomic, strong) NSMutableArray *HasEventsDates;

@property(nonatomic, strong) NSMutableArray *tableLeft;
@property(nonatomic, strong) NSMutableArray *tableRight;
@property(nonatomic, strong) NSMutableArray *EventsInTag;
@property(nonatomic, strong) NSMutableArray *EventDateInTag;
@property(nonatomic, strong) NSMutableArray *EventsInSearch;
@property(nonatomic, strong) NSMutableArray *EventDateInSearch;
@property(nonatomic, strong) NSMutableArray *EventsIDInTag;
@property(nonatomic, strong) NSMutableArray *EventsIDInSearch;

@property(nonatomic, strong) NSString *dateToSelect;
@property(nonatomic, strong) NSString *pickAdate;
@property(nonatomic, strong) NSString *textInMain;

@property(nonatomic, strong) NSMutableArray *collectEvent;
@property(nonatomic, strong) NSMutableArray *collectEventTitle;
@property(nonatomic, strong) NSMutableArray *collectEventTag;
@property(nonatomic, strong) NSMutableArray *collectEventDate;
@property(nonatomic, strong) NSMutableArray *collectEventStart;
@property(nonatomic, strong) NSMutableArray *collectEventEnd;

@property(nonatomic, strong) NSArray *cellBackground;
@property(nonatomic, strong) NSArray *settingInformation;
@property(nonatomic, strong) NSArray *settingInformationLeft;
@property(nonatomic, strong) NSArray *settingInformationRight;



@property (strong, nonatomic) IBOutlet UITableViewCell *cellinCollection;


@end

@implementation ViewController
const int LABEL_SPACE  = 30;




SystemSoundID soundFileObject;
bool todayRedrawDone;
bool hasPassWord;

bool selectedDayRedrawDone;
int collectNum;
int inwhichButton;//0=mainView,1=today,2=select,3=collect,4=analyse,5=setting.
//int failLoadiAD;

- (void)viewDidLoad
{
    
       [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundHome.png"]];


    
	// Do any additional setup after loading the view, typically from a nib.
    self.allTags = [[NSMutableArray alloc] init];
    self.EventsInTag = [[NSMutableArray alloc] init];
    self.EventDateInTag = [[NSMutableArray alloc] init];
    self.EventsIDInTag = [[NSMutableArray alloc] init];
    
    self.EventsInSearch = [[NSMutableArray alloc] init];
    self.EventDateInSearch = [[NSMutableArray alloc] init];
    self.EventsIDInSearch = [[NSMutableArray alloc] init];
    
    self.collectEvent = [[NSMutableArray alloc] init];
    self.collectEventTitle = [[NSMutableArray alloc] init];
    self.collectEventTag = [[NSMutableArray alloc] init];
    self.collectEventDate = [[NSMutableArray alloc] init];
    self.collectEventStart = [[NSMutableArray alloc] init];
    self.collectEventEnd = [[NSMutableArray alloc] init];
    
    
    self.settingInformation = [[NSArray alloc] initWithObjects:NSLocalizedString(@"按钮释义",nil),NSLocalizedString(@"团队作品",nil),NSLocalizedString(@"关于我们",nil), nil];
    self.settingInformationLeft = [[NSArray alloc] initWithObjects:NSLocalizedString(@"版本",nil),@"QQ",@"email", nil];
    
    self.settingInformationRight = [[NSArray alloc] initWithObjects:VERSIONNUMBER,@"82107815",@"sheepcao1986@163.com", nil];

    
    self.cellBackground = [[NSArray alloc] initWithObjects:@"cell1-1",@"cell2-1",@"cell3-1",@"cell4-1", nil];
    
    homeView *my_homeView = [[homeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:my_homeView];
    self.homePage = my_homeView;
    
    [my_homeView.todayButton addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.selectButton addTarget:self action:@selector(selectTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.treasureButton addTarget:self action:@selector(treasureTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.analyseButton addTarget:self action:@selector(analyseTapped) forControlEvents:UIControlEventTouchUpInside];
    [my_homeView.exitButton addTarget:self action:@selector(settingTapped) forControlEvents:UIControlEventTouchUpInside];

    
    
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        CGRect frame7 = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y+5, self.view.frame.size.width-85, self.view.frame.size.height-5 );
            
        NSLog(@"frame here is :%f  y, %f   height",frame7.origin.y,frame7.size.height);
            
        
        self.my_select = [[selectView alloc] initWithFrame:frame7];
        self.my_dayline = [[daylineView alloc] initWithFrame:frame7];
        self.my_collect = [[collectionView alloc] initWithFrame:frame7];
        self.my_analyse = [[statisticView alloc] initWithFrame:frame7];
        self.my_selectDay = [[daylineView alloc] initWithFrame:frame7];
        self.my_rightTranslate = [[rightTranslate alloc] initWithFrame:frame7];
      // self.my_setting = [[settingView alloc] initWithFrame:frame7];

        NSLog(@"ios7!!!!");
    }else{
        
        CGRect frame = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y-20, self.view.frame.size.width-85, self.view.frame.size.height );
        
        NSLog(@"frame here is :%f  y, %f   height",frame.origin.y,frame.size.height);
        
       
        self.my_select = [[selectView alloc] initWithFrame:frame];
        self.my_dayline = [[daylineView alloc] initWithFrame:frame];
        self.my_collect = [[collectionView alloc] initWithFrame:frame];
        self.my_analyse = [[statisticView alloc] initWithFrame:frame];
        self.my_selectDay = [[daylineView alloc] initWithFrame:frame];
        self.my_rightTranslate = [[rightTranslate alloc] initWithFrame:frame];

       // self.my_setting = [[settingView alloc] initWithFrame:frame];
    }
    

    
    
    self.my_select.calendar.delegate = self;
    self.my_select.eventsTable.delegate = self;
    self.my_select.eventsTable.dataSource = self;
    self.my_select.alltagTable.delegate = self;
    self.my_select.alltagTable.dataSource = self;
    self.my_select.eventInTagTable.delegate = self;
    self.my_select.eventInTagTable.dataSource = self;
    self.my_select.my_searchBar.delegate = self;
    self.my_select.eventInSearchTable.delegate = self;
    self.my_select.eventInSearchTable.dataSource = self;
    self.my_collect.collectionTable.delegate = self;
    self.my_collect.collectionTable.dataSource = self;
    
    [self.my_rightTranslate.todayTanslate addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_rightTranslate.selectTanslate addTarget:self action:@selector(selectTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_rightTranslate.collectTanslate addTarget:self action:@selector(treasureTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_rightTranslate.analyseTanslate addTarget:self action:@selector(analyseTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_rightTranslate.settingTanslate addTarget:self action:@selector(settingTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.homePage addSubview:self.my_dayline];
    [self.homePage addSubview:self.my_select];
    [self.homePage addSubview:self.my_collect];
    [self.homePage addSubview:self.my_analyse];
    [self.homePage addSubview:self.my_selectDay];
    [self.homePage addSubview:self.my_rightTranslate];


    
    
    [self.my_rightTranslate setHidden:NO];

    [self.my_dayline setHidden:YES];
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_collect setHidden:YES];
    [self.my_analyse setHidden:YES];
    
    //初始化全局数据
    for (int i=0; i<96; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    modifying = 0;
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.today= [formater stringFromDate:curDate];
    
    //eric:fix for apple watch
    modifyDate = self.today;

    NSLog(@"!!!!!!!%@",self.today);
    
    
    
    //创建或打开数据库

    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    databasePath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"infoNew.sqlite"]];
    
    //   NSFileManager *filemanager = [NSFileManager defaultManager];
    
    
    NSString *priorDB = [self checkPriorDB];
    
    if(priorDB)
    {
        NSError *error;
        
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:priorDB
                                                               toPath:databasePath
                                                                error:&error];
        
        NSLog(@"copy Error description-%@ \n", [error localizedDescription]);
        NSLog(@"copy Error reason-%@", [error localizedFailureReason]);
        NSLog(@"copy success:%d",success);
        
        if (success) {
            
            BOOL success_delete =  [[NSFileManager defaultManager] removeItemAtPath:priorDB error:&error];
            NSLog(@"delete Error description-%@ \n", [error localizedDescription]);
            NSLog(@"delete Error reason-%@", [error localizedFailureReason]);
            
            NSLog(@"delete success:%d",success_delete);
            
        }
        
    }
    

    
    
    NSLog(@"路径：%@",databasePath);
    sqlite3_stmt *statement;
    sqlite3_stmt *statement_1;
    sqlite3_stmt *statement_2;
    sqlite3_stmt *statement_3;
    sqlite3_stmt *statement_4;
    sqlite3_stmt *statement_5;


    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        /*           NSString *createsql = @"CREATE TABLE IF NOT EXISTS DAYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,DATE TEXT UNIQUE,MOOD INTEGER,GROWTH INTEGER)";
         */
        NSString *createDayable = @"CREATE TABLE IF NOT EXISTS DAYTABLE (DATE TEXT PRIMARY KEY,MOOD INTEGER,GROWTH INTEGER)";
        NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime REAL,endTime REAL,distance TEXT,label TEXT,remind TEXT,startArea INTEGER,photoDir TEXT)";
        //      NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";
        NSString *createTag = @"CREATE TABLE IF NOT EXISTS TAG (tagID INTEGER PRIMARY KEY AUTOINCREMENT,tagName TEXT UNIQUE)";
        
        NSString *createCollect = @"CREATE TABLE IF NOT EXISTS collection (collectionID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER)";
        
        NSString *createGlobal = @"CREATE TABLE IF NOT EXISTS globalVar (varName TEXT PRIMARY KEY,value INTEGER)";
        NSString *createPassword = @"CREATE TABLE IF NOT EXISTS passwordVar (varName TEXT PRIMARY KEY,value TEXT)";
        
        [self execSql:createDayable];
        [self execSql:createEvent];
        [self execSql:createTag];
        [self execSql:createCollect];
        [self execSql:createGlobal];
        [self execSql:createPassword];
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    self.HasEventsDates = [[NSMutableArray alloc] init];
  //  NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *queryDays = [NSString stringWithFormat:@"SELECT DATE from DAYTABLE"];
    const char *queryDaystatement = [queryDays UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryDaystatement, -1, &statement_1, NULL)==SQLITE_OK) {
        NSLog(@"select success!!!");
        while (sqlite3_step(statement_1)==SQLITE_ROW) {
            //找到存在的日期，设置日历上的有事件的日期
            NSLog(@"find something!!!!");
            char *date = (char *) sqlite3_column_text(statement_1, 0);
            NSString *dateWithEvent = [NSString stringWithUTF8String:date];
            NSLog(@"date is : %@",[dateFormatter dateFromString:dateWithEvent]);
            NSDate *dateUnconvert = [dateFormatter dateFromString:dateWithEvent];
     //      NSInteger zoneInterval = [zone secondsFromGMTForDate: dateUnconvert];
            
            [self.HasEventsDates addObject:dateUnconvert];
            //[self.HasEventsDates addObject:[dateUnconvert dateByAddingTimeInterval:zoneInterval]];
        }
        
        
       // NSLog(@"%@",self.HasEventsDates);
    }else {
        NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
    }
    
    sqlite3_finalize(statement_1);
    
    
    
    
    NSString *queryStar = [NSString stringWithFormat:@"SELECT tagname from TAG"];
    const char *queryStarstatement = [queryStar UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原界面
            char *tagName = (char *) sqlite3_column_text(statement, 0);
            [self.allTags addObject:[NSString stringWithUTF8String:tagName]];
            
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement);
    
    NSString *soundName = @"soundSwitch";
    
    NSString *querySound= [NSString stringWithFormat:@"SELECT value from globalVar where varName=\"%@\"",soundName];
    const char *querySoundstatement = [querySound UTF8String];
    if (sqlite3_prepare_v2(dataBase, querySoundstatement, -1, &statement_2, NULL)==SQLITE_OK) {
        if  (sqlite3_step(statement_2)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原界面
            int sound = sqlite3_column_int(statement_2, 0);
            soundSwitch = sound;
            
            
        }else{
            soundSwitch = YES;
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement_2);
    
    
    NSString *remindSoundName = @"remindSwitch";
    
    NSString *queryRemindSound= [NSString stringWithFormat:@"SELECT value from globalVar where varName=\"%@\"",remindSoundName];
    const char *queryRemindstatement = [queryRemindSound UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryRemindstatement, -1, &statement_3, NULL)==SQLITE_OK) {
        if  (sqlite3_step(statement_3)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原界面
            int remindSound = sqlite3_column_int(statement_3, 0);
            remindSwitch = remindSound;
            
            
        }else{
            remindSwitch = NO;
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement_3);
  
    NSString *passwordName = @"password";
    
    NSString *queryPassword= [NSString stringWithFormat:@"SELECT value from passwordVar where varName=\"%@\"",passwordName];
    const char *queryPasswordStatement = [queryPassword UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryPasswordStatement, -1, &statement_4, NULL)==SQLITE_OK) {
        if  (sqlite3_step(statement_4)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原密码
          //  char *date = (char *) sqlite3_column_text(statement_1, 0);
         //   NSString *dateWithEvent = [NSString stringWithUTF8String:date];

            char *pswd = (char *) sqlite3_column_text(statement_4, 0);
            NSString *pswdText = [NSString stringWithUTF8String:pswd];
            password = pswdText;
            
            
        }else{
            password = nil;
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement_4);
    
    
    NSString *tipName = @"tips";
    
    NSString *queryTip= [NSString stringWithFormat:@"SELECT value from passwordVar where varName=\"%@\"",tipName];
    const char *queryTipStatement = [queryTip UTF8String];
    if (sqlite3_prepare_v2(dataBase, queryTipStatement, -1, &statement_5, NULL)==SQLITE_OK) {
        if  (sqlite3_step(statement_5)==SQLITE_ROW) {
            //当天数据已经存在，则取出数据还原密码提示
            char *tp = (char *)sqlite3_column_text (statement_5, 0);
            NSString *tpText = [NSString stringWithUTF8String:tp];
            userTips = tpText;
            
            
        }else{
            userTips = @"";
        }
        
        //[allTags addObject:nil];
        // NSLog(@"%@",self.allTags[5]);
    }
    sqlite3_finalize(statement_5);

    
    
    sqlite3_close(dataBase);
    
    
    CFBundleRef mainbundle=CFBundleGetMainBundle();
   // SystemSoundID soundFileObject;
    //获得声音文件URL
    CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("editSound"),CFSTR("wav"),NULL);
    //创建system sound 对象
    AudioServicesCreateSystemSoundID(soundfileurl, &soundFileObject);
    
    
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
    
    
    //每天晚上8点半提醒用户记录
  
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification) {
        //NSLog(@"%@",localNotification.userInfo);
        NSString * alarmValue=[localNotification.userInfo objectForKey:@"key"];
        NSLog(@"alarmValue:%@",alarmValue);
        if ([@"name" isEqualToString:alarmValue]) {
        //   [[UIApplication sharedApplication] cancelLocalNotification:localNotification];

        return;
        }else
        {
            
            NSDate *date = [NSDate date];
            NSLog(@"now 2date is: %@",date);
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
            
            long year = [dateComponent year];
            long month = [dateComponent month];
            long day = [dateComponent day];
            
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"yyyy-MM-dd"];
            NSString *datestring = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day+2];
            NSLog(@"datestring:%@",datestring);
            NSDate * newdate = [formatter2 dateFromString:datestring];
            NSLog(@"newdate:%@",newdate);
            
            int sinceNow = [newdate timeIntervalSinceNow];
            
            NSLog(@"sineNow:%f",sinceNow-3.5*60*60);
            
            
            // [date timeIntervalSince1970];
            
            
            UILocalNotification *noti = [[UILocalNotification alloc] init] ;
            if (noti) {
                //设置推送时间
                noti.fireDate = [date dateByAddingTimeInterval:(sinceNow-3.5*60*60)];
                //设置时区
                noti.timeZone = [NSTimeZone defaultTimeZone];
                //设置重复间隔
                noti.repeatInterval = NSDayCalendarUnit;
                //推送声音
                noti.soundName = UILocalNotificationDefaultSoundName;
                //内容
                noti.alertBody = NSLocalizedString(@"不积跬步无以至千里，不积小流无以成江海。有序生活从点滴做起。",nil);
                NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
                noti.userInfo = infoDic;
                NSLog(@"info:%@",noti.userInfo);
                //添加推送到uiapplication
                UIApplication *app = [UIApplication sharedApplication];
                [app scheduleLocalNotification:noti];
            }
        }
    }

   //   NSLog(@"alarmValue:%@",alarmValue);

    

 
}


-(void) viewDidAppear:(BOOL)animated
{
    
//    [self.view addSubview:self.gAdBannerView];

    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.bannerView];

    static int times = 0;
    times++;
    

    if (times>1)
    {
        [self saveScreenshotForWatch];
    }

    

    
}

-(void)saveScreenshotForWatch
{
    [self shareTappedWithActionSheet:nil];
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    NSString *myImageName = [NSString stringWithFormat:@"%@.png",modifyDate];
    NSString *dayImagePath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:myImageName]];
    
    
    NSLog(@"image Path:%@",dayImagePath);
    
    
    NSError *error;
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:dayImagePath] == YES)
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:dayImagePath error:&error];
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
        
    }
    
    
    NSData *imageData = UIImagePNGRepresentation(self.shareImg);
    BOOL success = [imageData writeToFile:dayImagePath atomically:NO];
    NSLog(@"save image success:%d",success);

}

-(void) viewDidDisappear:(BOOL)animated
{
   // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
   // NSLog(@"current disappear tab title %@", cName);
    //[[Frontia getStatistics] pageviewEndWithName:@"mainView"];
}

-(NSString *)checkPriorDB
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dbPath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        return dbPath;
    }
    else return nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)todayTapped
{

    [MobClick event:@"today"];

    
    [self.my_select dismissKeyboard];
    

    
    if (soundSwitch) {
        
    
    AudioServicesPlaySystemSound(soundFileObject);
    }

    
    for (int i=0; i<96; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }

    inwhichButton = 1;
//    if ( self.bannerIsVisible ) {
//        [self.iAdBannerView removeFromSuperview];
//
//    }else{
//        [self.gAdBannerView removeFromSuperview];
//    }
    
    [self.bannerView setHidden:YES];
    
    //获取当前日期
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.today= [formater stringFromDate:curDate];
    
    
    sqlite3_stmt *statement;
    
    [self.my_rightTranslate setHidden:YES];

    if ( self.my_contractView ) {
        [self.my_contractView removeFromSuperview];

    }
    if ( self.my_buttonTranslate ) {
        [self.my_buttonTranslate removeFromSuperview];
        
    }
    modifyDate = self.today;
    if (!self.lastToday) {
        self.lastToday = self.today;
        [self.my_select setHidden:YES];
        [self.my_selectDay setHidden:YES];
        [self.my_collect setHidden:YES];
        [self.my_analyse setHidden:YES];
        [self.my_setting setHidden:YES];

        
        if (self.my_dayline.hidden) {
            [self.my_dayline setHidden:NO];
        }
        
    }
    else{
        
        if ([self.today isEqualToString: self.lastToday]) {
            [self.my_select setHidden:YES];
            [self.my_selectDay setHidden:YES];
            [self.my_collect setHidden:YES];
            [self.my_analyse setHidden:YES];
            [self.my_setting setHidden:YES];
            
            if (self.my_dayline.hidden) {
                [self.my_dayline setHidden:NO];
            }
            
        }
        else
        {
            [self.my_dayline removeFromSuperview];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                
                CGRect frame7 = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y+5, self.view.frame.size.width-85, self.view.frame.size.height-5 );
                
                NSLog(@"frame here is :%f  y, %f   height",frame7.origin.y,frame7.size.height);
                
                self.my_dayline = [[daylineView alloc] initWithFrame:frame7];
                NSLog(@"ios7!!!!");
            }else{
                
       
                CGRect frame = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y-20, self.view.frame.size.width-85, self.view.frame.size.height );
                
                NSLog(@"frame here is :%f  y, %f   height",frame.origin.y,frame.size.height);
                
                self.my_dayline = [[daylineView alloc] initWithFrame:frame];
                
            }
            [self.homePage addSubview:self.my_dayline];
            [self.my_select setHidden:YES];
            [self.my_selectDay setHidden:YES];
            [self.my_collect setHidden:YES];
            [self.my_analyse setHidden:YES];
            [self.my_setting setHidden:YES];
            
            if (self.my_dayline.hidden) {
                [self.my_dayline setHidden:NO];
            }
            
            
            
            
            self.lastToday = self.today;
        }
        
    }
    

    
    
    
    self.my_dayline.my_scoller.modifyEvent_delegate = self;
    self.drawBtnDelegate = self.my_dayline.my_scoller;
    
    
    
    //   [self.my_dayline addSubview:self.my_scoller];
    
    for (int i = 0; i<10; i++) {
        [[self.my_dayline.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.my_dayline.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_dayline.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_dayline.shareBtn addTarget:self action:@selector(shareTappedWithActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    

    self.my_dayline.dateNow.text = modifyDate;
    const char *dbpath = [databasePath UTF8String];
    //查看当天是否已经有数据
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryStar = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
        const char *queryStarstatement = [queryStar UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //当天数据已经存在，则取出数据还原界面
                int moodNum = sqlite3_column_int(statement, 0);
                for (int i = 0; i<=moodNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = moodNum; j<5; j++) {
                    [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
                
                
                int growthNum = sqlite3_column_int(statement, 1);
                for (int i = 0; i<=growthNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                for (int j = growthNum; j<5; j++) {
                    [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                }
                
            }

            
        }
        else{
            NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));
            
        }
        
        
        sqlite3_finalize(statement);
        
            NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,title,startTime,endTime from event where DATE=\"%@\"",modifyDate];
            const char *queryEventstatement = [queryEventButton UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    //当天已有事件存在，则取出数据还原界面
                    NSString *title;
                    NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                    char *ttl = (char *)sqlite3_column_text(statement, 1);
                    NSLog(@"char is %s",ttl);
                    if (ttl == nil) {
                        title = @"";
                    }else {
                        title = [[NSString alloc] initWithUTF8String:ttl];
                        NSLog(@"nsstring  is %@",title);
                    }
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,3)];
              //   if (!todayRedrawDone) {
                    
                    [self.drawBtnDelegate redrawButton:startTm :endTm :title :evtType :NULL];
                    
               //     todayRedrawDone = YES;
                    
             //   }
                    if ([evtType intValue]==0) {
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            workArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else if([evtType intValue]==1){
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            lifeArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else{
                        NSLog(@"事件类型有误！");
                    }
                    
                }
                
            }
            
            sqlite3_finalize(statement);
        
        
        //eric:for watch
        [self saveScreenshotForWatch];
        
       
    }else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    
    
    
    
    
}

-(void)starTapped:(UIButton*)sender
{
    
//    FrontiaStatistics* statTracker = [Frontia getStatistics];

    
    const char *dbpath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        sqlite3_stmt *findStatement;
        sqlite3_stmt *dayStatement;
        NSString *queryDay = [NSString stringWithFormat:@"SELECT * from DAYTABLE where DATE=\"%@\"",modifyDate];
        NSLog(@"%@000000",modifyDate);
        const char *queryDayStatement = [queryDay UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryDayStatement, -1, &findStatement, NULL)==SQLITE_OK) {
            
            if(sqlite3_step(findStatement)==SQLITE_ROW)
            {
                
               
            }else {
                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                
                //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                const char *insertsatement = [insertSql UTF8String];
                sqlite3_prepare_v2(dataBase, insertsatement, -1, &dayStatement, NULL);
                sqlite3_bind_text(dayStatement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(dayStatement, 2, 0);
                sqlite3_bind_int(dayStatement, 3, 0);
                
                
                if (sqlite3_step(dayStatement)==SQLITE_DONE) {
                    NSLog(@"innsert today ok");
                    
                    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

                    NSDate *dateUnconvert = [dateFormatter dateFromString:modifyDate];
                    [self.HasEventsDates addObject:dateUnconvert];

                }
                else {
                    NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                }
                
                sqlite3_finalize(dayStatement);
                
            }
            
            if (sender.tag <100) {
                
//                [statTracker logEvent:@"10001" eventLabel:@"clickMood"];
                
                if (self.my_dayline.hidden == NO) {
                    for (int i = 0; i<=sender.tag; i++) {
                        
                        
                        [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = (int)sender.tag+1; j<5; j++) {
                        [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                }else if(self.my_selectDay.hidden == NO){
                    for (int i = 0; i<=sender.tag; i++) {
                        
                        
                        [[self.my_selectDay.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = (int)sender.tag+1; j<5; j++) {
                        [[self.my_selectDay.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                }
                //数据库更新
                
                sqlite3_stmt *stmt;
                //如果已经存在并且已登陆，则修改状态值
                const char *Update="update DAYTABLE set MOOD=?where date=?";
                if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                    NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
                }
                sqlite3_bind_int(stmt, 1, (int)sender.tag+1);
                sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_step(stmt);
                sqlite3_finalize(stmt);
                
            }
            else
            {
                
//                [statTracker logEvent:@"10002" eventLabel:@"clickGrowth"];

                if (self.my_dayline.hidden == NO) {
                    for (int i = 0; i<=sender.tag-100; i++) {
                        [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = (int)sender.tag-99; j<5; j++) {
                        [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                }else if (self.my_selectDay.hidden ==NO){
                    for (int i = 0; i<=sender.tag-100; i++) {
                        [[self.my_selectDay.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = (int)sender.tag-99; j<5; j++) {
                        [[self.my_selectDay.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                }
                //数据库更新
                sqlite3_stmt *stmt;
                //如果已经存在并且已登陆，则修改状态值
                const char *Update="update DAYTABLE set growth=?where date=?";
                if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                    NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
                }
                sqlite3_bind_int(stmt, 1, (int)sender.tag-99);
                sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_step(stmt);
                sqlite3_finalize(stmt);
            }
            

            
           
        }
                sqlite3_finalize(findStatement);
        

    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    sqlite3_close(dataBase);
    
//    
//    
//    UIImageView *test = [[UIImageView alloc] initWithFrame:self.view.frame];
//    test.image = self.shareImg;
//    
//    [self.view addSubview:test];
//    
    
}

/*
-(UIView *)makeShareView
{
    double width = [[UIScreen mainScreen] bounds].size.width;
    double height = [[UIScreen mainScreen] bounds].size.height/2.5;
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [shareView setBackgroundColor:[UIColor colorWithPatternImage:    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"action-sheet-panel" ofType:@"png"]]]];
    shareView.alpha = 0.8f;
    //
    UIButton *weixin = [[UIButton alloc] init];
    [weixin setFrame:CGRectMake(50, 30, 40, 40)];
    [weixin setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weixin" ofType:@"png"]] forState:UIControlStateNormal];
    [weixin addTarget:self action:@selector(onSelectWeixin) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:weixin];
    //
    UIButton *wx_friend = [[UIButton alloc] init];
    [wx_friend setFrame:CGRectMake(140, 30, 40, 40)];
    [wx_friend setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wx_friend" ofType:@"png"]] forState:UIControlStateNormal];
    [wx_friend addTarget:self action:@selector(onSelectwx_friend) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:wx_friend];
    //
    UIButton *wx_favorite = [[UIButton alloc] init];
    [wx_favorite setFrame:CGRectMake(230, 30, 40, 40)];
    [wx_favorite setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wx_favorite" ofType:@"png"]] forState:UIControlStateNormal];
    [wx_favorite addTarget:self action:@selector(onSelectwx_favorite) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:wx_favorite];
    //
    UIButton *weibo = [[UIButton alloc] init];
    [weibo setFrame:CGRectMake(50, 100, 40, 40)];
    [weibo setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"png"]] forState:UIControlStateNormal];
    [weibo addTarget:self action:@selector(onSelectweibo) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:weibo];
    //
    UIButton *Qzone = [[UIButton alloc] init];
    [Qzone setFrame:CGRectMake(140, 100, 40, 40)];
    [Qzone setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Qzone" ofType:@"png"]] forState:UIControlStateNormal];
    [Qzone addTarget:self action:@selector(onSelectQzone) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:Qzone];
    //
    UIButton *qq = [[UIButton alloc] init];
    [qq setFrame:CGRectMake(230, 100, 40, 40)];
    [qq setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qq" ofType:@"png"]] forState:UIControlStateNormal];
    [qq addTarget:self action:@selector(onSelectqq) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:qq];
    
    return shareView;
    

}
*/

-(void)shareTappedWithActionSheet:(id)button
{
    
    
    if (self.my_dayline.hidden == NO) {
        
        self.finalShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.my_dayline.my_scoller.viewToShare.frame.size.width,self.my_dayline.my_scoller.viewToShare.frame.size.height+LABEL_SPACE)];
        
        UIImageView *test = [[UIImageView alloc] initWithImage:[self.my_dayline.my_scoller getContentImage]];
        test.contentMode = UIViewContentModeScaleToFill;
        test.frame = CGRectMake(0, LABEL_SPACE, self.my_dayline.my_scoller.viewToShare.frame.size.width, self.my_dayline.my_scoller.viewToShare.frame.size.height);
        [self.finalShare addSubview:test];
        
    }else
    {
        self.finalShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.my_selectDay.my_scoller.viewToShare.frame.size.width,self.my_selectDay.my_scoller.viewToShare.frame.size.height+LABEL_SPACE)];
        
        UIImageView *test = [[UIImageView alloc] initWithImage:[self.my_selectDay.my_scoller getContentImage]];
        test.contentMode = UIViewContentModeScaleToFill;
        test.frame = CGRectMake(0, LABEL_SPACE, self.my_selectDay.my_scoller.viewToShare.frame.size.width, self.my_selectDay.my_scoller.viewToShare.frame.size.height);
        
        [self.finalShare addSubview:test];
    }
    
    
    //    self.finalShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.my_dayline.my_scoller.viewToShare.frame.size.width,self.my_dayline.my_scoller.viewToShare.frame.size.height+LABEL_SPACE)];
    //
    //    UIImageView *test = [[UIImageView alloc] initWithImage:[self.my_dayline.my_scoller getContentImage]];
    //    test.contentMode = UIViewContentModeScaleToFill;
    //    test.frame = CGRectMake(0, LABEL_SPACE, self.view.frame.size.height*self.my_dayline.my_scoller.contentSize.width/self.my_dayline.my_scoller.contentSize.height, self.view.frame.size.height-LABEL_SPACE);
    //
    //    [self.finalShare addSubview:test];
    
    UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 80, 22)];
    // workLabel.text = @"工作";
    workLabel.text = NSLocalizedString(@"工作", nil);
    workLabel.backgroundColor = [UIColor clearColor];
    workLabel.textAlignment = NSTextAlignmentCenter;
    workLabel.layer.borderColor = [UIColor clearColor].CGColor;
    workLabel.layer.borderWidth = 2.0;
    workLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    UILabel *lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 8, 80, 22)];
    
    lifeLabel.text = NSLocalizedString(@"生活",nil);
    lifeLabel.backgroundColor = [UIColor clearColor];
    lifeLabel.textAlignment = NSTextAlignmentCenter;
    lifeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    lifeLabel.layer.borderWidth = 2.0;
    lifeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [self.finalShare addSubview:workLabel];
    [self.finalShare addSubview:lifeLabel];
    
    
    
    
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.finalShare.frame.size, NO, 2.0);
    else
        UIGraphicsBeginImageContext(self.finalShare.frame.size);
    [self.finalShare.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.shareImg = [self halfCutShareImg:image andButton:button];
    
    

    
    if (button) {
//        
//        
//        CustomActionSheet* sheet = [[CustomActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:
//                                                                               [CustomActionSheetButton buttonWithImage:[UIImage
//                                                                                                                         imageNamed:@"weixin"] title:@"微信好友"],
//                                                                               [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"wx_friend"] title:@"朋友圈"],
//                                                                               [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"wx_favorite"] title:@"收藏到微信"],
//                                                                               nil]];
//        sheet.delegate = self;
//        [sheet showInView:self.view];
        
        
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:NSLocalizedString(@"DaysInLine",nil)
                                           defaultContent:NSLocalizedString(@"How is my day looks..",nil)
                                                    image:[ShareSDK pngImageWithImage:self.shareImg]
                                                    title:NSLocalizedString(@"DaysInLine",nil)
                                                      url:REVIEW_URL_CN
                                              description:NSLocalizedString(@"How is my day looks..",nil)
                                                mediaType:SSPublishContentMediaTypeImage];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];
        
        
    }

}

-(UIImage *)halfCutShareImg:(UIImage *)longImg andButton:btn
{
    int offsideForWatch = 0;
    int scaleForRetina = 1;
    if (!btn) {
        offsideForWatch = 65;
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        scaleForRetina = 2;
    }
    
    UIImage *firstImg = [longImg getSubImage:CGRectMake(0, 0, 245*scaleForRetina, 1230*scaleForRetina/4)];
    UIImage *secondImg = [longImg getSubImage:CGRectMake(0, 1230*scaleForRetina/4, 245*scaleForRetina, 1230*scaleForRetina/4)];
    UIImage *thirdImg = [longImg getSubImage:CGRectMake(0, 1230*scaleForRetina/2, 245*scaleForRetina, 1230*scaleForRetina/4)];
    UIImage *fourthImg = [longImg getSubImage:CGRectMake(0, 1230*3*scaleForRetina/4, 245*scaleForRetina, 1230*scaleForRetina/4+20)];
    UIImageView *first = [[UIImageView alloc] initWithImage:firstImg];
    first.frame = CGRectMake(40, 70-offsideForWatch, 245, 1230/4);
    UIImageView *second = [[UIImageView alloc] initWithImage:secondImg];
    second.frame = CGRectMake(40, 70+1230/4-offsideForWatch, 245, 1230/4);
    
    UIImageView *third = [[UIImageView alloc] initWithImage:thirdImg];
    third.frame = CGRectMake(40, 70+1230/2-offsideForWatch, 245, 1230/4);
    UIImageView *fourth = [[UIImageView alloc] initWithImage:fourthImg];
    fourth.frame = CGRectMake(40, 70+1230*3/4-offsideForWatch, 245, 1230/4+20);
    
    
    UIImageView *shareTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 320, 63)];
    [shareTitle setImage:[UIImage imageNamed:@"shareTitle"]];
    
    UIView *wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1230+100)];
    wholeView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    [wholeView addSubview:first];
    [wholeView addSubview:second];
    [wholeView addSubview:third];
    [wholeView addSubview:fourth];

    if(btn)
    {
        [wholeView addSubview:shareTitle];
    }
    
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(wholeView.frame.size, NO, 2.0);
    else
        UIGraphicsBeginImageContext(wholeView.frame.size);

    [wholeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *entireOne = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return entireOne;
    
}

-(void)eventTapped:(UIButton *)sender
{
    if (sender.tag ==0) {
        
        [MobClick event:@"addWork"];

    }else if (sender.tag ==1){
        [MobClick event:@"addLife"];

    }
    
    
    NSDate* goInEdit = [NSDate dateWithTimeIntervalSinceNow:0];
    
   // NSLog(@"go in edit:%@",goInEdit);
    //播放
    if (soundSwitch) {
        
    CFBundleRef mainbundle=CFBundleGetMainBundle();
     SystemSoundID soundObject;
    //获得声音文件URL
    CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
    //创建system sound 对象
    AudioServicesCreateSystemSoundID(soundfileurl, &soundObject);
    AudioServicesPlaySystemSound(soundObject);
    }
    NSString *startTime;
    NSString *endTime;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
   long hour = [comps hour];

    startTime = [NSString stringWithFormat:@"%02ld:00",hour];
    endTime = [NSString stringWithFormat:@"%02ld:45",hour];
    
    self.textInMain = NSLocalizedString(@"点击输入......",nil);
    
   editingViewController *my_editingViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_editingViewController.eventType = [NSNumber numberWithInteger:sender.tag];
    my_editingViewController.justInEdit = goInEdit;

      my_editingViewController.setTextDelegate = self;
    
    NSLog(@"type is:%@",my_editingViewController.eventType);
    if(self.my_dayline.hidden == NO){
        my_editingViewController.drawBtnDelegate = self.my_dayline.my_scoller;
    }else if (self.my_selectDay.hidden == NO){
        my_editingViewController.drawBtnDelegate = self.my_selectDay.my_scoller;
    }

   // my_editingViewController.addTagDataDelegate = self;
    my_editingViewController.tags = self.allTags;
    my_editingViewController.HasEvtDates = self.HasEventsDates;
    
    modifying = 0;
    
    [(UILabel*)[my_editingViewController.view viewWithTag:103] setText:startTime];
    [(UILabel*)[my_editingViewController.view viewWithTag:104] setText:endTime];

    
    
    my_editingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:my_editingViewController animated:YES completion:Nil ];
    
}


-(void)selectTapped
{
    
    [MobClick event:@"select"];

    inwhichButton = 2;
  //  [self.iAdBannerView removeFromSuperview];
  //  [self.gAdBannerView removeFromSuperview];
//    if ( self.bannerIsVisible ) {
//        [self.iAdBannerView removeFromSuperview];
//        
//    }else{
//        [self.gAdBannerView removeFromSuperview];
//    }
    [self.bannerView setHidden:YES];

    
    if (soundSwitch) {
        
        
        AudioServicesPlaySystemSound(soundFileObject);
    }
    
    [self.my_rightTranslate setHidden:YES];

    if ( self.my_contractView ) {
        [self.my_contractView removeFromSuperview];
        
    }
    if ( self.my_buttonTranslate ) {
        [self.my_buttonTranslate removeFromSuperview];
        
    }
    
    [self.my_selectDay setHidden:YES];
    [self.my_dayline setHidden:YES];
    [self.my_collect setHidden:YES];
    [self.my_analyse setHidden:YES];
    [self.my_setting setHidden:YES];
    
    if (self.my_select.hidden) {
               // [self.my_select.alltagTable reloadData];
        [self.my_select setHidden: NO];
    }
    self.tableLeft = [[NSMutableArray alloc] init];
    self.tableRight = [[NSMutableArray alloc] init];
    
    [self.my_select.goInThatDay addTarget:self action:@selector(goInThatDayTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.my_select.returnToTags addTarget:self action:@selector(returnToTagsTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.my_select.alltagTable setHidden:NO];
    [self.my_select.eventInTagTable setHidden:YES];
    [self.my_select.returnToTags setHidden:YES];
}

-(void)returnToTagsTapped
{
    if (soundSwitch) {
        
        
        AudioServicesPlaySystemSound(soundFileObject);
    }
    
    [self.my_select.alltagTable setHidden:NO];
    [self.my_select.eventInTagTable setHidden:YES];
    [self.my_select.returnToTags setHidden:YES];
}


-(void)goInThatDayTapped
{

    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_goInDay;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
        AudioServicesPlaySystemSound(soundObject_goInDay);
    }

    
    
    
    
    //获取将要查询的日期
    if (!self.dateToSelect) {
        NSLog(@"没选日期！");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"出错啦！",nil)
                                                        message:NSLocalizedString(@"请先选择要查看的日期",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
        
        [ alert  show];
        
    }else{
        
        if ([self.today isEqualToString: self.dateToSelect]) {
        [self todayTapped];
        NSLog(@"now======selected");
        
        
    }
    else{
        
        
        
        
        
        for (int i=0; i<96; i++) {
            workArea[i] = 0;
            lifeArea[i] = 0;
        }
        
        [self.my_selectDay removeFromSuperview];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            CGRect frame7 = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y+5, self.view.frame.size.width-85, self.view.frame.size.height-5 );
            
            NSLog(@"frame here is :%f  y, %f   height",frame7.origin.y,frame7.size.height);
            
            self.my_selectDay = [[daylineView alloc] initWithFrame:frame7];
            NSLog(@"ios7!!!!");
        }else{
            
            CGRect frame = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y-20, self.view.frame.size.width-85, self.view.frame.size.height );
            
            NSLog(@"frame here is :%f  y, %f   height",frame.origin.y,frame.size.height);
            
            self.my_selectDay = [[daylineView alloc] initWithFrame:frame];
            
        }
        [self.homePage addSubview:self.my_selectDay];
        
        
        
        self.my_selectDay.my_scoller.modifyEvent_delegate = self;
        self.drawBtnDelegate = self.my_selectDay.my_scoller;
        
        
        
        // [self.my_selectDay addSubview:self.my_selectScoller];
        
        for (int i = 0; i<10; i++) {
            [[self.my_selectDay.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.my_selectDay.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.my_selectDay.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.my_selectDay.shareBtn addTarget:self action:@selector(shareTappedWithActionSheet:) forControlEvents:UIControlEventTouchUpInside];

        
        
        
        
        
        
        [self.my_select setHidden:YES];
        [self.my_selectDay setHidden:NO];
        
        modifyDate = self.dateToSelect;
        self.my_selectDay.dateNow.text = modifyDate;
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        //查看当天是否已经有数据
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryStar = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
            const char *queryStarstatement = [queryStar UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //当天数据已经存在，则取出数据还原界面
                    int moodNum = sqlite3_column_int(statement, 0);
                    for (int i = 0; i<=moodNum-1; i++) {
                        [[self.my_selectDay.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = moodNum; j<5; j++) {
                        [[self.my_selectDay.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                    
                    
                    int growthNum = sqlite3_column_int(statement, 1);
                    for (int i = 0; i<=growthNum-1; i++) {
                        [[self.my_selectDay.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                    }
                    for (int j = growthNum; j<5; j++) {
                        [[self.my_selectDay.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
                    }
                    
                }
               
                
            }
            
            else{
                NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));
                
            }
            sqlite3_finalize(statement);
            
            
            
            
            NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,title,startTime,endTime from event where DATE=\"%@\"",modifyDate];
            const char *queryEventstatement = [queryEventButton UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    //当天已有事件存在，则取出数据还原界面
                    NSString *title;
                    NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                    char *ttl = (char *)sqlite3_column_text(statement, 1);
                    NSLog(@"char is %s",ttl);
                    if (ttl == nil) {
                        title = @"";
                    }else {
                        title = [[NSString alloc] initWithUTF8String:ttl];
                        NSLog(@"nsstring  is %@",title);
                    }
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,3)];
                    
                    
                    [self.drawBtnDelegate redrawButton:startTm :endTm :title :evtType :NULL];
                    
                    
                    if ([evtType intValue]==0) {
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            workArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else if([evtType intValue]==1){
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            lifeArea[i] = 1;
                            NSLog(@"seized work area is :%d",i);
                        }
                    }else{
                        NSLog(@"事件类型有误！");
                    }
                    
                }
                
            }
            
            sqlite3_finalize(statement);
            
            
            [self saveScreenshotForWatch];
            
        }
        
        
        
        
        else {
            NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
    }
        
    
    }
 
}

-(void)treasureTapped

{
    
    [MobClick event:@"treasure"];

    
    [self.my_select dismissKeyboard];
    [self.bannerView setHidden:NO];


    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    
    NSLog ( @"%@" , languages);
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang:%@",currentLanguage);
    
    
    
    if (remindSwitch&&password) {
        
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"请输入收藏夹密码",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                          otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField *pswd = [alert textFieldAtIndex:0];
    pswd.keyboardType = UIKeyboardTypeNumberPad ;
    alert.tag =1;
    [ alert  show];
    }
    else
    {
        [self treasurePass];
    }
        
    
}
-(void)treasurePass
{
    
    
    
    //[[Frontia getStatistics] logEvent:@"10017" eventLabel:@"collectTap"];
    

    

    
    //播放
    if (soundSwitch) {
        
        
        AudioServicesPlaySystemSound(soundFileObject);
    }
    inwhichButton = 3;
//    if (self.bannerIsVisible) {
//        [self.view addSubview:self.iAdBannerView];
//
//    }else {
//        [self.view addSubview:self.gAdBannerView];
//    }
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    sqlite3_stmt *stateQueryEvent;
    NSNumber *collectEventID;
    
    NSString *eventTittle;
    NSString *eventDate;
    NSString *eventStart;
    NSString *eventEnd;
    NSString *eventTag;
    
    collectNum = 0;
    
    [self.my_rightTranslate setHidden:YES];

    if ( self.my_contractView ) {
        [self.my_contractView removeFromSuperview];
        
    }
    if ( self.my_buttonTranslate ) {
        [self.my_buttonTranslate removeFromSuperview];
        
    }
    
    [self.my_select setHidden:YES];
    [self.my_dayline setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_analyse setHidden:YES];
    [self.my_setting setHidden:YES];
  
    
    [self.collectEvent removeAllObjects];
    [self.collectEventTitle removeAllObjects];
    [self.collectEventTag removeAllObjects];
    [self.collectEventDate removeAllObjects];
    [self.collectEventStart removeAllObjects];
    [self.collectEventEnd removeAllObjects];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventId = [NSString stringWithFormat:@"SELECT eventID from collection"];
        const char *queryEventIdstatment = [queryEventId UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventIdstatment, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //找到收藏的事件ID，存入collectEvent数组。
                
                collectEventID = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                
                [self.collectEvent addObject:collectEventID];
                
            }
            
        }
        else{
            NSLog(@"查询不OK啊啊啊");
        }
        sqlite3_finalize(statement);
        
        
        for (int i = 0; i<self.collectEvent.count; i++) {
            NSString *queryEventId = [NSString stringWithFormat:@"SELECT title,date,startTime,endTime,label from event where eventID=\"%d\"",[(NSNumber *)self.collectEvent[i] intValue]];

            const char *queryEventIdstatment = [queryEventId UTF8String];
            
            if  (sqlite3_prepare_v2(dataBase, queryEventIdstatment, -1, &stateQueryEvent, NULL)==SQLITE_OK) {
                if   (sqlite3_step(stateQueryEvent)==SQLITE_ROW) {
                    //找到要查询的事件，取出数据。
                    
                    char *ttl_mdfy = (char *)sqlite3_column_text(stateQueryEvent, 0);
                    NSLog(@"char_eventTittle is %s",ttl_mdfy);
                    if (ttl_mdfy == nil) {
                        eventTittle = @"";
                    }else {
                        eventTittle = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                        NSLog(@"nsstring_eventTittle  is %@",eventTittle);
                    }
                    [self.collectEventTitle addObject:eventTittle];
                    
                    
                    char *date_mdfy = (char *)sqlite3_column_text(stateQueryEvent, 1);
                    NSLog(@"date_mdfy is %s",date_mdfy);
                    if (date_mdfy == nil) {
                        eventDate = @"";
                    }else {
                        eventDate = [[NSString alloc] initWithUTF8String:date_mdfy];
                        NSLog(@"nsstring_date  is %@",eventDate);
                    }
                    [self.collectEventDate addObject:eventDate];
                    

                    
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(stateQueryEvent,2)];
                    int start = [startTm intValue];
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(stateQueryEvent,3)];
                    int end = [endTm intValue];
                    if (start%60<10) {
                        eventStart = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];
                        
                    }else{
                        eventStart = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                    }
                    if (end%60<10) {
                        eventEnd = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                        
                    }else{
                        eventEnd = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                    }
                    
                    [self.collectEventStart addObject:eventStart];
                    [self.collectEventEnd addObject:eventEnd];
                    
        //            NSLog(@"start time is:%@",startTime);
                    
                   
                    char *EvtTag = (char *)sqlite3_column_text(stateQueryEvent, 4);
                    if (EvtTag == nil) {
                        eventTag = @"";
                    }else {
                        eventTag = [[NSString alloc] initWithUTF8String:EvtTag];
                        
                        NSLog(@"nsstring_old labels  is %@",eventTag);
                    }
                    
                    [self.collectEventTag addObject:eventTag];
                    
                   
                }
                
            }
            else{
                NSLog(@"wwwwwwwwwwww!!!!!2");
            }
            sqlite3_finalize(stateQueryEvent);
        }

        
        
        
    }
    else {
        NSLog(@"数据库打开失败啊啊啊");
        
    }
    sqlite3_close(dataBase);
    
     NSLog(@"%@,%@,%@,%@,%@",self.collectEvent,self.collectEventTitle,self.collectEventTag,self.collectEventDate,self.collectEventStart);
    
    [self.my_collect.collectionTable reloadData];
    
    if (self.my_collect.hidden==YES) {
        [self.my_collect setHidden:NO];
    }
   
    
    
    NSLog(@"%ld",(long)self.my_collect.collectionTable.tag);
  
}


-(void)analyseTapped
{
    [self.my_select dismissKeyboard];
    [self.bannerView setHidden:NO];

    //[[Frontia getStatistics] logEvent:@"10018" eventLabel:@"statisticTap"];

    inwhichButton = 4;
    //[self.view addSubview:self.iAdBannerView];
    //[self.view addSubview:self.gAdBannerView];

//    if (self.bannerIsVisible) {
//        [self.view addSubview:self.iAdBannerView];
//        
//    }else {
//        [self.view addSubview:self.gAdBannerView];
//    }
    //播放
    if (soundSwitch) {
        
        
        AudioServicesPlaySystemSound(soundFileObject);
    }
    
    [self.my_rightTranslate setHidden:YES];

    if ( self.my_contractView ) {
        [self.my_contractView removeFromSuperview];
        
    }
    if ( self.my_buttonTranslate ) {
        [self.my_buttonTranslate removeFromSuperview];
        
    }
    //UIDatePicker *remindDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 30)] ;
    
    [self.my_dayline setHidden:YES];
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_collect setHidden:YES];
    [self.my_setting setHidden:YES];
    
    [self.my_analyse.resultButton addTarget:self action:@selector(analyseResultButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    


    if (self.my_analyse.hidden==YES) {
        [self.my_analyse setHidden:NO];
    }
    
}

-(void)analyseResultButtonTapped
{
    [MobClick event:@"stats"];

    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_goInDay;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
        AudioServicesPlaySystemSound(soundObject_goInDay);
    }
    
    
    //  NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy-MM-dd";
    
    if ([self.my_analyse.dateStart.date compare: self.my_analyse.dateEnd.date] ==NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"出错啦！",nil)
                                                        message:NSLocalizedString(@"统计起始日期大于终止日期",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
        
        [ alert  show];
        return;
    }
    
    NSString *start = [formatter stringFromDate:self.my_analyse.dateStart.date];
    NSString *end = [formatter stringFromDate:self.my_analyse.dateEnd.date];
    //时区偏移
    //   NSInteger zoneInterval = [zone secondsFromGMTForDate: dateTime];

    statisticViewController *my_statisticViewController;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
       my_statisticViewController = [[statisticViewController alloc] initWithNibName:@"statisticViewController586" bundle:nil];
    }else{
        my_statisticViewController = [[statisticViewController alloc] initWithNibName:@"statisticViewController" bundle:nil];
    
    }

    

   // statisticViewController *my_statisticViewController = [[statisticViewController alloc] initWithNibName:@"statisticViewController" bundle:nil];
    my_statisticViewController.startDate = start;
    my_statisticViewController.endDate = end;
    
    my_statisticViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:my_statisticViewController animated:YES completion:Nil ];
    

}


-(void)settingTapped
{
    [self.my_select dismissKeyboard];
    [self.bannerView setHidden:NO];

    [MobClick event:@"setting"];

    
    
    inwhichButton = 5;
   // [self.view addSubview:self.iAdBannerView];
   // [self.view addSubview:self.gAdBannerView];


//    if (self.bannerIsVisible) {
//        [self.view addSubview:self.iAdBannerView];
//        
//    }else {
//        [self.view addSubview:self.gAdBannerView];
//    }
    
    
    if (soundSwitch) {
        
        
        AudioServicesPlaySystemSound(soundFileObject);
    }
    
    [self.my_rightTranslate setHidden:YES];

    if ( self.my_contractView ) {
        [self.my_contractView removeFromSuperview];
        
    }
    if ( self.my_buttonTranslate ) {
        [self.my_buttonTranslate removeFromSuperview];
        
    }
    [self.my_dayline setHidden:YES];
    [self.my_select setHidden:YES];
    [self.my_selectDay setHidden:YES];
    [self.my_collect setHidden:YES];
    [self.my_analyse setHidden:YES];
    
    if (self.my_setting) {
        [self.my_setting removeFromSuperview];
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        CGRect frame7 = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y+5, self.view.frame.size.width-85, self.view.frame.size.height-5 );
        
        NSLog(@"frame here is :%f  y, %f   height",frame7.origin.y,frame7.size.height);
        
        self.my_setting = [[settingView alloc] initWithFrame:frame7];
        
        NSLog(@"ios7!!!!");
    }else{

        CGRect frame = CGRectMake(self.view.frame.origin.x+80,self.view.frame.origin.y-20, self.view.frame.size.width-85, self.view.frame.size.height );
        
        NSLog(@"frame here is :%f  y, %f   height",frame.origin.y,frame.size.height);
    
        self.my_setting = [[settingView alloc] initWithFrame:frame];
    }
    
    
    

    self.my_setting.settingTable.delegate = self;
    self.my_setting.settingTable.dataSource = self;
    
    [self.my_setting.soundSwitch setOn:soundSwitch animated:YES];
  //  NSLog(@"soundSwitch:%hhd",soundSwitch);
    [self.my_setting.soundSwitch addTarget:self action:@selector(soundSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.my_setting.remindSoundSwitch setOn:remindSwitch animated:YES];
 //   NSLog(@"remindSoundSwitch:%hhd",remindSwitch);
    [self.my_setting.remindSoundSwitch addTarget:self action:@selector(remindSoundSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    if (remindSwitch) {
        if (password) {
            [self.my_setting.passwordView setHidden:YES];
            [self.my_setting.tipsView setHidden:NO];
            [self.my_setting.tips addTarget:self action:@selector(tipsTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.my_setting.modifyPassword addTarget:self action:@selector(modifyPawdTapped) forControlEvents:UIControlEventTouchUpInside];
            
        }else
        {
            [self.my_setting.passwordView setHidden:NO];
            [self.my_setting.tipsView setHidden:YES];
            self.my_setting.password.delegate = self;
            self.my_setting.password2.delegate = self;
            self.my_setting.userTip.delegate = self;
            
            [self.my_setting.confirmButton addTarget:self action:@selector(confirmPassword) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }else
    {
        [self.my_setting.passwordView setHidden:YES];
        [self.my_setting.tipsView setHidden:YES];
        
    }

  
    [self.homePage addSubview:self.my_setting];
}

-(void)remindSoundSwitchChanged:(SevenSwitch *)sender
{
    sqlite3_stmt *varStatement;
    sqlite3_stmt *stmt;
    NSString *soundName = @"remindSwitch";
    
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
    sender.on ? (remindSwitch = YES) : (remindSwitch = NO);
    
    
    const char *dbpath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        NSString *insertGlobalVar = [NSString stringWithFormat:@"INSERT INTO globalVar(varName,value) VALUES(?,?)"];
        
        //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
        const char *insertVarsatement = [insertGlobalVar UTF8String];
        sqlite3_prepare_v2(dataBase, insertVarsatement, -1, &varStatement, NULL);
        sqlite3_bind_text(varStatement,1, [soundName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(varStatement, 2, remindSwitch);
        
        
        if (sqlite3_step(varStatement)==SQLITE_DONE) {
            NSLog(@"innsert today ok");
            
        }
        else {
            NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
            //update DAYTABLE set MOOD=?where date=?
            NSString *updateGlobalVar = [NSString stringWithFormat:@"update globalVar set value=?where varName=?"];
            if (sqlite3_prepare_v2(dataBase, [updateGlobalVar UTF8String], -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, remindSwitch);
            sqlite3_bind_text(stmt, 2, [soundName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            
            
        }
        sqlite3_finalize(varStatement);
        
        
        if (remindSwitch) {
            if (password) {
                [self.my_setting.passwordView setHidden:YES];
                [self.my_setting.tipsView setHidden:NO];
                [self.my_setting.tips addTarget:self action:@selector(tipsTapped) forControlEvents:UIControlEventTouchUpInside];
                [self.my_setting.modifyPassword addTarget:self action:@selector(modifyPawdTapped) forControlEvents:UIControlEventTouchUpInside];

            }else
            {
                [self.my_setting.passwordView setHidden:NO];
                [self.my_setting.tipsView setHidden:YES];
                self.my_setting.password.delegate = self;
                 self.my_setting.password2.delegate = self;
                self.my_setting.userTip.delegate = self;
                
                [self.my_setting.confirmButton addTarget:self action:@selector(confirmPassword) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }else
        {
            if (password) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"请输入密码",nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                                      otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
                
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                UITextField *pswd = [alert textFieldAtIndex:0];
                pswd.keyboardType = UIKeyboardTypeNumberPad ;
                alert.tag =2;
                [ alert  show];

            }
            else{
            [self.my_setting.passwordView setHidden:YES];
            [self.my_setting.tipsView setHidden:YES];
            }
        }
        
        sqlite3_close(dataBase);
        
    }
    
    
//NSLog(@"remind now is:%hhd",remindSwitch);

}
-(void)modifyPawdTapped{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"请输入原密码",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                          otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField *pswd = [alert textFieldAtIndex:0];
    pswd.keyboardType = UIKeyboardTypeNumberPad ;
    alert.tag =3;
    [ alert  show];

    
}


-(void)tipsTapped{

    self.my_setting.tipText.text = userTips;
    
}
-(void)confirmPassword{
    
    if ([self.my_setting.password.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"密码不能为空！",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
        
        
        [ alert  show];
        return;

    }
    
    if ([self.my_setting.password.text isEqualToString:self.my_setting.password2.text]) {
        password = self.my_setting.password.text ;
        userTips = self.my_setting.userTip.text;
        
        //密码数据插入数据库
        
        sqlite3_stmt *passwordStatement;
        sqlite3_stmt *tipsStatement;
        
        sqlite3_stmt *stmtPassword;
        sqlite3_stmt *stmtTips;
        NSString *passwordName = @"password";
        NSString *tipsName = @"tips";
        const char *dbpath = [databasePath UTF8String];
        
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            
            
            NSString *insertPassword = [NSString stringWithFormat:@"INSERT INTO passwordVar(varName,value) VALUES(?,?)"];
            
            //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
            const char *passwordsatement = [insertPassword UTF8String];
            sqlite3_prepare_v2(dataBase, passwordsatement, -1, &passwordStatement, NULL);
            sqlite3_bind_text(passwordStatement,1, [passwordName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(passwordStatement, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if (sqlite3_step(passwordStatement)==SQLITE_DONE) {
                NSLog(@"innsert password ok");
                
            }
            else {
                NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                //update password
                NSString *updatePassword = [NSString stringWithFormat:@"update passwordVar set value=?where varName=?"];
                if (sqlite3_prepare_v2(dataBase, [updatePassword UTF8String], -1, &stmtPassword, NULL)!=SQLITE_OK) {
                    NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
                }
                sqlite3_bind_text(stmtPassword, 1, [password UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmtPassword, 2, [passwordName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_step(stmtPassword);
                sqlite3_finalize(stmtPassword);
                

            }
            sqlite3_finalize(passwordStatement);
            
            
            NSString *insertTip = [NSString stringWithFormat:@"INSERT INTO passwordVar(varName,value) VALUES(?,?)"];
            
            //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
            const char *tipsatement = [insertTip UTF8String];
            sqlite3_prepare_v2(dataBase, tipsatement, -1, &tipsStatement, NULL);
            sqlite3_bind_text(tipsStatement,1, [tipsName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(tipsStatement, 2, [userTips UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if (sqlite3_step(tipsStatement)==SQLITE_DONE) {
                NSLog(@"innsert tips ok");
                
                [MobClick event:@"password"];

                
            }
            else {
                NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                //update tip
                NSString *updatePassword = [NSString stringWithFormat:@"update passwordVar set value=?where varName=?"];
                if (sqlite3_prepare_v2(dataBase, [updatePassword UTF8String], -1, &stmtTips, NULL)!=SQLITE_OK) {
                    NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
                }
                sqlite3_bind_text(stmtTips, 1, [userTips UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmtTips, 2, [tipsName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_step(stmtTips);
                sqlite3_finalize(stmtTips);
            }
            sqlite3_finalize(tipsStatement);
            
            sqlite3_close(dataBase);

        }
        [self.my_setting.passwordView setHidden:YES];
        [self.my_setting.tipsView setHidden:NO];
        [self.my_setting.tips addTarget:self action:@selector(tipsTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.my_setting.modifyPassword addTarget:self action:@selector(modifyPawdTapped) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"两次输入密码不一致！",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
        
        
        [ alert  show];
        self.my_setting.password.text = @"";
        self.my_setting.password2.text = @"";
        self.my_setting.userTip.text = @"";



    }
}

- (void)soundSwitchChanged:(SevenSwitch *)sender {
    
    
    sqlite3_stmt *varStatement;
    sqlite3_stmt *stmt;
    NSString *soundName = @"soundSwitch";
    
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
    sender.on ? (soundSwitch = YES) : (soundSwitch = NO);
    
    
    const char *dbpath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        

        NSString *insertGlobalVar = [NSString stringWithFormat:@"INSERT INTO globalVar(varName,value) VALUES(?,?)"];
        
        //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
        const char *insertVarsatement = [insertGlobalVar UTF8String];
        sqlite3_prepare_v2(dataBase, insertVarsatement, -1, &varStatement, NULL);
        sqlite3_bind_text(varStatement,1, [soundName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(varStatement, 2, soundSwitch);
        
        
        if (sqlite3_step(varStatement)==SQLITE_DONE) {
            NSLog(@"innsert today ok");
            
        }
        else {
            NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
            //update DAYTABLE set MOOD=?where date=?
            NSString *updateGlobalVar = [NSString stringWithFormat:@"update globalVar set value=?where varName=?"];
            if (sqlite3_prepare_v2(dataBase, [updateGlobalVar UTF8String], -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, soundSwitch);
            sqlite3_bind_text(stmt, 2, [soundName UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);


        }
        
        sqlite3_finalize(varStatement);
        sqlite3_close(dataBase);
        
        
        
    }


 //   NSLog(@"now is:%hhd",soundSwitch);
}

-(void)seizeArea:(NSString *)date
{
    
    for (int i=0; i<96; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,startTime,endTime from event where DATE=\"%@\"",date];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
              
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                
                
                if ([evtType intValue]==0) {
                    for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                        workArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else if([evtType intValue]==1){
                    for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                        lifeArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else{
                    NSLog(@"事件类型有误！");
                }
                
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }else {
        NSLog(@"数据库打开失败aaaa啊啊啊");
        
    }
    sqlite3_close(dataBase);

}



//数据库操作方法
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dataBase);
       // NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
        NSLog(@"数据库操作数据失败!%s",sqlite3_errmsg(dataBase));
    }
}

#pragma mark - modify delegation

-(void)modifyEvent:(NSNumber *)startArea;
{
    NSString *title_mdfy;
    NSString *mainTxt_mdfy;
    NSNumber *evtID_mdfy;
    NSNumber *evtType_mdfy;
  
    NSString *startTime;
    NSString *endTime;
    
    NSNumber *income;
    NSNumber *expend;
    NSString *remind;
    NSString *photo;
    NSString *oldLabel;
   
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_goInDay;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
        AudioServicesPlaySystemSound(soundObject_goInDay);
    }
    
 
    modifying = 1;
    
    NSLog(@"button tag is -----%@",startArea);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,startTime,endTime,income,expend,label,remind,photoDir from event where DATE=\"%@\" and startArea=\"%d\"",modifyDate,[startArea intValue]];
        const char *queryEventstatment = [queryEvent UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //找到要修改的事件，取出数据。
                
    
                evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];

                evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                NSLog(@"char_mdfy is %s",ttl_mdfy);
                if (ttl_mdfy == nil) {
                    title_mdfy = @"";
                }else {
                    title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                }
                
                char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                if (mTxt_mdfy == nil) {
                    mainTxt_mdfy = @"";
                }else {
                    mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                }
                
                self.textInMain = [NSString stringWithString:mainTxt_mdfy];
                
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,4)];
               int start = [startTm intValue];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
               int end = [endTm intValue];
                if (start%60<10) {
                    startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];

                }else{
                    startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                }
                if (end%60<10) {
                    endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                    
                }else{
                    endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                }

                
                NSLog(@"start time is:%@",startTime);
                
                income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
                expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                
                char *oldTags = (char *)sqlite3_column_text(statement, 8);
 
                    oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                    
                    NSLog(@"nsstring_old labels  is %@",oldLabel);
                

                
                char *remind_mdfy = (char *)sqlite3_column_text(statement, 9);
                if (remind_mdfy == nil) {
                    remind = @"";
                }else {
                    remind = [[NSString alloc] initWithUTF8String:remind_mdfy];

                    NSLog(@"nsstring_mdfy  is %@",remind);
                }
                
                char *photo_mdfy = (char *)sqlite3_column_text(statement, 10);
                if (photo_mdfy == nil) {
                    photo = @"";
                } else {
                    photo = [[NSString alloc] initWithUTF8String:photo_mdfy];
                    
                    NSLog(@"photo is %@",photo);
                }
            }
            
        }
        else{
            NSLog(@"wwwwwwwwwwww!!!!!1");
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    editingViewController *my_modifyViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    self.drawLabelDelegate = my_modifyViewController;
    
    NSDate* goInEdit = [NSDate dateWithTimeIntervalSinceNow:0];
    my_modifyViewController.justInEdit = goInEdit;

    
    my_modifyViewController.reloadDelegate = self;
    my_modifyViewController.setTextDelegate = self;
    
    
    if(self.my_dayline.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_dayline.my_scoller;
    }else if (self.my_selectDay.hidden == NO){
        my_modifyViewController.drawBtnDelegate = self.my_selectDay.my_scoller;
    }

    my_modifyViewController.tags = self.allTags;
    my_modifyViewController.HasEvtDates = self.HasEventsDates;
    
    modifyEventId = [evtID_mdfy intValue];
    NSLog(@"eventID is : %d",modifyEventId);
  
    //将该事件还原现使出来
    my_modifyViewController.eventType = evtType_mdfy;
    [(UITextField*)[my_modifyViewController.view viewWithTag:105] setText:title_mdfy] ;
    [(UITextView*)[my_modifyViewController.view viewWithTag:106] setText:mainTxt_mdfy];
    [(UILabel*)[my_modifyViewController.view viewWithTag:103] setText:startTime];
    [(UILabel*)[my_modifyViewController.view viewWithTag:104] setText:endTime];
    [(UIButton*)[my_modifyViewController.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
    [(UIButton*)[my_modifyViewController.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
    
    my_modifyViewController.imageName = photo;
    if (![photo isEqualToString:@""]) {
        NSArray *images = [photo componentsSeparatedByString:@";"];
        for (int i = 0; i < [images count]; i++) {
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                                  stringByAppendingPathComponent:[images objectAtIndex:i]];
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
           // UIButton *imageView = (UIButton*)[my_modifyViewController.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
            UIButton *imageButton = (UIButton *)[my_modifyViewController.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
            imageButton.tag = IMAGEVIEW_TAG_BASE+i;
            [imageButton addTarget:my_modifyViewController action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];
          
            [imageButton setImage:savedImage forState:UIControlStateNormal ];
        }
    }
    
    my_modifyViewController.incomeFinal = [income doubleValue];
    my_modifyViewController.expendFinal = [expend doubleValue];
    [self.drawLabelDelegate drawTag:oldLabel];
    //  my_modifyViewController.oldLabel = oldLabel;
    my_modifyViewController.remindData = remind;
    if (my_modifyViewController.incomeFinal>0.001 ||my_modifyViewController.expendFinal>0.001) {
        [my_modifyViewController.moneyButton setImage:[UIImage imageNamed: @"收入高亮.png"] forState:UIControlStateNormal];
    }else
    {
        [my_modifyViewController.moneyButton setImage:[UIImage imageNamed: @"moneyBtn.png"] forState:UIControlStateNormal];
        
    }

    if (my_modifyViewController.remindData.length >3) {
        [my_modifyViewController.remindButton setImage:[UIImage imageNamed: @"提醒高亮.png"] forState:UIControlStateNormal];
    }else
    {
        [my_modifyViewController.remindButton setImage:[UIImage imageNamed: @"remindBtn.png"] forState:UIControlStateNormal];
        
    }
    
 //   [(UITextField*)[my_modifyViewController.moneyAlert viewWithTag:501] setText:[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]];
   // NSLog(@"income is &&&&&&: %@",[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]);
    
    
    my_modifyViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@==========%@",evtType_mdfy,my_modifyViewController.eventType);
    [self presentViewController:my_modifyViewController animated:YES completion:Nil ];
        

}






- (BOOL)dateHasEvents:(NSDate *)date {
    for (NSDate *eventDate in self.HasEventsDates) {

        if ([eventDate isEqualToDate:date]) {
            
            return YES;
        }
    }
    return NO;
}

#pragma mark CKCalender delegate
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
 
    // TODO: play with the coloring if we want to...
    
  
    
    if ([self dateHasEvents:date]) {
        //dateItem.backgroundColor = [UIColor redColor];
        dateItem.selectedImage = [UIImage imageNamed:@"日期角标.png"];
        dateItem.textColor = [UIColor blackColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSLog(@"选中：%@",date);
    NSString *titleDetail;
    NSString *LabelIntable;

    NSLog(@"date:%@",self.HasEventsDates);
   
    [self.tableRight removeAllObjects];
    [self.tableLeft removeAllObjects];
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
     self.dateToSelect = [formater stringFromDate:date];
   /* if ([self dateHasEvents:date]) {
        self.dateToSelect = [formater stringFromDate:date];
        NSLog(@"%@",self.dateToSelect);
    */
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT title,label from event where DATE=\"%@\"",self.dateToSelect];
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {

                    //找到事件,写入tableView。
                    
                    
                    char *ttl = (char *)sqlite3_column_text(statement, 0);
                   
                    if (ttl == nil) {
                        titleDetail = @"空";
                    }else {
                        titleDetail = [[NSString alloc] initWithUTF8String:ttl];
                        NSLog(@"titleDetail  is %@",titleDetail);
                    }
                    
                    [self.tableRight addObject:titleDetail];
                    
                    char *Tag = (char *)sqlite3_column_text(statement, 1);
                    if (Tag == nil) {
                        LabelIntable = @"无标签";
                    }else {
                        LabelIntable = [[NSString alloc] initWithUTF8String:Tag];
                        
                        NSLog(@"LabelIntable   is %@",LabelIntable);
                    }
                    [self.tableLeft addObject:LabelIntable];
                    
                }
                NSLog(@"%@",self.tableRight);
                
            }
            else{
                NSLog(@"qqqqqqqq!!!!!1");
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        
    
    [self.my_select.eventsTable reloadData];
}

#pragma mark tavleView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger tableRows ;
    //  NSLog(@"count:%d",[currentAlbumData[@"titles"] count]);
    switch (tableView.tag) {
        case 0:
            tableRows = self.tableRight.count;
            break;
        case 1:
            tableRows = self.allTags.count;
            break;
        case 2:
            tableRows = self.EventsInTag.count;
                NSLog(@"~~~~~~~~~%ld~~~~~~~~~",(long)tableRows);
            break;
        case 3:
            tableRows = self.collectEvent.count;
             NSLog(@"^^^^^^^^^%ld^^^^^^^^^",(long)tableRows);
            break;
        case 4:
            tableRows = self.EventsInSearch.count;
            NSLog(@"~~~~~~~~~%ld~~~~~~lll",(long)tableRows);
            break;
        case 5:
            tableRows = 3;
            break;
        case 6:
            tableRows = 3;
            break;
        default: tableRows = 0;
            break;
    }

    return tableRows;
    
}


// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:@"selectEvent"];
    UITableViewCell *cell_2 = [tableView dequeueReusableCellWithIdentifier:@"selectTags"];
    UITableViewCell *cell_3 = [tableView dequeueReusableCellWithIdentifier:@"selectEventsInTag"];


    UITableViewCell *cell_4 = [tableView dequeueReusableCellWithIdentifier:@"collectCell"];
    UITableViewCell *cell_5 = [tableView dequeueReusableCellWithIdentifier:@"selectEventsInSearch"];
    UITableViewCell *cell_6 = [tableView dequeueReusableCellWithIdentifier:@"settingInfoCell"];
    UITableViewCell *cell_7 = [tableView dequeueReusableCellWithIdentifier:@"contractCell"];

    switch (tableView.tag) {
        case 0:
            
            if (!cell_1)
            {
                cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEvent"];
            }
            NSUInteger row1=[indexPath row];
            [cell_1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            //设置文本
            if (row1<self.tableRight.count) {
                cell_1.textLabel.text = self.tableRight[row1];

                cell_1.backgroundColor = [UIColor clearColor];
                
                cell_1.detailTextLabel.text = self.tableLeft[row1];
                cell_1.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
                cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
            }
            cell = cell_1;

            break;
        case 1:{
            if (!cell_2)
            {
                cell_2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectTags"];
                [cell_2 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
           
                NSUInteger row2=[indexPath row];
 
            
                //设置文本
            if (row2<self.allTags.count) {
                cell_2.textLabel.text = self.allTags[row2];
                
                cell_2.backgroundColor = [UIColor clearColor];
                NSLog(@"%@",self.allTags);
                
            }
            cell = cell_2;

            break;
        }
        case 2:
        {
        /*    if (!cell_3)
            {
                cell_3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEventsInTag"];
                [cell_3 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
         */
                NSUInteger row3=[indexPath row];
            
            if(cell_3==nil){
                cell_3 = [[[NSBundle mainBundle]loadNibNamed:@"selectCell" owner:self options:nil] lastObject];//加载nib文件
                 [cell_3 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
            //设置文本
            if (row3<self.EventsInTag.count) {
                
                ((UILabel *)[cell_3.contentView viewWithTag:1]).text = self.EventsInTag[row3];
               // NSLog(@"%@",self.collectEventTitle[row3]);
                // ((UILabel *)[cell_4.contentView viewWithTag:2]).text = self.collectEventTag[row4];
                ((UILabel *)[cell_3.contentView viewWithTag:2]).text = self.EventDateInTag[row3];
                cell_3.backgroundColor = [UIColor clearColor];

             /*
                cell_3.textLabel.text = self.EventsInTag[row3];
                cell_3.backgroundColor = [UIColor clearColor];
                NSLog(@"%@",self.EventsInTag[row3]);
               */ 
            }
            cell = cell_3;
   
            
            break;
        }
        case 3:

        {
            NSUInteger row4=[indexPath row];
            
                if(cell_4==nil){

                    cell_4 = [[[NSBundle mainBundle]loadNibNamed:@"collectCell" owner:self options:nil] lastObject];//加载nib文件
                    
                }
                
                
                
                //设置文本
                if (row4<self.collectEvent.count) {
                    NSLog(@"%@,%@,%@,%@",self.collectEventTitle[row4],self.collectEventTag[row4],self.collectEventDate[row4],self.collectEventStart[row4]);
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 215, 48)];
                    
                    
                    imageView.image = [UIImage imageNamed:self.cellBackground[collectNum%4]];
                    collectNum++;
                    cell_4.selectionStyle = UITableViewCellSelectionStyleDefault;
                    
                    [cell_4 addSubview:imageView];
                    [cell_4 sendSubviewToBack:imageView];
                    // cell_4.backgroundView = imageView;
                    cell_4.backgroundColor = [UIColor clearColor];
                    ((UILabel *)[cell_4.contentView viewWithTag:1]).text = self.collectEventTitle[row4];
                    NSLog(@"%@",self.collectEventTitle[row4]);
                    // ((UILabel *)[cell_4.contentView viewWithTag:2]).text = self.collectEventTag[row4];
                    ((UILabel *)[cell_4.contentView viewWithTag:3]).text = self.collectEventDate[row4];
                    ((UILabel *)[cell_4.contentView viewWithTag:4]).text =[NSString stringWithFormat:@"%@-%@",self.collectEventStart[row4],self.collectEventEnd[row4]];
                    
                }
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor clearColor];
            //bgColorView.layer.cornerRadius = 7;
            bgColorView.layer.masksToBounds = YES;
            [cell_4 setSelectedBackgroundView:bgColorView];
            
            cell = cell_4;
            break;
        }
        case 4:
        {
         /*   if (!cell_5)
            {
                cell_5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectEventsInSearch"];
                [cell_5 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
         */
            NSUInteger row5=[indexPath row];
            
            
            if(cell_5==nil){
                cell_5 = [[[NSBundle mainBundle]loadNibNamed:@"selectCell" owner:self options:nil] lastObject];//加载nib文件
                [cell_5 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }

            //设置文本
            if (row5<self.EventsInSearch.count) {
                
                ((UILabel *)[cell_5.contentView viewWithTag:1]).text = self.EventsInSearch[row5];
                // NSLog(@"%@",self.collectEventTitle[row3]);
                // ((UILabel *)[cell_4.contentView viewWithTag:2]).text = self.collectEventTag[row4];
                ((UILabel *)[cell_5.contentView viewWithTag:2]).text = self.EventDateInSearch[row5];
                cell_5.backgroundColor = [UIColor clearColor];

                
            }
            cell = cell_5;
            
            
            break;
        }
        case 5:
        {
            if (!cell_6)
            {
                cell_6 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingInfoCell"];
                [cell_6 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

            }
            NSUInteger row6=[indexPath row];
            [cell_6 setSelectionStyle:UITableViewCellSelectionStyleDefault];
            //设置文本
            if (row6<self.self.settingInformation.count) {
                cell_6.textLabel.text = self.settingInformation[row6];
                cell_6.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell_6.backgroundColor = [UIColor clearColor];
                
               
            }
            
            cell = cell_6;
            
            break;

        }
        case 6:
        {
            if (!cell_7)
            {
                cell_7 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contractCell"];
//[cell_6 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
            }
            NSUInteger row7=[indexPath row];
            [cell_7 setSelectionStyle:UITableViewCellSelectionStyleNone];
            //设置文本
            //设置文本
            if (row7<self.settingInformationLeft.count) {
                cell_7.textLabel.text = self.settingInformationLeft[row7];
                cell_7.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell_7.backgroundColor = [UIColor clearColor];
                
                cell_7.detailTextLabel.text = self.settingInformationRight[row7];
                cell_7.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
                //cell_6.detailTextLabel.backgroundColor = [UIColor clearColor];
            }
            
            cell = cell_7;
            
            break;
            
        }
        default: cell = nil;
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *evtTitle;
    NSString *evtDate;
    NSNumber *evtID;
    NSInteger row1=[indexPath row];
    sqlite3_stmt *statement;
    
    
    NSString *title_mdfy;
    //NSString *date_mdfy;
    NSString *mainTxt_mdfy;
    NSNumber *evtID_mdfy;
    NSNumber *evtType_mdfy;
    
    NSString *dateGoesIn;
    NSString *dateInCollect;
    NSString *startTime;
    NSString *endTime;
    
    NSNumber *income;
    NSNumber *expend;
    NSString *remind;
    NSString *photo;
    NSString *oldLabel;
    
    const char *dbpath = [databasePath UTF8String];

    
   // tag:0为按日期查询界面中的列表，1为查询界面中的tag列表，2为点击某一tag之后的所有事件列表，3为收藏中的列表，4为关键字查询的列表
    
   // NSLog(@"table:%d",tableView.tag);
    switch (tableView.tag){
        case 0:
            
            break;
        case 1:
        {
            if (soundSwitch) {
                
                CFBundleRef mainbundle=CFBundleGetMainBundle();
                SystemSoundID soundObject_goInDay;
                //获得声音文件URL
                CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
                //创建system sound 对象
                AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
                AudioServicesPlaySystemSound(soundObject_goInDay);
            }
  
            [self.EventsIDInTag removeAllObjects];
            [self.EventsInTag removeAllObjects];
            [self.EventDateInTag removeAllObjects];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT title,eventID,date from event where label like'%%%@%%'",self.allTags[row1]];
                const char *queryEventstatment = [queryEvent UTF8String];
                if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件主题，取出数据。
  
                        char *ttl_mdfy = (char *)sqlite3_column_text(statement, 0);
                        if (ttl_mdfy == nil) {
                            evtTitle = @"空";
                        }else {
                            evtTitle = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                            
                        }
                        
                        evtID = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 2);
                        if (date_mdfy == nil) {
                            evtDate = @"空";
                        }else {
                            evtDate = [[NSString alloc] initWithUTF8String:date_mdfy];
                            
                        }
                        
                        [self.EventsInTag addObject:evtTitle];
                        [self.EventsIDInTag addObject:evtID];
                        [self.EventDateInTag addObject:evtDate];
                    }
                    
                }
                else{
                    NSLog(@"查询不OK");
                }
                sqlite3_finalize(statement);
               

            }
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self.my_select.eventInTagTable reloadData];
            
            [self.my_select.alltagTable setHidden:YES];
            [self.my_select.eventInTagTable setHidden:NO];
            [self.my_select.returnToTags setHidden:NO];
    

        }
            break;
   
        
        case 2:
        {
            
            if (soundSwitch) {
                
                CFBundleRef mainbundle=CFBundleGetMainBundle();
                SystemSoundID soundObject_goInDay;
                //获得声音文件URL
                CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
                //创建system sound 对象
                AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
                AudioServicesPlaySystemSound(soundObject_goInDay);
            }
            
            modifying = 1;
            int eventid = [self.EventsIDInTag[row1] intValue];
            
            sqlite3_stmt *statement;
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,date,startTime,endTime,income,expend,label,remind,photoDir from event where eventID=\"%d\"",eventid];
                const char *queryEventstatment = [queryEvent UTF8String];
                if  (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while  (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件，取出数据。
                        
                        
                        evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                        
                        evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                        char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                        NSLog(@"char_mdfy is %s",ttl_mdfy);
                        if (ttl_mdfy == nil) {
                            title_mdfy = @"";
                        }else {
                            title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                        }
                        
                        char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                        NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                        if (mTxt_mdfy == nil) {
                            mainTxt_mdfy = @"";
                        }else {
                            mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                        }
                        
                        self.textInMain = [NSString stringWithString:mainTxt_mdfy];
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 4);
                        NSLog(@"date_mdfy is %s",date_mdfy);
                        if (date_mdfy == nil) {
                            dateGoesIn = @"";
                        }else {
                            dateGoesIn = [[NSString alloc] initWithUTF8String:date_mdfy];
                            NSLog(@"nsstring_dateGoesIn  is %@",dateGoesIn);
                        }
                        
                        [self seizeArea:dateGoesIn];
                        NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
                        int start = [startTm intValue];
                        NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
                        int end = [endTm intValue];
                        if (start%60<10) {
                            startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];
                            
                        }else{
                            startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                        }
                        if (end%60<10) {
                            endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                            
                        }else{
                            endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                        }
                        
                        
                        NSLog(@"start time is:%@",startTime);
                        
                        income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                        expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,8)];
                        
                        char *oldTags = (char *)sqlite3_column_text(statement, 9);
                        if (oldTags == nil) {
                            oldLabel = @"";
                        }else {
                            oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                            
                            NSLog(@"nsstring_old labels  is %@",oldLabel);
                        }
                        
                        
                        char *remind_mdfy = (char *)sqlite3_column_text(statement, 10);
                        if (remind_mdfy == nil) {
                            remind = @"";
                        }else {
                            remind = [[NSString alloc] initWithUTF8String:remind_mdfy];
                            
                            NSLog(@"nsstring_mdfy  is %@",remind);
                        }
                        
                        char *photo_mdfy = (char *)sqlite3_column_text(statement, 11);
                        if (photo_mdfy == nil) {
                            photo = @"";
                        } else {
                            photo = [[NSString alloc] initWithUTF8String:photo_mdfy];
                            
                            NSLog(@"photo is %@",photo);
                        }
                    }
                    
                }
                else{
                    NSLog(@"wwwwwwwwwwww!!!!!1");
                }
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            editingViewController *my_selectEvent = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
            self.drawLabelDelegate = my_selectEvent;
            my_selectEvent.reloadDelegate = self;
            my_selectEvent.setTextDelegate = self;
            
            
            NSDate* goInEdit = [NSDate dateWithTimeIntervalSinceNow:0];
            my_selectEvent.justInEdit = goInEdit;
            
            
            if([self.today isEqualToString:dateGoesIn]){
                my_selectEvent.drawBtnDelegate = self.my_dayline.my_scoller;
            }else {
                my_selectEvent.drawBtnDelegate = self.my_selectDay.my_scoller;
            }
            //  my_modifyViewController.addTagDataDelegate = self;
            my_selectEvent.tags = self.allTags;
            my_selectEvent.HasEvtDates = self.HasEventsDates;
            
            modifyEventId = [evtID_mdfy intValue];
         
            
            //将该事件还原现使出来
            my_selectEvent.eventType = evtType_mdfy;
            [(UITextField*)[my_selectEvent.view viewWithTag:105] setText:title_mdfy] ;
            [(UITextView*)[my_selectEvent.view viewWithTag:106] setText:mainTxt_mdfy];
            [(UILabel*)[my_selectEvent.view viewWithTag:103] setText:startTime];
            [(UILabel*)[my_selectEvent.view viewWithTag:104] setText:endTime];
            [(UIButton*)[my_selectEvent.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
            [(UIButton*)[my_selectEvent.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
            
            my_selectEvent.imageName = photo;
            if (![photo isEqualToString:@""]) {
                NSArray *images = [photo componentsSeparatedByString:@";"];
                for (int i = 0; i < [images count]; i++) {
                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                                          stringByAppendingPathComponent:[images objectAtIndex:i]];
                    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
                   // UIImageView *imageView = (UIImageView*)[my_selectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    UIButton *imageButton = (UIButton *)[my_selectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    imageButton.tag = IMAGEVIEW_TAG_BASE+i;
                    [imageButton addTarget:my_selectEvent action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [imageButton  setImage:savedImage forState:UIControlStateNormal];                }
            }
            
            my_selectEvent.incomeFinal = [income doubleValue];
            my_selectEvent.expendFinal = [expend doubleValue];
            [self.drawLabelDelegate drawTag:oldLabel];

            my_selectEvent.remindData = remind;
     
            if (my_selectEvent.incomeFinal>0.001 ||my_selectEvent.expendFinal>0.001) {
                [my_selectEvent.moneyButton setImage:[UIImage imageNamed: @"收入高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_selectEvent.moneyButton setImage:[UIImage imageNamed: @"moneyBtn.png"] forState:UIControlStateNormal];
                
            }
            
            if (my_selectEvent.remindData.length >3) {
                [my_selectEvent.remindButton setImage:[UIImage imageNamed: @"提醒高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_selectEvent.remindButton setImage:[UIImage imageNamed: @"remindBtn.png"] forState:UIControlStateNormal];
                
            }

            
            my_selectEvent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:my_selectEvent animated:YES completion:Nil ];
            
        }
            break;
         
        case 3:
        {
            if (soundSwitch) {
                
                CFBundleRef mainbundle=CFBundleGetMainBundle();
                SystemSoundID soundObject_goInDay;
                //获得声音文件URL
                CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
                //创建system sound 对象
                AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
                AudioServicesPlaySystemSound(soundObject_goInDay);
            }
            
            
            NSLog(@"colletcell tapped");
            
            modifying = 1;
            int collectEventid = [self.collectEvent[row1] intValue];
            
            sqlite3_stmt *statement;
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,date,startTime,endTime,income,expend,label,remind,photoDir from event where eventID=\"%d\"",collectEventid];
                const char *queryEventstatment = [queryEvent UTF8String];
                if  (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while  (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件，取出数据。
                        
                        
                        evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                        
                        evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                        char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                        NSLog(@"char_mdfy is %s",ttl_mdfy);
                        if (ttl_mdfy == nil) {
                            title_mdfy = @"";
                        }else {
                            title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                        }
                        
                        char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                        NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                        if (mTxt_mdfy == nil) {
                            mainTxt_mdfy = @"";
                        }else {
                            mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                        }
                        
                        self.textInMain = [NSString stringWithString:mainTxt_mdfy];
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 4);
                        NSLog(@"date_mdfy is %s",date_mdfy);
                        if (date_mdfy == nil) {
                            dateInCollect = @"";
                        }else {
                            dateInCollect = [[NSString alloc] initWithUTF8String:date_mdfy];
                            NSLog(@"nsstring_dateGoesIn  is %@",dateInCollect);
                        }
                        
                        [self seizeArea:dateInCollect];
                        
                        NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
                        int start = [startTm intValue];
                        NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
                        int end = [endTm intValue];
                        if (start%60<10) {
                            startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];
                            
                        }else{
                            startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                        }
                        if (end%60<10) {
                            endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                            
                        }else{
                            endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                        }
                        
                        
                        NSLog(@"start time is:%@",startTime);
                        
                        income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                        expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,8)];
                        
                        char *oldTags = (char *)sqlite3_column_text(statement, 9);
                        if (oldTags == nil) {
                            oldLabel = @"";
                        }else {
                            oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                            
                            NSLog(@"nsstring_old labels  is %@",oldLabel);
                        }
                        
                        
                        char *remind_mdfy = (char *)sqlite3_column_text(statement, 10);
                        if (remind_mdfy == nil) {
                            remind = @"";
                        }else {
                            remind = [[NSString alloc] initWithUTF8String:remind_mdfy];
                            
                            NSLog(@"nsstring_mdfy  is %@",remind);
                        }
                        
                        char *photo_mdfy = (char *)sqlite3_column_text(statement, 11);
                        if (photo_mdfy == nil) {
                            photo = @"";
                        } else {
                            photo = [[NSString alloc] initWithUTF8String:photo_mdfy];
                            
                            NSLog(@"photo is %@",photo);
                        }
                        
                    }
                    
                }
                else{
                    NSLog(@"wwwwwwwwwwww!!!!!1");
                }
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            editingViewController *my_collectEvent = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
            self.drawLabelDelegate = my_collectEvent;
            my_collectEvent.reloadDelegate = self;
            my_collectEvent.setTextDelegate = self;
         
            
            NSDate* goInEdit = [NSDate dateWithTimeIntervalSinceNow:0];
            my_collectEvent.justInEdit = goInEdit;

            
            if ([self.today isEqualToString: dateInCollect]) {
                my_collectEvent.drawBtnDelegate = self.my_dayline.my_scoller;
            }else{
            
                my_collectEvent.drawBtnDelegate = self.my_selectDay.my_scoller;

            }
            
            //  my_modifyViewController.addTagDataDelegate = self;
            my_collectEvent.tags = self.allTags;
            my_collectEvent.HasEvtDates = self.HasEventsDates;
            
            
            
            modifyEventId = [evtID_mdfy intValue];

            
            
            //将该事件还原现使出来
            my_collectEvent.eventType = evtType_mdfy;
            [(UITextField*)[my_collectEvent.view viewWithTag:105] setText:title_mdfy] ;
            [(UITextView*)[my_collectEvent.view viewWithTag:106] setText:mainTxt_mdfy];
            [(UILabel*)[my_collectEvent.view viewWithTag:103] setText:startTime];
            [(UILabel*)[my_collectEvent.view viewWithTag:104] setText:endTime];
            [(UIButton*)[my_collectEvent.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
            [(UIButton*)[my_collectEvent.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
            
            my_collectEvent.imageName = photo;
            if (![photo isEqualToString:@""]) {
                NSArray *images = [photo componentsSeparatedByString:@";"];
                for (int i = 0; i < [images count]; i++) {
                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                                          stringByAppendingPathComponent:[images objectAtIndex:i]];
                    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
                   // UIImageView *imageView = (UIImageView*)[my_collectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    UIButton *imageButton = (UIButton *)[my_collectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    imageButton.tag = IMAGEVIEW_TAG_BASE+i;
                    [imageButton addTarget:my_collectEvent action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [imageButton  setImage:savedImage forState:UIControlStateNormal];
                }
            }
            
            my_collectEvent.incomeFinal = [income doubleValue];
            my_collectEvent.expendFinal = [expend doubleValue];
            [self.drawLabelDelegate drawTag:oldLabel];
            
            my_collectEvent.remindData = remind;
            if (my_collectEvent.incomeFinal>0.001 ||my_collectEvent.expendFinal>0.001) {
                [my_collectEvent.moneyButton setImage:[UIImage imageNamed: @"收入高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_collectEvent.moneyButton setImage:[UIImage imageNamed: @"moneyBtn.png"] forState:UIControlStateNormal];
                
            }
            
            if (my_collectEvent.remindData.length >3) {
                [my_collectEvent.remindButton setImage:[UIImage imageNamed: @"提醒高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_collectEvent.remindButton setImage:[UIImage imageNamed: @"remindBtn.png"] forState:UIControlStateNormal];
                
            }
            my_collectEvent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:my_collectEvent animated:YES completion:Nil ];
     

        }
       
            break;
        
        case 4:
        {
            
            
            if (soundSwitch) {
                
                CFBundleRef mainbundle=CFBundleGetMainBundle();
                SystemSoundID soundObject_goInDay;
                //获得声音文件URL
                CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
                //创建system sound 对象
                AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_goInDay);
                AudioServicesPlaySystemSound(soundObject_goInDay);
            }
            
            modifying = 1;
            int eventid = [self.EventsIDInSearch[row1] intValue];
            
            sqlite3_stmt *statement;
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,date,startTime,endTime,income,expend,label,remind,photoDir from event where eventID=\"%d\"",eventid];
                const char *queryEventstatment = [queryEvent UTF8String];
                if  (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                    while  (sqlite3_step(statement)==SQLITE_ROW) {
                        //找到要查询的事件，取出数据。
                        
                        
                        evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                        
                        evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                        char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                        NSLog(@"char_mdfy is %s",ttl_mdfy);
                        if (ttl_mdfy == nil) {
                            title_mdfy = @"";
                        }else {
                            title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                        }
                        
                        char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                        NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                        if (mTxt_mdfy == nil) {
                            mainTxt_mdfy = @"";
                        }else {
                            mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                            NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                        }
                        
                        self.textInMain = [NSString stringWithString:mainTxt_mdfy];
                        
                        char *date_mdfy = (char *)sqlite3_column_text(statement, 4);
                        NSLog(@"date_mdfy is %s",date_mdfy);
                        if (date_mdfy == nil) {
                            dateGoesIn = @"";
                        }else {
                            dateGoesIn = [[NSString alloc] initWithUTF8String:date_mdfy];
                            NSLog(@"nsstring_dateGoesIn  is %@",dateGoesIn);
                        }
                        
                        [self seizeArea:dateGoesIn];
                        NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
                        int start = [startTm intValue];
                        NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,6)];
                        int end = [endTm intValue];
                        if (start%60<10) {
                            startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];
                            
                        }else{
                            startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                        }
                        if (end%60<10) {
                            endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                            
                        }else{
                            endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                        }
                        
                        
                        NSLog(@"start time is:%@",startTime);
                        
                        income = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,7)];
                        expend = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,8)];
                        
                        char *oldTags = (char *)sqlite3_column_text(statement, 9);
                        if (oldTags == nil) {
                            oldLabel = @"";
                        }else {
                            oldLabel = [[NSString alloc] initWithUTF8String:oldTags];
                            
                            NSLog(@"nsstring_old labels  is %@",oldLabel);
                        }
                        
                        
                        char *remind_mdfy = (char *)sqlite3_column_text(statement, 10);
                        if (remind_mdfy == nil) {
                            remind = @"";
                        }else {
                            remind = [[NSString alloc] initWithUTF8String:remind_mdfy];
                            
                            NSLog(@"nsstring_mdfy  is %@",remind);
                        }
                        
                        char *photo_mdfy = (char *)sqlite3_column_text(statement, 11);
                        if (photo_mdfy == nil) {
                            photo = @"";
                        } else {
                            photo = [[NSString alloc] initWithUTF8String:photo_mdfy];
                            
                            NSLog(@"photo is %@",photo);
                        }
                    }
                    
                }
                else{
                    NSLog(@"wwwwwwwwwwww!!!!!1");
                }
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            editingViewController *my_selectEvent = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
            self.drawLabelDelegate = my_selectEvent;
            my_selectEvent.reloadDelegate = self;
            my_selectEvent.setTextDelegate = self;
            
            my_selectEvent.drawBtnDelegate = self.my_dayline.my_scoller;
            
            
            NSDate* goInEdit = [NSDate dateWithTimeIntervalSinceNow:0];
            my_selectEvent.justInEdit = goInEdit;
           
            //  my_modifyViewController.addTagDataDelegate = self;
            my_selectEvent.tags = self.allTags;
            my_selectEvent.HasEvtDates = self.HasEventsDates;
            
            
            modifyEventId = [evtID_mdfy intValue];

            //将该事件还原现使出来
            my_selectEvent.eventType = evtType_mdfy;
            [(UITextField*)[my_selectEvent.view viewWithTag:105] setText:title_mdfy] ;
            [(UITextView*)[my_selectEvent.view viewWithTag:106] setText:mainTxt_mdfy];
            [(UILabel*)[my_selectEvent.view viewWithTag:103] setText:startTime];
            [(UILabel*)[my_selectEvent.view viewWithTag:104] setText:endTime];
            [(UIButton*)[my_selectEvent.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
            [(UIButton*)[my_selectEvent.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
            
            my_selectEvent.imageName = photo;
            if (![photo isEqualToString:@""]) {
                NSArray *images = [photo componentsSeparatedByString:@";"];
                for (int i = 0; i < [images count]; i++) {
                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                                          stringByAppendingPathComponent:[images objectAtIndex:i]];
                    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
                   // UIImageView *imageView = (UIImageView*)[my_selectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    UIButton *imageButton = (UIButton *)[my_selectEvent.view viewWithTag:IMAGEVIEW_TAG_BASE+i];
                    imageButton.tag = IMAGEVIEW_TAG_BASE+i;
                    [imageButton addTarget:my_selectEvent action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [imageButton  setImage:savedImage forState:UIControlStateNormal];
                }
            }
            
            my_selectEvent.incomeFinal = [income doubleValue];
            my_selectEvent.expendFinal = [expend doubleValue];
            [self.drawLabelDelegate drawTag:oldLabel];
            
            my_selectEvent.remindData = remind;
            if (my_selectEvent.incomeFinal>0.001 ||my_selectEvent.expendFinal>0.001) {
                [my_selectEvent.moneyButton setImage:[UIImage imageNamed: @"收入高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_selectEvent.moneyButton setImage:[UIImage imageNamed: @"moneyBtn.png"] forState:UIControlStateNormal];
                
            }
            
            if (my_selectEvent.remindData.length >3) {
                [my_selectEvent.remindButton setImage:[UIImage imageNamed: @"提醒高亮.png"] forState:UIControlStateNormal];
            }else
            {
                [my_selectEvent.remindButton setImage:[UIImage imageNamed: @"remindBtn.png"] forState:UIControlStateNormal];
                
            }

            my_selectEvent.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:my_selectEvent animated:YES completion:Nil ];
            
        }
            break;
        
          
           case 5:
        {
            if ( (int)row1 == 0){
                self.my_buttonTranslate = [[buttonTranslate alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+80,0, self.view.frame.size.width-85, self.view.frame.size.height )];
                
               // [self.my_buttonTranslate.returnBtn addTarget:self action:@selector(returnBtnTapped) forControlEvents:UIControlEventTouchUpInside];
                [self.my_buttonTranslate.returnToSetting addTarget:self action:@selector(returnToSettingTapped) forControlEvents:UIControlEventTouchUpInside];
                
                [self.homePage addSubview:self.my_buttonTranslate];
                [self.my_setting setHidden:YES];
                
                
                
            }
            
            if ( (int)row1 == 1){
                NSString *lang;
                
                [MobClick event:@"allAPP"];
                if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
                {
                    lang = @"zh";
                    NSLog(@"current Language == Chinese");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];

                }else{
                    lang = @"en";
                    NSLog(@"current Language == English");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
                    
                }
                
            }

            

        
        if ( (int)row1 == 2){
            self.my_contractView = [[contractView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+80,0, self.view.frame.size.width-85, self.view.frame.size.height )];
            self.my_contractView.contractTable.delegate =self;
            self.my_contractView.contractTable.dataSource = self;
            
            [self.my_contractView.returnBtn addTarget:self action:@selector(returnBtnTapped) forControlEvents:UIControlEventTouchUpInside];
            
            [self.homePage addSubview:self.my_contractView];
            [self.my_setting setHidden:YES];
                
            
            
            }
    
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

        }
            break;

            
            

        default:
            
            break;
    }
    
}

-(void)returnToSettingTapped{

    [self.my_setting setHidden:NO];
    [self.my_buttonTranslate removeFromSuperview];
    
}

-(void)returnBtnTapped{

    [self.my_setting setHidden:NO];
    [self.my_contractView removeFromSuperview];
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"sheepcao1986@163.com"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
             }
              ];
         }
     }];
}
//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (tableView.tag ==3) {
        return UITableViewCellEditingStyleDelete;
    }
    else
        return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //使收藏夹可删除
    if (tableView.tag == 3) {
        
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                
                // 删除某一收藏
                NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM collection WHERE eventID=?"];
                
                const char *deletestement = [deleteSql UTF8String];
                sqlite3_prepare_v2(dataBase, deletestement, -1, &statement, NULL);
                sqlite3_bind_int(statement, 1, [[self.collectEvent objectAtIndex:indexPath.row] intValue]);

              
                if (sqlite3_step(statement)==SQLITE_DONE) {
                    NSLog(@"delete collection ok");
                    [self.collectEvent removeObjectAtIndex:indexPath.row];
                }
                else {
                    NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                    
                }
                sqlite3_finalize(statement);
            }
            
            else {
                NSLog(@"数据库打开失败");
                
            }
            sqlite3_close(dataBase);
            
            // Delete the row from the data source.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self.tagTable setEditing:NO animated:YES];
            
            
        }
    }
    else
        return;
    
}


#pragma mark reloadTable delegate
-(void)reloadTable
{
    if (self.my_collect.hidden == NO) {
        [self treasurePass];
    }
    if (self.my_select.hidden ==NO){
        
        NSLog(@"alltags:::%@",self.allTags);
        [self.my_select.eventsTable reloadData];
        [self.my_select.alltagTable reloadData];
        [self.my_select.eventInSearchTable reloadData];
        
        [self.my_select.alltagTable setHidden:NO];
        [self.my_select.eventInTagTable setHidden:YES];
        [self.my_select.returnToTags setHidden:YES];


        
    }
    
}




#pragma mark - 实现取消按钮的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了取消按钮");
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"您点击了键盘上的Search按钮");
    
    //[[Frontia getStatistics] logEvent:@"10020" eventLabel:@"searchEvent"];

    NSString *evtTitle_search;
    NSString *evtDate_search;
    NSNumber *evtID_search;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    [self.EventsIDInSearch removeAllObjects];
    [self.EventsInSearch removeAllObjects];
    [self.EventDateInSearch removeAllObjects];

    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEvent = [NSString stringWithFormat:@"SELECT title,eventID,date from event where title like'%%%@%%' or mainText like'%%%@%%'",searchBar.text,searchBar.text];
        const char *queryEventstatment = [queryEvent UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //找到要查询的事件主题，取出数据。
                
                char *ttl_mdfy = (char *)sqlite3_column_text(statement, 0);
                if (ttl_mdfy == nil) {
                    evtTitle_search = NSLocalizedString(@"空",nil);
                }else {
                    evtTitle_search = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                    
                }
                
                evtID_search = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                
                char *date_mdfy = (char *)sqlite3_column_text(statement, 2);
                if (date_mdfy == nil) {
                    evtDate_search = NSLocalizedString(@"空",nil);
                }else {
                    evtDate_search = [[NSString alloc] initWithUTF8String:date_mdfy];
                    
                }
                
                [self.EventsInSearch addObject:evtTitle_search];
                [self.EventsIDInSearch addObject:evtID_search];
                [self.EventDateInSearch addObject:evtDate_search];
            }
            
        }
        else{
            NSLog(@"查询不OK");
        }
        sqlite3_finalize(statement);
        
        
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    NSLog(@"search result : %@ ",self.EventsInSearch);
    [self.my_select.eventInSearchTable reloadData];
    
     [searchBar resignFirstResponder];
}

#pragma mark -设置正文内容

-(void)setMainText:(UITextView *)mainText
{
   [mainText setText:self.textInMain];
}



-(void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    if ((alertView.tag == 1)) {
        if (buttonIndex == 1) {
            
            UITextField *tf=[alertView textFieldAtIndex:0];
            if([tf.text isEqualToString:password])
            {
                [self treasurePass];
            }
            else{
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"密码错误",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                
               // alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                // alert.tag =1;
                [ alert  show];
                
                
                
            }
        }
    }else if (alertView.tag ==2)
    {
        if (buttonIndex ==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if([tf.text isEqualToString:password])
            {
                [self.my_setting.passwordView setHidden:YES];
                [self.my_setting.tipsView setHidden:YES];
            }
            else{
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"密码错误",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                
                // alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                // alert.tag =1;
                [ alert  show];
                
                [self.my_setting.remindSoundSwitch setOn:YES];
                remindSwitch = YES;

                
                
            }


        }else
        {
            [self.my_setting.remindSoundSwitch setOn:YES];
            remindSwitch = YES;

        }
        
    } else if (alertView.tag == 3)
    {
        if (buttonIndex ==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if([tf.text isEqualToString:password])
            {
                [self.my_setting.passwordView setHidden:NO];
                [self.my_setting.tipsView setHidden:YES];
                [self.my_setting.confirmButton addTarget:self action:@selector(confirmPassword) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"密码错误",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                
                // alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                // alert.tag =1;
                [ alert  show];
                
                
                
                
            }
            
            
        }

    }
    
}


//- (void)adViewDidReceiveAd:(GADBannerView *)view
//{
//    NSLog(@"Admob load");
//   
//}
//
//// An error occured
//- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
//{
//    NSLog(@"Admob error: %@", error);
//    [self.gAdBannerView removeFromSuperview];
//}

//-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//     NSLog(@"iad failed");
//    [self.iAdBannerView removeFromSuperview];
//    self.bannerIsVisible = NO;
//    
//    
//    
//    if (inwhichButton !=1 &&inwhichButton != 2) {
//        [self.view addSubview:self.gAdBannerView];
//
//    }
//
//
//    
//}
//



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma shareMethod

-(void)choseAtIndex:(int)index
{
    switch (index) {
        case 0:
           _scene = WXSceneSession;
            [self sendImageContent];
            break;
        case 1:
            _scene = WXSceneTimeline;
            [self sendImageContent];

            break;
        case 2:
            _scene = WXSceneFavorite;
            [self sendImageContent];

            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
}


- (void) sendImageContent
{
    
   // [self.shareImg scaleToSize:CGSizeMake(470, 2460)];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:self.shareImg];
    
    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
//    NSLog(@"filepath :%@",filePath);
//    ext.imageData = [NSData dataWithContentsOfFile:filePath];
//    
//    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
//    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImageJPEGRepresentation(self.shareImg,1);
    
    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
    //    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}
- (void) RespImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:self.shareImg];
    
    WXImageObject *ext = [WXImageObject object];

    ext.imageData = UIImageJPEGRepresentation(self.shareImg,1);
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}


#pragma mark AD..

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error ad :%@",error);
}


@end
