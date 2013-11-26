//
//  BPTracker.h
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPTracker : NSObject
{
}

+ (BPTracker*)sharedTracker;

+ (float)powerLossOverMeters:(float)meters;

@property (nonatomic, strong) IOBluetoothDevice *device;
@property (nonatomic, assign) BluetoothHCIRSSIValue initialRSSI;
@property (nonatomic, assign) BluetoothHCIRSSIValue currentRSSI;
@property (nonatomic, assign) BOOL inRange;
@property (nonatomic, assign) BOOL isMonitoring;

@end
