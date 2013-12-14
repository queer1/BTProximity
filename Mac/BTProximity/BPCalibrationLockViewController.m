//
//  BPCalibrationLockViewController.m
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPCalibrationLockViewController.h"
#import "BPCalibrationPos1ViewController.h"

@interface BPCalibrationLockViewController ()
@end

@implementation BPCalibrationLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    return self;
}

#pragma mark - actions
- (IBAction)nextClicked:(id)sender
{
    BPCalibrationPos1ViewController *controller = [[[BPCalibrationPos1ViewController alloc] initWithNibName:@"BPCalibrationPos1ViewController" bundle:nil] autorelease];

    [[BPAppDelegate instance].calibrationWindowController.navigationController pushViewController:controller animated:YES];
}
@end
