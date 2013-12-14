//
//  BPTracker.h
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BPTracker;
typedef void (^BPRangeStatusUpdateBlock)(BPTracker *tracker);
typedef void (^BPDeviceSelectedBlock)(BPTracker *tracker);

@interface BPTracker : NSObject
{
}

+ (BPTracker*)sharedTracker;
- (void)selectDevice;
- (void)startMonitoring;
- (void)stopMonitoring;

+ (float)powerLossOverMeters:(float)meters;

@property (nonatomic, strong) IOBluetoothDevice *device;
@property (nonatomic, assign) BluetoothHCIRSSIValue initialRSSI;
@property (nonatomic, assign) BluetoothHCIRSSIValue currentRSSI;
@property (nonatomic, assign) BOOL deviceInRange;
@property (nonatomic, readonly) BOOL isMonitoring;
@property (nonatomic, assign) int inRangeThreshold; // default is -70, range is (weak signal) -127..+20 (strong signal)
@property (nonatomic, copy) BPRangeStatusUpdateBlock rangeStatusUpdateBlock;
@property (nonatomic, copy) BPDeviceSelectedBlock deviceSelectedBlock;
@end
