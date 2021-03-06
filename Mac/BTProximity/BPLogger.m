//
//  BPLogger.m
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
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

    NSString *formattedText = [NSString stringWithFormat:@"%@: %@", [dateFormatter stringFromDate:[NSDate date]], text];
    [storage addObject:formattedText];
}

+ (NSString*)getStorage
{
    return [storage componentsJoinedByString:@"\n"];
}

@end
