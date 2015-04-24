//
//  statisticView.m
//  DaysInLine
//
//  Created by 张力 on 14-1-26.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "statisticView.h"

@implementation statisticView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
       // UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.origin.y+30, 38 , 20) ];
        //tips.text = @"请选择想要分析的时间段：";
       // tips.backgroundColor = [UIColor clearColor];
        
       // title.image = [UIImage imageNamed:@"统计汉字.png"];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-35, self.frame.origin.y+30, 80 , 20) ];
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"统 计",nil);
        title.font = [UIFont fontWithName:@"BoldOblique" size:18];
        [title setTextColor:[UIColor darkGrayColor]];
        [self addSubview:title];
       
        /*
        UILabel *to= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, self.frame.size.height/2-30, 40, 40) ];
        to.text = @"到";
        to.font = [UIFont systemFontOfSize:28.0];
        to.layer.borderColor = [UIColor clearColor].CGColor;
        */
        UIImageView *to = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-19, self.frame.size.height/2-32, 47, 25) ];
        to.image = [UIImage imageNamed: @"到"];
        [self addSubview:to];

        
        self.dateStart = [[UIDatePicker alloc] init] ;
        
        self.dateStart.datePickerMode = UIDatePickerModeDate;
        self.dateStart.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-100);
        
        
        
        self.dateEnd = [[UIDatePicker alloc] init] ;
        
        self.dateEnd.datePickerMode = UIDatePickerModeDate;
        self.dateEnd.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+60);
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            self.dateStart.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-120);
            self.dateEnd.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+80);
            

            self.dateStart.transform = CGAffineTransformMakeScale(0.75, 0.75);
            self.dateEnd.transform = CGAffineTransformMakeScale(0.75, 0.75);
        }else{
            self.dateStart.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-100);
            self.dateEnd.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+60);

            self.dateStart.transform = CGAffineTransformMakeScale(0.55, 0.55);
            self.dateEnd.transform = CGAffineTransformMakeScale(0.55, 0.55);

        }
        

        [self addSubview:self.dateStart];

        [self addSubview:self.dateEnd];
        
        
             
        
        self.resultButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-100, 100, 30) ];
        [self.resultButton setBackgroundImage:[UIImage imageNamed: @"password.png"] forState:UIControlStateNormal];
        [self.resultButton setTitle:NSLocalizedString(@"查看结果",nil) forState:UIControlStateNormal];
        self.resultButton.backgroundColor = [UIColor clearColor];
        
        [self.resultButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.resultButton.titleLabel.font = [UIFont fontWithName:@"BoldOblique" size:17];
        

        [self addSubview:self.resultButton];


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
