//
//  MonthInterfaceController.h
//  DaysInLine
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MonthInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *monthTable;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *backGroup;

@end
