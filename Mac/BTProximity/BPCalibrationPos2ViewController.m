//
//  BPCalibrationPos2ViewController.m
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPCalibrationPos2ViewController.h"
#import "BPCalibrationDoneViewController.h"

@interface BPCalibrationPos2ViewController ()
@end

@implementation BPCalibrationPos2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    return self;
}

- (void)pushNext
{
    BPCalibrationDoneViewController *controller = [[[BPCalibrationDoneViewController alloc] initWithNibName:@"BPCalibrationDoneViewController" bundle:nil] autorelease];

    [[BPAppDelegate instance].calibrationWindowController.navigationController pushViewController:controller animated:YES];
}

- (void)loadView
{
    [super loadView];

    [BPLogger log:@"getting 2nd reading..."];
    [[BPTracker sharedTracker] getReadingOverSeconds:5
                                        allowedDelta:5
                                         updateBlock:^(BPTracker *tracker, BluetoothHCIRSSIValue RSSI) {
                                             [BPLogger log:[NSString stringWithFormat:@"reading tick. RSSI: %d", RSSI]];
                                         }
                                       finishedBlock:^(BPTracker *tracker, BluetoothHCIRSSIValue finalRSSI) {
                                           [BPLogger log:[NSString stringWithFormat:@"2nd reading done. final RSSI: %d", finalRSSI]];
                                           [self pushNext];
                                       }];
}

@end
