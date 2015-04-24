//
//  resultView.m
//  DaysInLine
//
//  Created by 张力 on 14-2-27.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "resultView.h"

@implementation resultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int y = self.frame.origin.y ;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            //NSLog(@"ios7!!!!");
            y += 5;

        }
        
        UILabel *longSentence;
        
        /* fit for 4-inch screen */
         CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            y += 50;
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-130, 110, 32)];
        self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(190, y+73, 50, 50)];
        longSentence = [[UILabel alloc] initWithFrame:CGRectMake(70, y+73, 250, 50)];

        }else
        {
            y-=10;
        self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height-90, 110, 32)];
        self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(190, y+83, 50, 50)];
           
        longSentence = [[UILabel alloc] initWithFrame:CGRectMake(70, y+83, 250, 50)];

        }
        
        longSentence.text = NSLocalizedString(@"该阶段共有记录           天",nil);
        [longSentence setTextColor:[UIColor darkGrayColor]];
        longSentence.font = [UIFont fontWithName:@"BoldOblique" size:10];
        longSentence.backgroundColor = [UIColor clearColor];
        [self addSubview:longSentence];
        
        self.continueButton.backgroundColor = [UIColor clearColor];
        [self.continueButton setBackgroundImage:[UIImage imageNamed: @"password.png"] forState:UIControlStateNormal];
        [self.continueButton setTitle:NSLocalizedString(@"继续努力",nil) forState:UIControlStateNormal];
        [self.continueButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.continueButton.titleLabel.font = [UIFont fontWithName:@"BoldOblique" size:15];
        [self addSubview:self.continueButton];
        

        
        
       // self.daysCount = [[UILabel alloc] initWithFrame:CGRectMake(175, y+73, 50, 50)];
        self.daysCount.backgroundColor = [UIColor clearColor];
        self.daysCount.textAlignment = NSTextAlignmentCenter;
        self.daysCount.textColor = [UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f];
        self.daysCount.font = [UIFont systemFontOfSize:22.0];
        [self addSubview:self.daysCount];
        [self bringSubviewToFront:self.daysCount];
        
        UIImageView *workImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +133, 260    , 30)];
        [workImage setImage:[UIImage imageNamed:@"工作生活.png"]];
        
        UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(37,y +133, 80    , 30)];
        workLabel.text = NSLocalizedString(@"工作",nil);
       // workLabel.textAlignment = NSTextAlignmentLeft;
        workLabel.backgroundColor = [UIColor clearColor];
        [workLabel setTextColor:[UIColor whiteColor]];
        workLabel.font = [UIFont systemFontOfSize:13.0f];
        [self bringSubviewToFront:workLabel];
        
        UILabel *lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(248,y +133, 80    , 30)];
        lifeLabel.text = NSLocalizedString(@"生活",nil);
        lifeLabel.backgroundColor = [UIColor clearColor];
        [lifeLabel setTextColor:[UIColor darkGrayColor]];
        lifeLabel.font = [UIFont systemFontOfSize:13.0f];
        [self bringSubviewToFront:lifeLabel];
        
        UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(37,y +195, 80    , 30)];
        moodLabel.text = NSLocalizedString(@"心情",nil);
        moodLabel.backgroundColor = [UIColor clearColor];
        [moodLabel setTextColor:[UIColor whiteColor]];
        moodLabel.font = [UIFont systemFontOfSize:12.0f];
        [self bringSubviewToFront:moodLabel];
        
        UILabel *growLabel = [[UILabel alloc] initWithFrame:CGRectMake(33,y +240, 80    , 30)];
        growLabel.text = NSLocalizedString(@"成长",nil);
        growLabel.backgroundColor = [UIColor clearColor];
        [growLabel setTextColor:[UIColor whiteColor]];
        growLabel.font = [UIFont systemFontOfSize:12.0f];
        [self bringSubviewToFront:growLabel];
        
        UILabel *incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(37,y +290, 80    , 30)];
        incomeLabel.text = NSLocalizedString(@"收入",nil);
        incomeLabel.backgroundColor = [UIColor clearColor];
        [incomeLabel setTextColor:[UIColor whiteColor]];
        incomeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self bringSubviewToFront:incomeLabel];
        
        UILabel *expendLabel = [[UILabel alloc] initWithFrame:CGRectMake(33,y +335, 80    , 30)];
        expendLabel.text = NSLocalizedString(@"支出",nil);
        expendLabel.backgroundColor = [UIColor clearColor];
        [expendLabel setTextColor:[UIColor whiteColor]];
        expendLabel.font = [UIFont systemFontOfSize:12.0f];
        [self bringSubviewToFront:expendLabel];
        
        self.workingLong = [[UILabel alloc] init];
        self.workingLong.backgroundColor = [UIColor colorWithRed:97/255.0f green:197/255.0f blue:185/255.0f alpha:1.0f];
        self.workingTime = [[UILabel alloc] initWithFrame:CGRectMake(80,y +133, 100 , 16)];
        self.workingTime.backgroundColor = [UIColor clearColor];
        self.workingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        
        self.lifeLong = [[UILabel alloc] init];
        self.lifeLong.backgroundColor = [UIColor colorWithRed:246/255.0f green:235/255.0f blue:127/255.0f alpha:1.0f];
        self.lifingTime = [[UILabel alloc] initWithFrame:CGRectMake(141,y +133, 100 , 16)];
        self.lifingTime.backgroundColor = [UIColor clearColor];
        self.lifingTime.textAlignment = NSTextAlignmentRight;
        self.lifingTime.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.lifeLong];
        [self addSubview:self.lifingTime];
        [self addSubview:self.workingLong];
        [self addSubview:self.workingTime];

        
        UIImageView *moodImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +195, 260    , 30)];
        [moodImage setImage:[UIImage imageNamed:@"心情.png"]];

        
        self.moodLong = [[UILabel alloc] init];
        self.moodLong.backgroundColor = [UIColor colorWithRed:241/255.0f green:99/255.0f blue:105/255.0f alpha:1.0f];
        self.mood = [[UILabel alloc] init];
        self.mood.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.mood.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.mood];
        [self addSubview:self.moodLong];
     
        
        [self addSubview:moodImage];
        
        UIImageView *growImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +240, 260    , 30)];
        [growImage setImage:[UIImage imageNamed:@"成长.png"]];
        
        self.growLong = [[UILabel alloc] init];
        self.growLong.backgroundColor = [UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f];
        self.grow = [[UILabel alloc] init];
        self.grow.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.grow.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:self.grow];
        [self addSubview:self.growLong];
        
        [self addSubview:growImage];
        
        UIImageView *incomeImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +290, 260    , 30)];
        [incomeImage setImage:[UIImage imageNamed:@"收入.png"]];
        
        self.incomingLong = [[UILabel alloc] init];
        self.incomingLong.backgroundColor = [UIColor colorWithRed:151/255.0f green:204/255.0f blue:114/255.0f alpha:1.0f];
        self.incoming = [[UILabel alloc] init];
        self.incoming.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.incoming.font = [UIFont systemFontOfSize:10.0];
        
        [self addSubview:self.incoming];
        [self addSubview:self.incomingLong];
        [self addSubview:incomeImage];
        
        UIImageView *expendImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,y +335, 260    , 30)];
        [expendImage setImage:[UIImage imageNamed:@"支出.png"]];
        
        self.expendingLong = [[UILabel alloc] init];
        self.expendingLong.backgroundColor = [UIColor colorWithRed:251/255.0f green:176/255.0f blue:64/255.0f alpha:1.0f];
       // [self bringSubviewToFront:self.expendingLong];
        self.expending = [[UILabel alloc] init];
        self.expending.backgroundColor = [UIColor clearColor];
        ///self.mood.textAlignment = NSTextAlignmentRight;
        self.expending.font = [UIFont systemFontOfSize:10.0];
        
        [self addSubview:self.expending];
        [self addSubview:self.expendingLong];
        
        [self addSubview:expendImage];
        
        [self addSubview:workImage];
        [self addSubview:workLabel];
        [self addSubview:lifeLabel];
        [self addSubview:moodLabel];
        [self addSubview:growLabel];
        [self addSubview:incomeLabel];
        [self addSubview:expendLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
