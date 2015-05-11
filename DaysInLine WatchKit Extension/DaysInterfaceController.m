//
//  DaysInterfaceController.m
//  DaysInLine
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "DaysInterfaceController.h"
#import "FMDatabase.h"
#import "rowInterfaceController.h"

@interface DaysInterfaceController ()
{
    int currentMon;
}
@property (nonatomic,strong) FMDatabase *db;

@property (nonatomic,strong) NSMutableArray *allDates;
@property (nonatomic,strong) NSMutableArray *datesInMonth;
@property (nonatomic ,strong) NSArray *MonthArray;

@end

@implementation DaysInterfaceController
@synthesize db;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self.backGroup setBackgroundImageNamed:@"backgroundWatch"];

    self.MonthArray =@[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];

    currentMon = [context intValue];

    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        [self setTitle:[NSString stringWithFormat:@"%@月",context]];
    }else
    {
        [self setTitle:self.MonthArray[currentMon-1]];
    }

    [self loadDB];
    [self pickDatesOnThisMonth];
    [self loadTableRows];

    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    [self pushControllerWithName:@"dayLineInterfaceController" context:self.datesInMonth[rowIndex]];
}

- (void)loadTableRows {
    
    [self.datesTable setNumberOfRows:self.datesInMonth.count withRowType:@"defaultRow"];
    
    [self.tableGroup setHeight:(37+3)*self.datesInMonth.count];
    [self.backGroup setHeight:(37+3)*self.datesInMonth.count + 40];
    
    if (self.datesInMonth.count<4) {
        [self.tableGroup setHeight:130];
        [self.backGroup setHeight:150];
    }

    
    // Create all of the table rows.
    for (int i = 0; i<self.datesInMonth.count ; i++) {
        
        
        rowInterfaceController *elementRow = [self.datesTable rowControllerAtIndex:i];
        
        [elementRow.rowTitle setText:self.datesInMonth[i]];
        [elementRow.rowBackGroup setBackgroundImageNamed:@"textWatch"];

    }
}





-(void)loadDB
{
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"infoNew.sqlite"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    
    self.allDates = [[NSMutableArray alloc] init];
    self.datesInMonth = [[NSMutableArray alloc] init];

    
    FMResultSet *rs = [db executeQuery:@"SELECT DATE from DAYTABLE"];
    while ([rs next]) {
        
        
        
        NSString *date = [rs stringForColumn:@"DATE"];
        
        FMResultSet *rs1 = [db executeQuery:@"SELECT * from EVENT where date = ?",date];
        
        if ( [rs1 next])
        {
            [self.allDates addObject:date];

        }

        
      
        
    }
    
    [db close];
}

-(void)pickDatesOnThisMonth
{

    for (NSString *date in self.allDates) {

        NSArray *datas = [date componentsSeparatedByString:@"-"];
        if (datas.count>2) {
          
            if ([datas[1] intValue] == currentMon) {
                [self.datesInMonth addObject:date];
            }
            
        }
    }
    
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
@end



