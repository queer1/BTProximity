//
//  BPTracker.m
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPTracker.h"


@interface BPTracker ()
@property (nonatomic, assign) int readingSeconds;
@property (nonatomic, assign) int readingDelta;
@property (nonatomic, copy) BPReadingUpdateBlock readingUpdateBlock;
@property (nonatomic, copy) BPReadingFinishedBlock readingFinishedBlock;
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

- (void)getReadingOverSeconds:(int)seconds allowedDelta:(int)delta updateBlock:(BPReadingUpdateBlock)updateBlock finishedBlock:(BPReadingFinishedBlock)finishedBlock
{
    self.readingSeconds = seconds;
    self.readingDelta = delta;
    self.readingUpdateBlock = updateBlock;
    self.readingFinishedBlock = finishedBlock;
    [NSThread detachNewThreadSelector:@selector(_getReading) toTarget:self withObject:nil];
}

- (void)startMonitoring
{
    _isMonitoring = YES;

    [BPLogger log:@"starting..."];
    [[BPSmootheningFilter sharedInstance] reset];

    [NSThread detachNewThreadSelector:@selector(_updateRSSI) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(_updateStatus) toTarget:self withObject:nil];
    [BPLogger log:@"started"];

    self.deviceInRange = YES;
    self.initialRSSI = -127;
}

- (void)stopMonitoring
{
    _isMonitoring = NO;
    [BPLogger log:@"stopped"];
}

- (void)selectDevice
{
    IOBluetoothDeviceSelectorController *deviceSelector = [IOBluetoothDeviceSelectorController deviceSelector];
    [deviceSelector runModal];

    NSArray *results = [deviceSelector getResults];

    if(results)
    {
        self.device = [results objectAtIndex:0];
        [self.device closeConnection];

        if(self.deviceSelectedBlock)
        {
            self.deviceSelectedBlock(self);
        }
    }
}

- (void)_getReading
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float secondsStable = 0;
    BluetoothHCIRSSIValue currentRSSI = -127;

    [self.device closeConnection];
    while(1)
    {
        if(self.device)
        {
            BOOL reconnected = NO;

            if(![self.device isConnected])
            {
                reconnected = ([self.device openConnection] == kIOReturnSuccess);
                [[BPSmootheningFilter sharedInstance] reset];
                secondsStable = 0;
            }

            if([self.device isConnected])
            {
                currentRSSI = [self.device rawRSSI];
                [[BPSmootheningFilter sharedInstance] addSample:currentRSSI];

                if([[BPSmootheningFilter sharedInstance] getMaximumVariation] > self.readingDelta)
                {
                    secondsStable = 0;
                }
            }

            if(self.readingUpdateBlock)
            {
                self.readingUpdateBlock(self, currentRSSI);
            }

            secondsStable += 0.25;
            if((int)secondsStable >= self.readingSeconds)
            {
                if(self.readingFinishedBlock)
                {
                    self.readingFinishedBlock(self, [[BPSmootheningFilter sharedInstance] getMedianValue]);
                }
                break;
            }
        }else
        {
            [BPLogger log:@"[!] _getReading: No device selected"];
            break;
        }

        [NSThread sleepForTimeInterval:0.25];
    }

    [self.device closeConnection];
    [pool release];
}

- (void)_updateStatus
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    while(self.isMonitoring)
    {
        if(self.device && [self.device isConnected])
        {
            if(self.currentRSSI > self.inRangeThreshold)
            {
                if(!self.deviceInRange)
                {
                    self.deviceInRange = YES;

                    if(self.rangeStatusUpdateBlock)
                    {
                        self.rangeStatusUpdateBlock(self);
                    }
                }
            }else
            {
                if(self.deviceInRange)
                {
                    self.deviceInRange = NO;

                    if(self.rangeStatusUpdateBlock)
                    {
                        self.rangeStatusUpdateBlock(self);
                    }
                }
            }
        }

        [NSThread sleepForTimeInterval:0.25];
    }
    
    [pool release];
}

- (void)_updateRSSI
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    while(self.isMonitoring)
    {
        if(self.device)
        {
            BOOL reconnected = NO;

            if(![self.device isConnected])
            {
                reconnected = ([self.device openConnection] == kIOReturnSuccess);
                [[BPSmootheningFilter sharedInstance] reset];
            }

            if([self.device isConnected])
            {
                BluetoothHCIRSSIValue rawRSSI = [self.device rawRSSI];
                [[BPSmootheningFilter sharedInstance] addSample:rawRSSI];
                self.currentRSSI = [[BPSmootheningFilter sharedInstance] getMedianValue];
            }else
            {
                [BPLogger log:@"[!] couldn't connect. will attempt to reconnect on next tick."];
            }

            if(reconnected)
            {
                self.initialRSSI = self.currentRSSI;
            }
        }

        [NSThread sleepForTimeInterval:0.25];
    }

    [self.device closeConnection];
    [pool release];
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
