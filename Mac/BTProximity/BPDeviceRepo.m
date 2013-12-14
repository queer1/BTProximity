//
//  BPDeviceRepo.m
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPDeviceRepo.h"

#define kDevices        @"Devices"
#define kIdleRSSI       @"IdleRSSI"
#define kThresholdRSSI  @"ThresholdRSSI"

@implementation BPDeviceRepo

+ (NSMutableDictionary*)devices
{
    NSMutableDictionary *devices = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kDevices] mutableCopy];
    if(!devices)
    {
        devices = [NSMutableDictionary dictionary];
        [BPDeviceRepo saveDevices:devices];
    }
    return devices;
}

+ (void)saveDevices:(NSMutableDictionary*)devices
{
    [[NSUserDefaults standardUserDefaults] setObject:devices forKey:kDevices];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)deviceExists:(NSString*)deviceAddress
{
    return ([[BPDeviceRepo devices] objectForKey:deviceAddress] != nil);
}

+ (void)setIdleRSSI:(int)RSSI forDevice:(NSString*)deviceAddress
{
    NSMutableDictionary *devices = [BPDeviceRepo devices];
    NSMutableDictionary *deviceDict = [[devices objectForKey:deviceAddress] mutableCopy];
    if(!deviceDict)
    {
        deviceDict = [NSMutableDictionary dictionary];
    }
    [deviceDict setObject:[NSNumber numberWithInt:RSSI] forKey:kIdleRSSI];
    [devices setObject:deviceDict forKey:deviceAddress];
    [BPDeviceRepo saveDevices:devices];
}

+ (void)setThresholdRSSI:(int)RSSI forDevice:(NSString*)deviceAddress
{
    NSMutableDictionary *devices = [BPDeviceRepo devices];
    NSMutableDictionary *deviceDict = [[devices objectForKey:deviceAddress] mutableCopy];
    if(!deviceDict)
    {
        deviceDict = [NSMutableDictionary dictionary];
    }
    [deviceDict setObject:[NSNumber numberWithInt:RSSI] forKey:kThresholdRSSI];
    [devices setObject:deviceDict forKey:deviceAddress];
    [BPDeviceRepo saveDevices:devices];
}

+ (int)getIdleRSSIForDevice:(NSString*)deviceAddress
{
    NSMutableDictionary *devices = [BPDeviceRepo devices];
    if([devices objectForKey:deviceAddress])
    {
        return [[[devices objectForKey:deviceAddress] objectForKey:kIdleRSSI] intValue];
    }
    return 0;
}

+ (int)getThresholdRSSIForDevice:(NSString*)deviceAddress
{
    NSMutableDictionary *devices = [BPDeviceRepo devices];
    if([devices objectForKey:deviceAddress])
    {
        return [[[devices objectForKey:deviceAddress] objectForKey:kThresholdRSSI] intValue];
    }
    return 0;
}

@end
