//
//  statsInterfaceController.m
//  DaysInLine
//
//  Created by Eric Cao on 4/21/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "statsInterfaceController.h"
#import "rowInterfaceController.h"
#import "FMDatabase.h"

@interface statsInterfaceController ()
@property (nonatomic,strong) FMDatabase *db;

@property (nonatomic,strong) NSArray *statsItems;
@property (nonatomic,strong) NSMutableArray *statsNums;

@end

@implementation statsInterfaceController
@synthesize db;

double incomeAll;
double expendAll;
double moodAverage;
double growthAverage;
double work_life[2];
double workOfAll ;
double lifeOfAll ;

double moodOfAll;
double growthOfAll;
double incomeOfAll;
double expendOfAll;


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
     workOfAll=0 ;
     lifeOfAll=0 ;
    
     moodOfAll=0;
     growthOfAll=0;
     incomeOfAll=0;
     expendOfAll=0;
    
     incomeAll=0;
     expendAll=0;
     moodAverage=0;
     growthAverage=0;
     work_life[0] =0;
     work_life[1] =0;

     workOfAll=0 ;
     lifeOfAll=0 ;
    
    self.statsNums = [[NSMutableArray alloc] init];
    self.statsItems = @[NSLocalizedString(@"工作",nil),NSLocalizedString(@"生活",nil),NSLocalizedString(@"心情",nil),NSLocalizedString(@"成长",nil),NSLocalizedString(@"收入",nil),NSLocalizedString(@"支出",nil)];
    // Configure interface objects here.
    
    [self caculateRates];
    
    [self loadTableRows];

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)loadTableRows {
    
    
    [self.statsTable setNumberOfRows:self.statsItems.count withRowType:@"defaultRow"];
    
    
    // Create all of the table rows.
    for (int i = 0; i<self.statsItems.count; i++) {
        
        
        rowInterfaceController *elementRow = [self.statsTable rowControllerAtIndex:i];

        [elementRow.rowTitle setText:self.statsItems[i]];

        [elementRow.statsNum setText:self.statsNums[i]];
        
        if (i == 0) {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:97/255.0f green:197/255.0f blue:185/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:97/255.0f green:197/255.0f blue:185/255.0f alpha:1.0f]];
        }else if (i==1)
        {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:246/255.0f green:235/255.0f blue:127/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:246/255.0f green:235/255.0f blue:127/255.0f alpha:1.0f]];
        }else if (i == 2)
        {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:241/255.0f green:99/255.0f blue:105/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:241/255.0f green:99/255.0f blue:105/255.0f alpha:1.0f]];
        }else if (i == 3)
        {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:59/255.0f green:170/255.0f blue:217/255.0f alpha:1.0f]];
        }else if (i == 4)
        {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:151/255.0f green:204/255.0f blue:114/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:151/255.0f green:204/255.0f blue:114/255.0f alpha:1.0f]];
        }else if (i == 5)
        {
            [elementRow.rowTitle setTextColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:64/255.0f alpha:1.0f]];
            [elementRow.statsNum setTextColor:[UIColor colorWithRed:251/255.0f green:176/255.0f blue:64/255.0f alpha:1.0f]];
        }
        
        
        

    }
}




-(void)caculateRates
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"infoNew.sqlite"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    int days = 0;
    FMResultSet *rs = [db executeQuery:@"SELECT type,income,expend,startTime,endTime from event"];
    while ([rs next]) {
        
        
        int evtType = [rs intForColumn:@"type"];
        double income = [rs doubleForColumn:@"income"];
        double expend = [rs doubleForColumn:@"expend"];
        double startTm = [rs doubleForColumn:@"startTime"];
        double endTm = [rs doubleForColumn:@"endTime"];
        
        incomeAll+=income;
        expendAll+=expend;
        work_life[evtType]+=(endTm-startTm);
        
        
        
        
    }

    FMResultSet *rs1 = [db executeQuery:@"SELECT MOOD,GROWTH from DAYTABLE"];
    while ([rs1 next]) {
        
        
        int mood = [rs1 intForColumn:@"MOOD"];
        int growth = [rs1 intForColumn:@"GROWTH"];
        
        
        moodAverage+=mood;
        growthAverage+=growth;
        days++;
    
        
    }
    [db close];

    if (days > 0)
    {
        

        if ((work_life[1]+work_life[0])>0.001) {
            
            workOfAll =work_life[0]/(work_life[1]+work_life[0]);
            lifeOfAll =work_life[1]/(work_life[1]+work_life[0]);
            
        }
        
            moodOfAll = moodAverage/(days*5);
            growthOfAll = growthAverage/(days*5);
    

        if ((incomeAll+expendAll)>0.001) {
            incomeOfAll = incomeAll/(incomeAll+expendAll);
            expendOfAll = expendAll/(incomeAll+expendAll);
        }

        

    }
    
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f%%",workOfAll*100]];
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f%%",lifeOfAll*100]];
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f%%",moodOfAll*100]];
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f%%",growthOfAll*100]];
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f",incomeAll]];
    [self.statsNums addObject:[NSString stringWithFormat:@"%.0f",expendAll]];


    
        
    
    NSLog(@"{%.2f,%.2f,%.2f,%.2f}",incomeAll,expendAll,work_life[0],work_life[1]);
    NSLog(@"{-----%.2f,%.2f-----}",moodAverage,growthAverage);
        
        
        
    
}

@end



