//
//  collectionView.m
//  DaysInLine
//
//  Created by 张力 on 14-1-7.
//  Copyright (c) 2014年 张力. All rights reserved.
//

#import "collectionView.h"

@implementation collectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       /*
        // Initialization code
        self.collectionScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10,55,self.frame.size.width-20, self.frame.size.height-100)];
        self.collectionScroll.backgroundColor = [UIColor grayColor];
        [self addSubview:self.collectionScroll];
        */
        
       // UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.origin.y+30, 50 , 20) ];
        //tips.text = @"请选择想要分析的时间段：";
        // tips.backgroundColor = [UIColor clearColor];
        
      //  title.image = [UIImage imageNamed:@"收藏夹汉字.png"];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.origin.y+30, 80 , 20) ];
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"收藏夹",nil);
        title.font = [UIFont fontWithName:@"BoldOblique" size:18];
        [title setTextColor:[UIColor darkGrayColor]];

        [self addSubview:title];
        
        self.collectionTable = [[UITableView alloc] initWithFrame:CGRectMake(10,70,self.frame.size.width-20, self.frame.size.height-100)];
   
        self.collectionTable.tag = 3;
        self.collectionTable.rowHeight = 48;
        self.collectionTable.backgroundColor = [UIColor clearColor];
        [self.collectionTable setSeparatorColor:[UIColor clearColor]];
        
        /*
        UIImageView *rightBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        rightBackground.image = [UIImage imageNamed:@"rightBackground.png"];
        
        [self addSubview:rightBackground];
        [self sendSubviewToBack:rightBackground];
*/
       // self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"rightBackground.png"]];
        

        
        [self addSubview:self.collectionTable];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawi ng.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
