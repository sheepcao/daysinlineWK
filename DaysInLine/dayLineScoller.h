//
//  dayLineScoller.h
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redrawButtonDelegate.h"
#import "shareView.h"
#import "globalVars.h"



@class buttonInScroll;



@interface dayLineScoller : UIScrollView<redrawButtonDelegate>



@property (nonatomic,strong) buttonInScroll *btnInScroll;
@property (nonatomic,strong) shareView *viewToShare;

@property (weak, nonatomic) NSObject <redrawButtonDelegate> *modifyEvent_delegate;

-(UIImage *)getContentImage;
@end
