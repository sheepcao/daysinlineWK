//
//  dayLineInterfaceController.m
//  DaysInLine
//
//  Created by Eric Cao on 4/20/15.
//  Copyright (c) 2015 cao yang. All rights reserved.
//

#import "dayLineInterfaceController.h"

@interface dayLineInterfaceController ()

@end

@implementation dayLineInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSLog(@"day:%@",context);
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    NSString *myImageName = [NSString stringWithFormat:@"%@@2x.png",context];

    
    NSString *imagePath = [docsPath stringByAppendingPathComponent:myImageName];
    
    
    NSLog(@"image path:%@",imagePath);
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    
    if([fileManager fileExistsAtPath:imagePath] == YES)
    {
        
        
        NSLog(@"image path yes");
        
    }else
    {
        NSLog(@"no image!!!! ");
    }

    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    UIImage *dayViewImage = [UIImage imageWithData:imageData];
    
    
    [self.dayImage setImage:dayViewImage];
    
    
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

@end



