//
//  contractView.m
//  DaysInLine
//
//  Created by 张力 on 14-3-14.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "contractView.h"

@implementation contractView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
   
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40 , 140, 140)];
    logoImage.image = [UIImage imageNamed:@"logo.png"];
    
    self.contractTable = [[UITableView alloc]initWithFrame:CGRectMake(5,self.frame.size.height/2-50,self.frame.size.width-15, 100) style:UITableViewStylePlain];
    
   self.contractTable.tag = 6;
   self.contractTable.rowHeight = 36;
   self.contractTable.backgroundColor = [UIColor clearColor];
    
    
    
    self.returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-35, self.contractTable.frame.origin.y + 180,  83, 30)];
    [self.returnBtn setBackgroundImage:[UIImage imageNamed:@"password.png"] forState:UIControlStateNormal];
    [self.returnBtn setTitle:NSLocalizedString(@"返回",nil) forState:UIControlStateNormal] ;
    [self.returnBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.returnBtn.titleLabel.font = [UIFont fontWithName:@"BoldOblique" size:17];
   // self.returnBtn.backgroundColor = [UIColor clearColor];
   // [self.returnBtn setTitle:@"返回" forState:UIControlStateNormal] ;
    //[self.returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //self.returnBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    //self.returnBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    //self.returnBtn.layer.borderWidth = 0.4f;
    
    [self addSubview:logoImage];
    [self addSubview:self.contractTable];
    [self addSubview:self.returnBtn];
    
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
