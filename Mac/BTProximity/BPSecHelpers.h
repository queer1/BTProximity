//
//  BPSecHelpers.h
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPSecHelpers : NSObject

+ (void)lock;
+ (void)unlock;

+ (void)setPassword:(NSString*)password;
+ (NSString*)getPassword;

@end
