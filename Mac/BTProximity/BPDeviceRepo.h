//
//  BPDeviceRepo.h
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPDeviceRepo : NSObject

+ (BOOL)deviceExists:(NSString*)deviceAddress;
+ (void)setIdleRSSI:(int)RSSI forDevice:(NSString*)deviceAddress;
+ (void)setThresholdRSSI:(int)RSSI forDevice:(NSString*)deviceAddress;
+ (int)getIdleRSSIForDevice:(NSString*)deviceAddress;
+ (int)getThresholdRSSIForDevice:(NSString*)deviceAddress;

@end
