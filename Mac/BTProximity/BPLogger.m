//
//  BPLogger.m
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "BPLogger.h"


NSDateFormatter *dateFormatter;

@implementation BPLogger

+ (void)log:(NSString*)text
{
    if(!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
}

@end
