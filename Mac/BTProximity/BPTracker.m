//
//  BPTracker.m
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "BPTracker.h"


@interface BPTracker ()
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) float initialDistance;
@property (nonatomic, assign) float currentDistance;
@end

@implementation BPTracker

+ (BPTracker*)sharedTracker
{
    static BPTracker *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BPTracker alloc] init];
    });
    return sharedInstance;
}

- (void)startMonitoring
{
    self.isMonitoring = YES;

    [BPLogger log:@"starting..."];
    [self updateRSSI];
    [BPLogger log:@"started"];

    self.inRange = YES;
    self.initialRSSI = self.currentRSSI;
    self.initialDistance = (float)abs(self.currentRSSI) / [BPTracker powerLossOverMeters:1];

    [BPLogger log:[NSString stringWithFormat:@"current estimated distance (in perfect conditions): %.02f meters", self.initialDistance]];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopMonitoring
{
    self.isMonitoring = NO;

    [BPLogger log:@"stopping..."];
    [self.device closeConnection];
    [BPLogger log:@"stopped"];

    [self.timer invalidate];
    self.timer = nil;
}

- (void)changeDevice
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

- (void)handleTimer:(NSTimer *)theTimer
{
    [self updateRSSI];

    if(self.currentRSSI > -70)
    {
        if(!self.inRange)
        {
            [BPLogger log:@"in range"];
            self.inRange = YES;

            [self unlock];
        }
    }else
    {
        if(self.inRange)
        {
            [BPLogger log:@"out of range"];
            self.inRange = NO;

            [self lock];
        }
    }
}

- (void)updateRSSI
{
    if(self.device)
    {
        BOOL reconnected = NO;

        if(![self.device isConnected])
        {
            [BPLogger log:@"reopening connection"];
            [self.device openConnection];
            reconnected = YES;
        }

        if([self.device isConnected])
        {
            BluetoothHCIRSSIValue rawRSSI = [self.device rawRSSI];
            if(reconnected)
            {
                self.currentRSSI = rawRSSI;
            }else
            {
                self.currentRSSI = (abs(self.currentRSSI) + abs(rawRSSI)) / 2 * ((rawRSSI < 0) ? -1 : 1);
            }
        }else
        {
            self.currentRSSI = 127;
        }

        if(reconnected)
        {
            self.initialRSSI = self.currentRSSI;
            self.initialDistance = (float)abs(self.currentRSSI) / [BPTracker powerLossOverMeters:1];
        }
    }

    self.currentDistance = (float)abs(self.currentRSSI) / [BPTracker powerLossOverMeters:1];
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
