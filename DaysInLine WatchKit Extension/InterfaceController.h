//
//  InterfaceController.h
//  DaysInLine WatchKit Extension
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *backGroup;
- (IBAction)checkDayLine;

- (IBAction)checkStats;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *dayLineBtn;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *statsBtn;

@end
