//
//  remindViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-12-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "remindViewController.h"
#import "globalVars.h"

@interface remindViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UIView *viewDate;
@property (strong,nonatomic) UIView *viewInterval;
@property (strong,nonatomic) UILabel *setTimeLabel;
@property (strong,nonatomic) UILabel *setTimeLabel2;

@end

@implementation remindViewController
UITextField *daysInterval;
UILabel *dayslabel;
UIDatePicker *remindDatePicker ;
UIDatePicker *remindTimePicker ;
UIDatePicker *remindTimePicker2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.remindMode.frame = CGRectMake(44, 48, 230, 43);
            
            NSLog(@"remind7!!!!");
        }else{
            self.remindMode.frame = CGRectMake(44, 28, 230, 43);
        }

        self.remindMode = (UISegmentedControl *)[self.view viewWithTag:251];
        [self.remindMode setTitle:NSLocalizedString(@"按日期设置",nil) forSegmentAtIndex:0];//设置指定索引的题目
        [self.remindMode setTitle:NSLocalizedString(@"按间隔设置",nil) forSegmentAtIndex:1];//设置指定索引的题目


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgrd=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20)];
    //[backgrd setImage:[UIImage imageNamed:@"提醒背景.png"]];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    if (screenBounds.size.height == 568) {
        
        [backgrd setImage:[UIImage imageNamed:@"提醒背景586.png"]];
        
        self.viewDate = [[UIView alloc] initWithFrame:CGRectMake(0,110,self.view.frame.size.width, self.view.frame.size.height-265)];
        self.viewInterval = [[UIView alloc] initWithFrame:CGRectMake(0,110,self.view.frame.size.width, self.view.frame.size.height-265)];
        
        self.setTimeLabel= [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-295, self.view.frame.size.width-70, 30)];
        self.setTimeLabel2= [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-295, self.view.frame.size.width-70, 30)];
        
       
//        self.gAdBannerView = [[GADBannerView alloc]
//                              initWithFrame:CGRectMake(0.0,self.view.frame.size.height - GAD_SIZE_320x50.height,GAD_SIZE_320x50.width,GAD_SIZE_320x50.height)];
//        
//        self.gAdBannerView.adUnitID = ADMOB_ID;//调用id
//        
//        self.gAdBannerView.rootViewController = self;
//        self.gAdBannerView.backgroundColor = [UIColor clearColor];
//        
//        [self.gAdBannerView loadRequest:[GADRequest request]];
//        [self.view addSubview:self.gAdBannerView];
    }else{
        
        [backgrd setImage:[UIImage imageNamed:@"提醒背景.png"]];
        
        self.viewDate = [[UIView alloc] initWithFrame:CGRectMake(0,70,self.view.frame.size.width, self.view.frame.size.height-180)];
        self.viewInterval = [[UIView alloc] initWithFrame:CGRectMake(0,70,self.view.frame.size.width, self.view.frame.size.height-180)];

        
        self.setTimeLabel= [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-195, self.view.frame.size.width-70, 30)];
        self.setTimeLabel2= [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-195, self.view.frame.size.width-70, 30)];

     /*
        self.gAdBannerView = [[GADBannerView alloc]
                              initWithFrame:CGRectMake(0.0,self.view.frame.size.height - GAD_SIZE_320x50.height,GAD_SIZE_320x50.width,GAD_SIZE_320x50.height)];
        
        self.gAdBannerView.adUnitID = ADMOB_ID;//调用id
        
        self.gAdBannerView.rootViewController = self;
        self.gAdBannerView.backgroundColor = [UIColor clearColor];
        
        [self.gAdBannerView loadRequest:[GADRequest request]];
        [self.view addSubview:self.gAdBannerView];
*/
    }
    
    self.setTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.setTimeLabel2.textAlignment = NSTextAlignmentCenter;

    
    [self.view addSubview:backgrd];
    [self.view sendSubviewToBack:backgrd];
   
    
    




  //  self.viewDate.backgroundColor = [UIColor greenColor];
    
        self.setTimeLabel.textColor = [UIColor blackColor];
    self.setTimeLabel.backgroundColor = [UIColor clearColor];
   // self.setTimeLabel2 = self.setTimeLabel;
    
   
    self.setTimeLabel2.textColor = [UIColor blackColor];
    self.setTimeLabel2.backgroundColor = [UIColor clearColor];
    
    if (self.remindDate) {
        self.setTimeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
        self.setTimeLabel2.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
    }
    
   // [self.view addSubview:self.setTimeLabel];
    
    //按日期设置提醒时间的视图
    
    //self.viewInterval.backgroundColor = [UIColor clearColor];
   // self.viewDate.backgroundColor = [UIColor clearColor];
    remindDatePicker = [[UIDatePicker alloc] init] ;
    remindTimePicker = [[UIDatePicker alloc] init] ;
    remindTimePicker2 = [[UIDatePicker alloc] init] ;
    
    if (screenBounds.size.height == 568) {


        remindDatePicker.center = CGPointMake(self.view.frame.size.width/2, 70);
       
        remindTimePicker.center = CGPointMake(self.view.frame.size.width/2, 210);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            //NSLog(@"ios7!!!!");
            remindDatePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);
            remindTimePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);

        }else
        {
            remindDatePicker.transform = CGAffineTransformMakeScale(0.55, 0.5);
            remindTimePicker.transform = CGAffineTransformMakeScale(0.55, 0.5);
            

        }
        
        
    }else{
        remindDatePicker.center = CGPointMake(self.view.frame.size.width/2, 70);
        
        remindDatePicker.transform = CGAffineTransformMakeScale(0.65, 0.6);
        
        remindTimePicker.center = CGPointMake(self.view.frame.size.width/2, 210);
        remindTimePicker.transform = CGAffineTransformMakeScale(0.65, 0.6);
        
    }

    remindDatePicker.datePickerMode = UIDatePickerModeDate;
//    remindDatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 30);


    [self.viewDate addSubview:remindDatePicker];
    
    remindTimePicker.datePickerMode = UIDatePickerModeTime;
 //   remindTimePicker.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 30);
 

    
    
     [self.viewDate addSubview:remindTimePicker];
    

    
    
    [self.remindMode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.remindMode.selectedSegmentIndex= 0;
    if (screenBounds.size.height == 568) {
        
        self.returnButton = [[UIButton alloc] initWithFrame:CGRectMake(remindDatePicker.frame.origin.x+10, self.view.frame.size.height-150, 40, 40)];
        self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(230 , self.view.frame.size.height-150, 40, 40)];
        
    }else{
        self.returnButton = [[UIButton alloc] initWithFrame:CGRectMake(remindDatePicker.frame.origin.x, self.view.frame.size.height-88, 40, 40)];
        self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(240 , self.view.frame.size.height-88, 40, 40)];
        
        
    }
    

    
    [self.okButton setImage:[UIImage imageNamed:@"okInAlert.png"] forState:UIControlStateNormal];
    [self.returnButton setImage:[UIImage imageNamed:@"returnInAlert.png"] forState:UIControlStateNormal];
    
    [self.okButton addTarget:self action:@selector(remindOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.returnButton addTarget:self action:@selector(remindCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.okButton];
    [self.view addSubview:self.returnButton];
    
    
    [self.viewDate addSubview:self.setTimeLabel];
    
    [self.view addSubview:self.viewDate];

    //按间隔设置提醒时间的视图
    daysInterval = [[UITextField alloc] init];
    daysInterval.frame = CGRectMake(0, 0, 70, 30);
    daysInterval.center = CGPointMake(self.view.frame.size.width/2-25, 60);
    daysInterval.font = [UIFont fontWithName:@"Courier-BoldOblique" size:24.0];
    daysInterval.textAlignment = NSTextAlignmentCenter;
    daysInterval.keyboardType = UIKeyboardTypeNumberPad;
    [daysInterval setBackground:[UIImage imageNamed:@"timeBtn1.png"]];
   // daysInterval.backgroundColor = [UIColor whiteColor];
    daysInterval.delegate = self;
    dayslabel = [[UILabel alloc] init];
    dayslabel.frame = CGRectMake(0, 0, 100, 40);
    dayslabel.center = CGPointMake(self.view.frame.size.width/2+65, 60);
    dayslabel.text = NSLocalizedString(@"天后",nil);
    dayslabel.textColor = [UIColor purpleColor];
    dayslabel.backgroundColor = [UIColor clearColor];
    dayslabel.textAlignment = NSTextAlignmentCenter;
    dayslabel.layer.borderColor = [UIColor clearColor].CGColor;
    dayslabel.font = [UIFont fontWithName:@"Courier-BoldOblique" size:15.0];
    [self.viewInterval addSubview:daysInterval];
    [self.viewInterval addSubview:dayslabel];
    remindTimePicker2.datePickerMode = UIDatePickerModeTime;
    remindTimePicker2.frame = CGRectMake(0, 0, self.view.frame.size.width-120, 30);
    remindTimePicker2.center = CGPointMake(self.view.frame.size.width/2, 180);
    remindTimePicker2.transform = CGAffineTransformMakeScale(0.65, 0.6);
    
    
    [self.viewInterval addSubview:self.setTimeLabel2];
    [self.viewInterval addSubview:remindTimePicker2];
   
    
   
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)valueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    NSLog(@"!!!!!!%ld",(long)myUISegmentedControl.selectedSegmentIndex);
    if (myUISegmentedControl.selectedSegmentIndex == 0) {
        if (self.viewInterval) {
            [self.viewInterval removeFromSuperview];
            [self.view addSubview:self.viewDate];


        }
        else if(self.viewDate){
        
            return;
        }
    
        
    }
    else if(myUISegmentedControl.selectedSegmentIndex == 1){
        
        if (self.viewDate) {
            [self.viewDate removeFromSuperview];
            [self.view addSubview:self.viewInterval];
            
            
        }
        else if(self.viewInterval){
            
            return;
        }
        
    }
    
}


-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    //  NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    //  NSLog(@"current appear tab title %@", cName);
    //[[Frontia getStatistics] pageviewStartWithName:@"remindView"];
}

-(void) viewDidDisappear:(BOOL)animated
{
    // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    // NSLog(@"current disappear tab title %@", cName);
    //[[Frontia getStatistics] pageviewEndWithName:@"remindView"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [daysInterval resignFirstResponder];
}

- (IBAction)remindOkButton:(UIButton *)sender {
    
     //[[Frontia getStatistics] logEvent:@"10009" eventLabel:@"remindTap"];
    
   // NSDate *now = [[NSDate alloc] init];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy-MM-dd";
   // NSString *time1 = [formatter stringFromDate:now];
   // NSDate *dateNow = [formatter dateFromString:time1];
    NSDate *dateTime = [formatter dateFromString:modifyDate];
    //时区偏移
    NSInteger zoneInterval = [zone secondsFromGMTForDate: dateTime];
    
 //   NSDate *localDate = [dateTime  dateByAddingTimeInterval: zoneInterval];

    
    if (self.remindMode.selectedSegmentIndex == 0 ) {
        
        self.remindDate = [formatter stringFromDate:remindDatePicker.date];
        formatter.dateFormat = @"H:mm";
        self.remindTime = [formatter stringFromDate:remindTimePicker.date];
        

        self.setTimeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
        self.setTimeLabel2.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
        
      
    
    }
    else if(self.remindMode.selectedSegmentIndex == 1)
    {
        NSInteger interval = [daysInterval.text intValue];
        NSLog(@"ttttttt%@",modifyDate);
        
        NSDate *remindDate = [dateTime dateByAddingTimeInterval:zoneInterval+interval*24*60*60];
        self.remindDate = [formatter stringFromDate:remindDate];
        
        formatter.dateFormat = @"H:mm";
        self.remindTime = [formatter stringFromDate:remindTimePicker2.date];
        
        
        self.setTimeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
        self.setTimeLabel2.text =[NSString stringWithFormat:NSLocalizedString(@"已设提醒:%@  %@",nil),self.remindDate,self.remindTime];
        
        
    }


    
    NSLog(@"self.remindDate = %@,,,,,, self.remindTime = %@",self.remindDate,self.remindTime);
   // [self dismissViewControllerAnimated:YES completion:nil];


}

- (IBAction)remindCancelButton:(id)sender {
    if (self.remindDate) {
 
    
    [self.setRemindDelegate setRemindData:self.remindDate :self.remindTime ];
    

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
