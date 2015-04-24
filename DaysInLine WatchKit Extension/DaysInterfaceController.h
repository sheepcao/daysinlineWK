//
//  DaysInterfaceController.h
//  DaysInLine
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DaysInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *datesTable;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *backGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *tableGroup;

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *cellGroup;
@end
