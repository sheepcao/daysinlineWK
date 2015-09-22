//
//  dataBackupViewController.h
//  DaysInLine
//
//  Created by Eric Cao on 9/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dataBackupViewController : UIViewController

@property (nonatomic, strong) NSString *backupinfo;
@property (nonatomic, strong) NSString *username;

@property (weak, nonatomic) IBOutlet UILabel *lastBackupInfo;

- (IBAction)back:(id)sender;


- (IBAction)upload:(id)sender;
- (IBAction)download:(id)sender;

@end
