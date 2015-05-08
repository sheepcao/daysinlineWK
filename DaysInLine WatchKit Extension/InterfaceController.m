//
//  InterfaceController.m
//  DaysInLine WatchKit Extension
//
//  Created by Eric Cao on 4/16/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "InterfaceController.h"
#import "FMDatabase.h"


@interface InterfaceController()
@property (nonatomic,strong) FMDatabase *db;

@end


@implementation InterfaceController
@synthesize db;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.backGroup setBackgroundImageNamed:@"backgroundWatch"];
//    [self.backGroup setBackgroundImage:nil];

    [self.dayLineBtn setBackgroundImageNamed:@"textWatch"];
//    [self.dayLineBtn setBackgroundImage:nil];

    [self.statsBtn setBackgroundImageNamed:@"textWatch"];

    [self initDB];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)checkDayLine {
    
    NSLog(@"hi");
    [self pushControllerWithName:@"MonthInterfaceController" context:nil];
    
    
}

- (IBAction)checkStats {
    NSLog(@"bye");
    [self pushControllerWithName:@"statsInterfaceController" context:nil];


}

-(NSString *)checkPriorDB
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        return databasePath;
    }
    else return nil;
    
}
-(void)initDB
{
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"infoNew.sqlite"];
    
    
    NSString *priorDB = [self checkPriorDB];
    
    if(priorDB)
    {
        NSError *error;
        
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:priorDB
                                                toPath:dbPath
                                                 error:&error];
        
        NSLog(@"copy Error description-%@ \n", [error localizedDescription]);
        NSLog(@"copy Error reason-%@", [error localizedFailureReason]);
        NSLog(@"copy success:%d",success);

        if (success) {
            
           BOOL success_delete =  [[NSFileManager defaultManager] removeItemAtPath:priorDB error:&error];
            NSLog(@"delete Error description-%@ \n", [error localizedDescription]);
            NSLog(@"delete Error reason-%@", [error localizedFailureReason]);
            
            NSLog(@"delete success:%d",success_delete);

        }
        
    }
    
    db = [FMDatabase databaseWithPath:dbPath];

    
    
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    //    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createDayable = @"CREATE TABLE IF NOT EXISTS DAYTABLE (DATE TEXT PRIMARY KEY,MOOD INTEGER,GROWTH INTEGER)";
    NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime REAL,endTime REAL,distance TEXT,label TEXT,remind TEXT,startArea INTEGER,photoDir TEXT)";
    //      NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";
    NSString *createTag = @"CREATE TABLE IF NOT EXISTS TAG (tagID INTEGER PRIMARY KEY AUTOINCREMENT,tagName TEXT UNIQUE)";
    
    NSString *createCollect = @"CREATE TABLE IF NOT EXISTS collection (collectionID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER)";
    
    NSString *createGlobal = @"CREATE TABLE IF NOT EXISTS globalVar (varName TEXT PRIMARY KEY,value INTEGER)";
    NSString *createPassword = @"CREATE TABLE IF NOT EXISTS passwordVar (varName TEXT PRIMARY KEY,value TEXT)";
    
    [db executeUpdate:createDayable];
    [db executeUpdate:createEvent];
    [db executeUpdate:createTag];
    [db executeUpdate:createCollect];
    [db executeUpdate:createGlobal];
    [db executeUpdate:createPassword];

    
    
    NSLog(@"db path11:%@",dbPath);
    
}

@end



