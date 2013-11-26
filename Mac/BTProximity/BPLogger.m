//
//  BPLogger.m
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "BPLogger.h"


NSDateFormatter *dateFormatter;
NSMutableArray *storage;

@implementation BPLogger

+ (void)log:(NSString*)text
{
    if(!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    
    if(!storage)
    {
        storage = [[NSMutableArray array] retain];
    }

    [storage addObject:text];
}

@end
