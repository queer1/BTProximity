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

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self pushNext];
    });
}

@end
