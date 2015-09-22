//
//  backupViewController.h
//  DaysInLine
//
//  Created by Eric Cao on 9/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface backupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIView *loginPart;
@property (strong, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginTap:(id)sender;



@property (weak, nonatomic) IBOutlet UITextField *registerUsernameField;

@property (weak, nonatomic) IBOutlet UITextField *registerPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordConfirmField;

@property (weak, nonatomic) IBOutlet UIButton *submitRegisterBtn;

- (IBAction)registerSubmit:(id)sender;

- (IBAction)backTap:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *changePageBtn;
- (IBAction)changePageTap:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *registerBack;

@property (weak, nonatomic) IBOutlet UIImageView *loginBack;
- (IBAction)agreementTap:(id)sender;
@end
