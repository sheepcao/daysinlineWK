//
//  dataBackupViewController.m
//  DaysInLine
//
//  Created by Eric Cao on 9/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "dataBackupViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "AFURLSessionManager.h"
#import "globalVars.h"

@interface dataBackupViewController ()<UIAlertViewDelegate>


@end

@implementation dataBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    [self.lastBackupInfo setText:self.backupinfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upload:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"backupImages"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级通告",nil) message:NSLocalizedString(@"免费版仅支持一次备份试用,请下载专业版开放备份功能",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"暂不",nil) otherButtonTitles:NSLocalizedString(@"去下载",nil), nil];
        alert.tag  = 888;
        [alert show];
        
    }else
    {
        if ([self.backupinfo isEqualToString:NSLocalizedString(@"尚未备份 ",nil)]) {
            [self uploadDB];
        }else
        {
            UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意",nil ) message:NSLocalizedString(@"即将以当前数据替换之前的备份数据",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
            confirmAlert.tag = 1;
            [confirmAlert show];
        }
        
    }
    
 }

- (IBAction)download:(id)sender {
    
    if ([self.backupinfo isEqualToString:NSLocalizedString(@"尚未备份 ",nil)])
    {
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意",nil ) message:NSLocalizedString(@"您还未进行过备份，无法同步到本地。",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
        confirmAlert.tag = 3;
        [confirmAlert show];
    }else
    {
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意",nil ) message:NSLocalizedString(@"云端备份数据将同步至本地，确认继续?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确认",nil), nil];
        confirmAlert.tag = 2;
        [confirmAlert show];
    }

}

-(void)uploadDB
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"infoNew.sqlite"];
    

    NSData *sqlData = [NSData dataWithContentsOfFile:dbPath];
    
   
    NSString * deviceName = [[UIDevice currentDevice] name];
    
    NSString * fileName = [NSString stringWithFormat:@"%@_infoNew.sqlite",self.username];

    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    hud.tag = 123;
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"uploadSQLs",@"name":self.username,@"backup_device":deviceName};
    
    
    

    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    [manager2 setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager2.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager2.requestSerializer setTimeoutInterval:120];  //Time out after 120 seconds
    
    
    
    [manager2 POST:backupURL  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (sqlData) {

            
            [formData appendPartWithFileData:sqlData name:@"file" fileName:fileName mimeType:@"text/plain"];
        }
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        NSString *backupInfo = [NSString stringWithFormat:@"%@ ,\n%@",[responseObject objectForKey:@"backup_device"], [self changeTimeZone:[responseObject objectForKey:@"backup_day"]]];
        
        [self.lastBackupInfo setText:backupInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"backupImages"];

   
        [self uploadRecords];
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Error";
        [hud hide:YES afterDelay:1.5];
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
        UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:NSLocalizedString(@"%@\n备份失败，请重试",nil),operation.responseString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [registerFailedAlert show];
        
        
    }];
    
    

}



-(void)uploadRecords
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    NSString *path;
    NSFileManager *fm;
    NSArray *dirArray;
    NSError *error;
    
    NSMutableArray *soundsArray = [[NSMutableArray alloc] init];
    NSMutableArray *soundsNameArray = [[NSMutableArray alloc] init];

    
    fm = [NSFileManager defaultManager];
    
    //获取当前的工作目录的路径
    path = [fm currentDirectoryPath];
    
    dirArray = [fm contentsOfDirectoryAtPath:docsPath error:&error];
    NSLog(@"path error:%@",error);
    
    for(path in dirArray)
    {
        if ([self myContainsStringFrom:path ForSting:@"message"]) {
            NSLog(@"path-------------%@",path);
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",docsPath,path];
            NSData *sqlData = [NSData dataWithContentsOfFile:fullPath];
            
            [soundsNameArray addObject:path];
            [soundsArray addObject:sqlData];

        }

    }
    
    
    NSDictionary *parameters = @{@"tag": @"uploadSounds",@"name":self.username,@"soundCount":[NSString stringWithFormat:@"%d",soundsArray.count]};




    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:backupURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0;i<soundsNameArray.count;i++)
        {
            NSData *eachSound = soundsArray[i];
            NSString *soundName = soundsNameArray[i];
            NSString *soundOnServer = [NSString stringWithFormat:@"%@_%@",self.username,soundName];
            
            [formData appendPartWithFileData:eachSound name:[NSString stringWithFormat:@"file%d",i] fileName:soundOnServer mimeType:@"audio/x-caf"];
        }
    } error:&error];
    request.timeoutInterval = 120;
    
    NSLog(@"upload sounds error:%@",error);
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"----===%@ %@", response, responseObject);
            
            

        }
        MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:123];
        if(hud)
        {
            hud.mode = MBProgressHUDModeText;

            hud.labelText = NSLocalizedString(@"成功备份",nil);
            [hud hide:YES afterDelay:1.2];
        }
    }];
    
    
    [uploadTask resume];
    

    
    
    
}

//
//-(void)uploadImages
//{
//    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
//    NSString *docsPath = [storeURL path];
//    
//    NSString *path;
//    NSFileManager *fm;
//    NSArray *dirArray;
//    NSError *error;
//    
//    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
//    NSMutableArray *imgNameArray = [[NSMutableArray alloc] init];
//    
//    
//    fm = [NSFileManager defaultManager];
//    
//    //获取当前的工作目录的路径
//    path = [fm currentDirectoryPath];
//    
//    dirArray = [fm contentsOfDirectoryAtPath:docsPath error:&error];
//    NSLog(@"path error:%@",error);
//    
//    for(path in dirArray)
//    {
//        if ([self myContainsStringFrom:path ForSting:@".png"] && path.length>18) {
//            NSLog(@"path-------------%@",path);
//            
//            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",docsPath,path];
//            NSData *sqlData = [NSData dataWithContentsOfFile:fullPath];
//            
//            [imgNameArray addObject:path];
//            [imgArray addObject:sqlData];
//            
//        }
//        
//    }
//    
//    
//    NSDictionary *parameters = @{@"tag": @"uploadImages",@"name":self.username,@"imageCount":[NSString stringWithFormat:@"%d",imgArray.count]};
//    
//    
//    
//    
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://localhost/~ericcao/uploads.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for(int i = 0;i<imgNameArray.count;i++)
//        {
//            NSData *eachImg = imgArray[i];
//            NSString *imgName = imgNameArray[i];
//            NSString *imgOnServer = [NSString stringWithFormat:@"%@_%@",self.username,imgName];
//            
//            [formData appendPartWithFileData:eachImg name:[NSString stringWithFormat:@"file%d",i] fileName:imgOnServer mimeType:@"image/png"];
//        }
//    } error:&error];
//    request.timeoutInterval = 180;
//    
//    NSLog(@"upload images error:%@",error);
//    
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"----===%@ %@", response, responseObject);
//            
//            
//            
//        }
//        MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:123];
//        if(hud)
//        {
//            hud.labelText = @"成功备份";
//            [hud hide:YES afterDelay:1.2];
//        }
//    }];
//    
//    
//    [uploadTask resume];
//    
//    
//    
//    
//    
//}






-(void)downloadURLFromServer
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Downloading";
    hud.tag = 456;
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"download",@"name":self.username};
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:120];  //Time out after 25 seconds
    
    
    [manager POST:backupURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSMutableArray *fullURLArray = [[NSMutableArray alloc] init];
        NSArray * URLArray = [responseObject objectForKey:@"files"];
        for (int i = 0; i <URLArray.count; i++) {
            NSString *oneURL = [NSString stringWithFormat:@"%@%@",backupPath,[responseObject objectForKey:@"files"][i]];
            [fullURLArray addObject:oneURL];
        }
        
        NSLog(@"URL URLArray: %@", fullURLArray);
        
        [self downloadFromURLs:fullURLArray];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeText;

        hud.labelText = NSLocalizedString(@"同步失败，请稍后重试",nil);
        
        [hud hide:YES afterDelay:1.5];

        
    }];
}

-(void)downloadFromURLs:(NSMutableArray *)urlArray
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [self downloadMulti:urlArray withManager:manager];

}

-(void)downloadMulti:(NSMutableArray *)urlArray withManager:(AFURLSessionManager *)manager
{
    
    if (urlArray.count == 0) {
        MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:456];
        if(hud)
        {
            hud.mode = MBProgressHUDModeText;

            hud.labelText = NSLocalizedString(@"成功同步到本机",nil);
            [hud hide:YES afterDelay:1.2];
            

        }
        return;
    }else
    {
        NSError *error;
        
        NSData *dbFile = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlArray[0]]];
        

         NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
        NSString *dirString = [documentsDirectoryURL path];
        
        NSString *fileName = [urlArray[0] componentsSeparatedByString:@"_"].lastObject;
        
        NSString *destPath = [NSString stringWithFormat:@"%@/%@",dirString,fileName];
        
        NSFileManager *fileManager =[NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:destPath] == YES)
        {
            
            [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
            NSLog(@"Error description-%@ \n", [error localizedDescription]);
            NSLog(@"Error reason-%@", [error localizedFailureReason]);
            
        }
        

        
        BOOL success = [dbFile writeToFile:destPath options:NSDataWritingAtomic error:&error];
        
        NSLog(@"destPath:%@ and %d for error:%@",destPath ,success,error);
        
        [urlArray removeObjectAtIndex:0];
        [self downloadMulti:urlArray withManager:manager];
    }

   
}



- (BOOL)myContainsStringFrom:(NSString*)str ForSting:(NSString*)other {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 888)
    {
        if (buttonIndex ==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:proAPP_URL]];
            
        }
    }else if(alertView.tag == 1)
    {
        if (buttonIndex ==1)
        {
            [self uploadDB];
        }
    }else if (alertView.tag == 2)
    {
        if (buttonIndex ==1)
        {
            [self downloadURLFromServer];
        }
    }
    
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

@end
