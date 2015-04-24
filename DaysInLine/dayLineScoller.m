//
//  dayLineScoller.m
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "dayLineScoller.h"
#import "buttonInScroll.h"
#import "ViewController.h"


@interface dayLineScoller ()



@end

@implementation dayLineScoller

const int TIME_LABEL_SPACE  = 50;
const int TIME_LABEL_WIDTH  = 40;
const int TIME_LABEL_HEIGHT = 20;
const int NR_TIME_LABEL = 24;
const int MINUTES_OF_DAY = 24 * 60;
const int TIME_LABEL_TAG_BASE = 2000;

UILabel *labelTime[NR_TIME_LABEL];

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor clearColor];
        CGSize newSize = CGSizeMake(self.frame.size.width, NR_TIME_LABEL*TIME_LABEL_SPACE);
        [self setContentOffset:CGPointMake(0, 6 * TIME_LABEL_SPACE)]; /* scroller initially stay at 6:00 */
        [self setContentSize:newSize];


        self.viewToShare = [[shareView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NR_TIME_LABEL*TIME_LABEL_SPACE)];
        self.viewToShare.backgroundColor = [UIColor clearColor];
       // [self.shareView setHidden:NO];
        [self addSubview:self.viewToShare];
        
       
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    
    

    for (int i = 0; i < NR_TIME_LABEL; i++) {
        
        
        labelTime[i] = [[UILabel alloc] initWithFrame:
                        CGRectMake(0, i*TIME_LABEL_SPACE, TIME_LABEL_WIDTH, TIME_LABEL_HEIGHT)];
        labelTime[i].font = [UIFont systemFontOfSize:14.0];
        labelTime[i].backgroundColor = [UIColor clearColor];
        labelTime[i].text = [NSString stringWithFormat:@"%02d:00",i % NR_TIME_LABEL];
        labelTime[i].tag = TIME_LABEL_TAG_BASE + i;
        [self.viewToShare addSubview:labelTime[i]];
       // [self addSubview: labelTime[i]];

    }

}


#pragma redrawButton delegate

-(void)redrawButton:(NSNumber *)startNum :(NSNumber *)endNum :(NSString *)title :(NSNumber *)eventType :(NSNumber *)oldStartNum
{
    
   //enentType:0为工作事件，1为生活事件 startNum=nil时为删除该事件。
    //NSLog(@"drawing begin");
    if (oldStartNum) {
        if ([self.viewToShare.subviews count] > 0) {
            //NSLog(@"finding the right button:%d",[oldStartNum intValue]);
            
            for (UIView *curView in self.viewToShare.subviews) {
                NSLog(@"button tag is : %ld",(long)curView.tag);
                if (curView.tag == [eventType intValue]*1000+[oldStartNum integerValue]/15) {
                    NSLog(@"find it!!!!");
                    [curView removeFromSuperview];
                    [curView setNeedsDisplay];
                }
                
            }
        }
        if (startNum == nil) {
            return;
        }
    }
    
    
    //NSLog(@"redraw");
    
    int h = self.contentSize.height;
    double start = ([startNum doubleValue]/MINUTES_OF_DAY) * h +5;//+ TIME_LABEL_HEIGHT / 2;
    double end = ([endNum doubleValue]/MINUTES_OF_DAY) * h +5;//+ TIME_LABEL_HEIGHT / 2;
    double height = end - start;
  
    
    UIButton *eventButton;
    if ([eventType intValue] == 0) {
         eventButton = [[UIButton alloc] initWithFrame:CGRectMake(40, start, (self.frame.size.width)/2-24, height)];
    }
    else if ([eventType intValue] == 1) {
        eventButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width)/2+21, start, (self.frame.size.width)/2-25, height)];
    }
   
    eventButton.tag =[eventType intValue]*1000 + [startNum intValue]/15;
    // 设置圆角半径
    eventButton.layer.masksToBounds = YES;
    eventButton.layer.cornerRadius = 1.0;
    
    eventButton.backgroundColor = [UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1.0];
    eventButton.layer.borderWidth = 0.5f;
    eventButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    [eventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    eventButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    
       //[eventButton setTitle:title forState:UIControlStateNormal];
    UILabel *labelInButton = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, eventButton.frame.size.width-20, eventButton.frame.size.height)];
    NSString *titleFinal = [NSString stringWithFormat:@"%@   \n",title];
    labelInButton.text = titleFinal;
    labelInButton.font = [UIFont systemFontOfSize:10.0];
    labelInButton.backgroundColor = [UIColor clearColor];
    labelInButton.textAlignment = NSTextAlignmentCenter;
    labelInButton.layer.borderColor = [UIColor clearColor].CGColor;

    [eventButton addSubview:labelInButton];
    
    UIImageView *imageInButton = [[UIImageView alloc] initWithFrame:CGRectMake(3, (eventButton.frame.size.height-8)/2, 8, 8)];
    [imageInButton setImage: [UIImage  imageNamed:@"色点.png"]];
    [eventButton addSubview:imageInButton];
    
    [eventButton addTarget:self action:@selector(eventModify:) forControlEvents:UIControlEventTouchUpInside];
    
   
    [self.viewToShare addSubview:eventButton];
   // [self addSubview:eventButton];
     //NSLog(@"redraw000");
   // [self setNeedsDisplay];
    
}

-(void)eventModify:(UIButton *)sender
{
    

    [self.modifyEvent_delegate modifyEvent:[[NSNumber alloc] initWithInteger:sender.tag]];
    
    
    
}


-(UIImage *)getContentImage
{
    
    
//    UIGraphicsBeginImageContext(self.viewToShare.frame.size);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.viewToShare.frame.size, NO, 2.0);
    else
        UIGraphicsBeginImageContext(self.viewToShare.frame.size);
    [self.viewToShare.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    //获取图像
//    [ self.viewToShare.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return image;
    
}


@end
