//
//  rightTranslate.m
//  DaysInLine
//
//  Created by 张力 on 14-3-15.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "rightTranslate.h"

@implementation rightTranslate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int y = 0;
    int height = 0;
    if (screenBounds.size.height == 568) {
        y += 17;
        
        
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        height-=5;
     }
    UIImageView *todayTrans = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48+2*y+height, 217, 50)];
    self.todayTanslate = [[UIButton alloc] initWithFrame:CGRectMake(27, 48+2*y+height, 200, 50)];
    todayTrans.image = [UIImage imageNamed:@"text.png"];
    self.todayTanslate.backgroundColor = [UIColor clearColor];
    [self.todayTanslate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.todayTanslate.titleLabel setNumberOfLines:0];
    [self.todayTanslate setTitle:NSLocalizedString(@"掌控自我，一切从今天开始",nil) forState:UIControlStateNormal];
    [self.todayTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.todayTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.todayTanslate];
    [self addSubview:todayTrans];
    [self bringSubviewToFront:self.todayTanslate];
    
    
    UIImageView *selectTrans = [[UIImageView alloc] initWithFrame:CGRectMake(10, 121+3*y+height, 217, 50)];
    self.selectTanslate = [[UIButton alloc] initWithFrame:CGRectMake(27, 121+3*y+height, 200, 50)];
    selectTrans.image = [UIImage imageNamed:@"text.png"];
    self.selectTanslate.backgroundColor = [UIColor clearColor];
    [self.selectTanslate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.selectTanslate.titleLabel setNumberOfLines:0];
    [self.selectTanslate setTitle:NSLocalizedString(@"多角度精准定位每条记录",nil) forState:UIControlStateNormal];
    [self.selectTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.selectTanslate];
    [self addSubview:selectTrans];
    [self bringSubviewToFront:self.selectTanslate];
    
    UIImageView *collectTrans = [[UIImageView alloc] initWithFrame:CGRectMake(10, 194+4*y+height, 217, 50)];
    self.collectTanslate = [[UIButton alloc] initWithFrame:CGRectMake(27, 194+4*y+height, 200, 50)];
    collectTrans.image = [UIImage imageNamed:@"text.png"];
    self.collectTanslate.backgroundColor = [UIColor clearColor];
    [self.collectTanslate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.collectTanslate.titleLabel setNumberOfLines:0];
    [self.collectTanslate setTitle:NSLocalizedString(@"收录重点事项，支持加密功能",nil) forState:UIControlStateNormal];
    [self.collectTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.collectTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.collectTanslate];
    [self addSubview:collectTrans];
    [self bringSubviewToFront:self.collectTanslate];

    UIImageView *analyseTrans = [[UIImageView alloc] initWithFrame:CGRectMake(10, 267+5*y+height, 217, 50)];
    self.analyseTanslate = [[UIButton alloc] initWithFrame:CGRectMake(27, 267+5*y+height, 200, 50)];
    analyseTrans.image = [UIImage imageNamed:@"text.png"];
    self.analyseTanslate.backgroundColor = [UIColor clearColor];
    [self.analyseTanslate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.analyseTanslate.titleLabel setNumberOfLines:0];
   // [self.analyseTanslate setBackgroundImage:[UIImage imageNamed:@"text.png"] forState:UIControlStateNormal];
    [self.analyseTanslate setTitle:NSLocalizedString(@"任意选取时段，绘制生活状态图",nil) forState:UIControlStateNormal];
    [self.analyseTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.analyseTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.analyseTanslate];
    [self addSubview:analyseTrans];
    [self bringSubviewToFront:self.analyseTanslate];
    
    UIImageView *settingTrans = [[UIImageView alloc] initWithFrame:CGRectMake(10, 340+6*y+height, 217, 50)];
    self.settingTanslate = [[UIButton alloc] initWithFrame:CGRectMake(27, 340+6*y+height, 200, 50)];
    settingTrans.image = [UIImage imageNamed:@"text.png"];
    self.settingTanslate.backgroundColor = [UIColor clearColor];
    [self.settingTanslate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.settingTanslate.titleLabel setNumberOfLines:0];
    [self.settingTanslate setTitle:NSLocalizedString(@"声音、加密、教程及反馈",nil) forState:UIControlStateNormal];
    [self.settingTanslate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.settingTanslate.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.settingTanslate];
    [self addSubview:settingTrans];
    [self bringSubviewToFront:self.settingTanslate];
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
