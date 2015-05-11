//
//  allEventsViewController.h
//  DaysInLine
//
//  Created by Eric Cao on 5/11/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVars.h"
#import <AudioToolbox/AudioToolbox.h>

@interface allEventsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
- (IBAction)back:(id)sender;
@end
