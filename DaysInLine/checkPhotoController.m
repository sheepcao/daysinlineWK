//
//  checkPhotoController.m
//  DaysInLine
//
//  Created by 张力 on 14-2-9.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "checkPhotoController.h"

@interface checkPhotoController ()

@end

@implementation checkPhotoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *backImage;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        
       backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        NSLog(@"586height:%.2f",self.view.bounds.size.height);
        [backImage setImage:[UIImage imageNamed:@"照片背景586.png"]];
        
       //        if (screenBounds.size.height == 568) {
//            self.gAdBannerView = [[GADBannerView alloc]
//                                  initWithFrame:CGRectMake(0.0,self.view.frame.size.height+10,GAD_SIZE_320x50.width,GAD_SIZE_320x50.height)];
//            
//            self.gAdBannerView.adUnitID = ADMOB_ID;//调用id
//            
//            self.gAdBannerView.rootViewController = self;
//            self.gAdBannerView.backgroundColor = [UIColor clearColor];
//            
//            [self.gAdBannerView loadRequest:[GADRequest request]];
//            [self.view addSubview:self.gAdBannerView];
//        }

        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 50)];
        photoLabel.text = NSLocalizedString(@"照片浏览",nil);
        photoLabel.textAlignment = NSTextAlignmentCenter;
        [photoLabel setTextColor:[UIColor darkGrayColor]];
        photoLabel.font = [UIFont fontWithName:@"BoldOblique" size:18];
        photoLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:photoLabel];


        
        
    }else{
       backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [backImage setImage:[UIImage imageNamed:@"照片背景.png"]];
        
        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 22, 100, 50)];
        photoLabel.text = NSLocalizedString(@"照片浏览",nil);
        photoLabel.textAlignment = NSTextAlignmentCenter;

        [photoLabel setTextColor:[UIColor darkGrayColor]];
        photoLabel.font = [UIFont fontWithName:@"BoldOblique" size:18];
        photoLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:photoLabel];
        
    }

    
    [self.view addSubview:backImage];
    [self.view sendSubviewToBack:backImage];
    
   // CGRect screenBounds = [[UIScreen mainScreen] bounds];
  
    
   // self.fullPhoto.backgroundColor = [UIColor blackColor];
    self.fullPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    //  NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    //  NSLog(@"current appear tab title %@", cName);
    //[[Frontia getStatistics] pageviewStartWithName:@"photoView"];
}

-(void) viewDidDisappear:(BOOL)animated
{
    // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    // NSLog(@"current disappear tab title %@", cName);
    //[[Frontia getStatistics] pageviewEndWithName:@"photoView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToEdit:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
