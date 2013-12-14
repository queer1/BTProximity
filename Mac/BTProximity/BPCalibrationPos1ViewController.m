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
