//
//  BPTracker.m
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPTracker.h"


@interface BPTracker ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BPTracker

+ (BPTracker*)sharedTracker
{
    static BPTracker *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BPTracker alloc] init];
        sharedInstance.inRangeThreshold = -70;
    });
    return sharedInstance;
}

- (void)startMonitoring
{
    _isMonitoring = YES;

    [BPLogger log:@"starting..."];
    [[BPSmootheningFilter sharedInstance] reset];
    [self updateRSSI];
    [BPLogger log:@"started"];

    self.deviceInRange = YES;
    self.initialRSSI = MAXFLOAT;

    __block typeof(self) weakSelf = self;
    void (^__block updateStatusBlock)(void) = [^(void){
        if(weakSelf.currentRSSI > weakSelf.inRangeThreshold)
        {
            if(!weakSelf.deviceInRange)
            {
                weakSelf.deviceInRange = YES;

                if(weakSelf.rangeStatusUpdateBlock)
                {
                    weakSelf.rangeStatusUpdateBlock(weakSelf);
                }
            }
        }else
        {
            if(weakSelf.deviceInRange)
            {
                weakSelf.deviceInRange = NO;

                if(weakSelf.rangeStatusUpdateBlock)
                {
                    weakSelf.rangeStatusUpdateBlock(weakSelf);
                }
            }
        }

        if(weakSelf.isMonitoring)
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), updateStatusBlock);
        }else
        {
            [updateStatusBlock release];
        }
    } copy];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), updateStatusBlock);
}

- (void)stopMonitoring
{
    _isMonitoring = NO;

    [BPLogger log:@"stopping..."];
    [self.device closeConnection];
    [BPLogger log:@"stopped"];

    [self.timer invalidate];
    self.timer = nil;
}

- (void)selectDevice
{
    IOBluetoothDeviceSelectorController *deviceSelector = [IOBluetoothDeviceSelectorController deviceSelector];
    [deviceSelector runModal];

    NSArray *results = [deviceSelector getResults];

    if(results)
    {
        self.device = [results objectAtIndex:0];
        [BPLogger log:[NSString stringWithFormat:@"selected %@ (%@)", self.device.name, self.device.addressString]];
    }
}

- (void)updateRSSI
{
    __block typeof(self) weakSelf = self;
    void (^__block updateRSSIBlock)(void) = [^(void){
        if(weakSelf.device)
        {
            BOOL reconnected = NO;

            if(![weakSelf.device isConnected])
            {
                reconnected = ([weakSelf.device openConnection] == kIOReturnSuccess);
            }

            if([weakSelf.device isConnected])
            {
                BluetoothHCIRSSIValue rawRSSI = [weakSelf.device rawRSSI];
                if(reconnected)
                {
                    [[BPSmootheningFilter sharedInstance] reset];
                }

                [[BPSmootheningFilter sharedInstance] addSample:rawRSSI];
                weakSelf.currentRSSI = [[BPSmootheningFilter sharedInstance] getMedianValue];
            }else
            {
                weakSelf.currentRSSI = -127;
                [BPLogger log:@"[!] couldn't connect. will attempt to reconnect on next tick."];
            }

            if(reconnected)
            {
                weakSelf.initialRSSI = weakSelf.currentRSSI;
            }
        }
        
        if(weakSelf.isMonitoring)
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), updateRSSIBlock);
        }else
        {
            [updateRSSIBlock release];
        }
    } copy];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), updateRSSIBlock);
}

#pragma mark - misc
+ (float)powerLossOverMeters:(float)meters
{
    float ktm = 0.621;
    float km = meters / 1000;
    float f = 2400;
    float d = km * ktm;
    f = log10(f) / log10(10);
	d = log10(d) / log10(10);
	return (20 * f) + (20 * d) + 36.56;
}

@end
