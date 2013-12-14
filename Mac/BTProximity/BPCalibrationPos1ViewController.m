//
//  BPCalibrationPos1ViewController.m
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPCalibrationPos1ViewController.h"
#import "BPCalibrationPos2ViewController.h"


@interface BPCalibrationPos1ViewController ()
@end

@implementation BPCalibrationPos1ViewController

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
    BPCalibrationPos2ViewController *controller = [[[BPCalibrationPos2ViewController alloc] initWithNibName:@"BPCalibrationPos2ViewController" bundle:nil] autorelease];

    [[BPAppDelegate instance].calibrationWindowController.navigationController pushViewController:controller animated:YES];
}

#pragma mark - actions
- (IBAction)startClicked:(id)sender
{
    [sender removeFromSuperview];

    [BPLogger log:@"getting 1st reading..."];
    [[BPTracker sharedTracker] getReadingOverSeconds:5
                                        allowedDelta:5
                                         updateBlock:^(BPTracker *tracker, BluetoothHCIRSSIValue RSSI) {
                                             [BPLogger log:[NSString stringWithFormat:@"reading tick. RSSI: %d", RSSI]];
                                         }
                                       finishedBlock:^(BPTracker *tracker, BluetoothHCIRSSIValue finalRSSI) {
                                           [BPLogger log:[NSString stringWithFormat:@"1st reading done. final RSSI: %d", finalRSSI]];
                                           [BPDeviceRepo setIdleRSSI:finalRSSI forDevice:tracker.device.addressString];
                                           [self pushNext];
                                       }];
}
@end
