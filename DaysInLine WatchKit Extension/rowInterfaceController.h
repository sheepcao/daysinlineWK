//
//  rowInterfaceController.h
//  DaysInLine
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//
@import WatchKit;

#import <Foundation/Foundation.h>

@interface rowInterfaceController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rowTitle;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *statsNum;

@end
