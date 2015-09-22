//
//  backupViewController.m
//  DaysInLine
//
//  Created by Eric Cao on 9/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "backupViewController.h"
#import "globalVars.h"
#import "dataBackupViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "userAgreementViewController.h"

@interface backupViewController ()

@end

@implementation backupViewController


bool emailOK;
bool nameOK;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    emailOK = YES;
    nameOK = NO;
    
    // Do any additional setup after loading the view from its nib.
    self.registerBack.layer.cornerRadius = 7.5;
    self.registerBack.layer.masksToBounds = YES;
    
    self.loginBack.layer.cornerRadius = 7.5;
    self.loginBack.layer.masksToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 15.0f;
    self.submitRegisterBtn.layer.cornerRadius = 15.0f;
    [self disableSubmitBtn];
    [self disableLoginBtn];
    

//    
    [self.midView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+30)];
    [self.view addSubview:self.midView];
    
    [self.loginPart setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2-50)];
    [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2-50)];
    
    
    [self.midView addSubview:self.loginPart];
//    [self.midView addSubview:self.registerView];

    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enableSubmitBtn
{
    [self.submitRegisterBtn setEnabled:YES];
    [self.submitRegisterBtn setBackgroundColor:[UIColor colorWithRed:230/255.0f green:196/255.0f blue:19/255.0f alpha:1.0]];
    
}
-(void)disableSubmitBtn
{
    [self.submitRegisterBtn setEnabled:NO];
    [self.submitRegisterBtn setBackgroundColor:[UIColor colorWithRed:239/255.0f green:227/255.0f blue:198/255.0f alpha:1.0]];
    
}


-(void)enableLoginBtn
{
    [self.loginBtn setEnabled:YES];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:230/255.0f green:196/255.0f blue:19/255.0f alpha:1.0]];
    
}
-(void)disableLoginBtn
{
    [self.loginBtn setEnabled:NO];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:239/255.0f green:227/255.0f blue:198/255.0f alpha:1.0]];
    
}

- (IBAction)loginTap:(id)sender {
    
    [self.view endEditing:YES];// this will do the trick
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Sending";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"login",@"name":self.loginUsernameField.text,@"password":self.loginPasswordField.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
    
    
    [manager POST:backupURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"登录成功",nil);
        
        
        [hud hide:YES afterDelay:1.0];
        [self performSelector:@selector(successLogin:) withObject:responseObject afterDelay:1.01];
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Error";
        [hud hide:YES afterDelay:1.5];
        
        
        if ([operation.responseString isEqualToString: @"Incorrect username or password"]) {
            
            UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"您输入的用户名或密码有误，请重新输入",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [userNameAlert show];
        }else
        {
            UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"登录失败，请重试",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [registerFailedAlert show];
        }
        
        
        
    }];
    
}


-(void)successLogin:(NSDictionary *)userInfoDic
{
    
    NSLog(@"userInfoDic:%@",userInfoDic);
    
    NSString *backupDevice = [userInfoDic objectForKey:@"backup_device"];
    
    NSString *backupTime = [userInfoDic objectForKey:@"backup_day"];
    NSString *backupUser = [userInfoDic objectForKey:@"username"];
    
    
    NSString *backupInfo;
    if ([backupDevice isKindOfClass:[NSNull class]] || [backupDevice isEqualToString:@"null"] ||!backupDevice) {
        
        backupInfo = NSLocalizedString(@"尚未备份 ",nil);

    }else
    {
        
        backupTime = [self changeTimeZone:backupTime];
        
        backupInfo = [NSString stringWithFormat:@"%@\n%@",backupDevice,backupTime];

    }

    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    dataBackupViewController *dataBackup = [[dataBackupViewController alloc] initWithNibName:@"dataBackupViewController" bundle:nil];
    dataBackup.backupinfo = backupInfo;
    dataBackup.username = backupUser;
    
    [self presentViewController:dataBackup animated:YES completion:nil];
    
}

-(NSString *)changeTimeZone:(NSString *)time
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"%@",timeZone);
    
    NSString * zone = [NSString stringWithFormat:@"%@",timeZone];
    NSLog(@"zone:%@",zone);
    NSArray *tempArray = [zone componentsSeparatedByString:@"GMT"];
    if (tempArray.count>1) {
        NSArray *temp = [tempArray[1] componentsSeparatedByString:@")"];
        if (temp.count>1) {
            NSString *zoneNum = temp[0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:time];
            int hours = [zoneNum intValue];

            
            NSDate *newDate1 = [dateFromString dateByAddingTimeInterval:60*60*hours];
            NSString *stringDate = [dateFormatter stringFromDate:newDate1];

            
            time = stringDate;
            
        }
    }
    return time;
    

}


- (IBAction)registerSubmit:(id)sender {
    
    
    [self.view endEditing:YES];// this will do the trick
    
    
    if (![self validateInfos]) {
        return;
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Uploading";
        hud.dimBackground = YES;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        NSDictionary *parameters = @{@"tag": @"register",@"name":self.registerUsernameField.text,@"password":self.registerPasswordField.text};
        
        
        //upload head image

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
        
        [manager POST:backupURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Completed";
            [hud hide:YES afterDelay:1.0];
            
            [self performSelector:@selector(successLogin:) withObject:responseObject afterDelay:1.01];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Error";
            [hud hide:YES afterDelay:1.5];
            
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            if ([self myContainsStringFrom:operation.responseString ForSting:@"User already existed"]) {
                UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"您输入的用户名已存在，换一个吧",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
                [userNameAlert show];
            }else
            {
                UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"注册失败，请重试",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
                [registerFailedAlert show];
            }
            
        }];

        
    }
    
    
}



- (BOOL)myContainsStringFrom:(NSString*)str ForSting:(NSString*)other {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}



- (IBAction)backTap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changePageTap:(UIButton *)sender {
    
    NSLog(@"title:%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"前往注册",nil)]) {
        
        
        
        [UIView transitionFromView:self.loginPart
                            toView:self.registerView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                               
                               [sender setTitle:NSLocalizedString(@"前往登录",nil) forState:UIControlStateNormal];
                               
                               /* do something on animation completion */
                           }];
        //        [self.loginPart setHidden:YES];
        //        [self.registerView setHidden:NO];
        NSLog(@"registerView:%@",self.registerView);
        NSLog(@"fatherView:%@",[self.registerView superview]);
        
        
        
    }else
    {
        
        [UIView transitionFromView:self.registerView
                            toView:self.loginPart
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                               
                               [sender setTitle:NSLocalizedString(@"前往注册",nil) forState:UIControlStateNormal];
                               
                               /* do something on animation completion */
                           }];
        
        NSLog(@"loginPart:%@",self.loginPart);
    }

}


-(BOOL)validateInfos
{
   
    if (![self.registerPasswordField.text isEqualToString:self.registerPasswordConfirmField.text])
    {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"两次输入密码不一致!",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
        [passwordAlert show];
        return false;
    }else if (!emailOK)
    {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的email格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [emailAlert show];
        
        return false;
    }else if (!nameOK)
    {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"用户名只接受汉字、字母和数字",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
        [emailAlert show];
        
        return false;
    }
    return true;
    
}



-(void)judgeWordCount:(UITextField *)textField
{
    if (textField.tag ==100) {
        
        if ([self validateName:textField.text]) {
            nameOK = YES;
        }else
        {
            nameOK = NO;
            if (![textField.text isEqualToString:@""]) {
                UIAlertView *nameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"用户名只接受汉字、字母和数字",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
                [nameAlert show];
                textField.text = @"";
            }
            
        }
        
        
        
        CGSize textSize = [textField.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0] }];
        if (textSize.width>=textField.frame.size.width) {
            textField.text = @"";
            NSLog(@"too many words");
            UIAlertView *wordMaxAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误",nil) message:NSLocalizedString(@"您的用户名太长了...",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [wordMaxAlert show];
        }
    }else if (textField.tag == 200 )
    {
        
        if ([self validateEmail:textField.text]) {
            emailOK = YES;
        }else
        {
            emailOK = NO;
            if (![textField.text isEqualToString:@""]) {
                UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的email格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [emailAlert show];
            }
            
        }
    }
    
    
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (BOOL) validateName: (NSString *) candidate {
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:candidate];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == self.registerPasswordField || textField == self.registerPasswordConfirmField) {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2 - 60)];
        }];
    }else
    {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2-50)];
        }];
    }
    
    
    
    
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    [self judgeWordCount:textField];
    [self isInfoComplete];
    
    
    if (textField == self.registerPasswordConfirmField ) {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2-50)];
        }];
    }
    
    
}

-(void)isInfoComplete
{
    if (![self.registerUsernameField.text isEqualToString:@""] && ![self.registerPasswordField.text  isEqualToString:@""] && ![self.registerPasswordConfirmField.text  isEqualToString:@"" ]) {
        
        [self enableSubmitBtn];
    }else
    {
        [self disableSubmitBtn];
    }
    
    if (![self.loginUsernameField.text isEqualToString:@""] && ![self.loginPasswordField.text isEqualToString:@""]) {
        
        [self enableLoginBtn];
    }else
    {
        [self disableLoginBtn];
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}





-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}
- (IBAction)agreementTap:(id)sender {
    
    userAgreementViewController *userAgree = [[userAgreementViewController alloc] initWithNibName:@"userAgreementViewController" bundle:nil];
    [self presentViewController:userAgree animated:YES completion:nil];
    
}
@end
