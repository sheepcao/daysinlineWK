//
//  allEventsViewController.m
//  DaysInLine
//
//  Created by Eric Cao on 5/11/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "allEventsViewController.h"
#import "FMDatabase.h"

@interface allEventsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) FMDatabase *db;

@property (nonatomic,strong) NSMutableArray *IDArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *textArray;
@property (nonatomic,strong) NSMutableArray *dateArray;

@end

@implementation allEventsViewController
@synthesize db;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.dateRangeLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@ 到 %@",nil),self.startDate,self.endDate]];
    
    
    [self.backBtn setTitle:NSLocalizedString(@"返回",nil) forState:UIControlStateNormal];
    
    
    self.eventsTable.delegate = self;
    self.eventsTable.dataSource = self;
    
    self.IDArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.textArray = [[NSMutableArray alloc] init];
    self.dateArray = [[NSMutableArray alloc] init];


    
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"infoNew.sqlite"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }

    
    FMResultSet *rs = [db executeQuery:@"SELECT eventID,TITLE,mainText,date from EVENT where date >= ? AND date <= ?",self.startDate,self.endDate];
    while ([rs next]) {
        
        NSNumber *eventID =[NSNumber numberWithInt:[rs intForColumn:@"eventID"]];

        
        NSString *title = [rs stringForColumn:@"TITLE"];
        NSString *mainText = [rs stringForColumn:@"mainText"];

        NSString *date = [rs stringForColumn:@"date"];
        
        [self.IDArray addObject:eventID];
        [self.titleArray addObject:title];
        [self.textArray addObject:mainText];
        [self.dateArray addObject:date];
        
    }
    
    [db close];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.IDArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allEvents"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"allEvents"];
    }
    NSUInteger row=[indexPath row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.backgroundColor = [UIColor clearColor];
    //设置文本

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width/2-10, 25)];
    [titleLabel setText:self.titleArray[row]];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [cell addSubview:titleLabel];
    
    
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height, tableView.frame.size.width/2-10, 20)];
    [dateLabel setText:self.dateArray[row]];
    dateLabel.numberOfLines = 1;

    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:13.0f];
    [dateLabel setTextColor:[UIColor grayColor]];

    [cell addSubview:dateLabel];
    
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2+5, titleLabel.frame.origin.y, tableView.frame.size.width/2-10, 45)];
    if ([self.textArray[row] isEqualToString:NSLocalizedString(@"点击输入......",nil)]) {
        [textLabel setText:@""];
    }else
    {
        [textLabel setText:self.textArray[row]];
    }
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = [UIFont systemFontOfSize:16.0f];

    [cell addSubview:textLabel];
    

    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)back:(id)sender {
   
    
    if (soundSwitch) {
        
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_dlt;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_dlt);
        AudioServicesPlaySystemSound(soundObject_dlt);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
