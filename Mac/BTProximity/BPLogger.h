//
//  BPLogger.h
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPLogger : NSObject

+ (void)log:(NSString*)text;
+ (NSString*)getStorage;

@end
