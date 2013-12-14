//
//  BPCalibrationWindowController.m
//  BTProximity
//
//  Created by Bogdan Covaci on 14.12.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPCalibrationWindowController.h"
#import "BPCalibrationLockViewController.h"


@interface BPCalibrationWindowController ()
@end

@implementation BPCalibrationWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if(self)
    {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    BPCalibrationLockViewController *lockController = [[[BPCalibrationLockViewController alloc] initWithNibName:@"BPCalibrationLockViewController" bundle:nil] autorelease];

    NSRect frame = NSRectFromCGRect(CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height));
    self.navigationController = [[[BFNavigationController alloc] initWithFrame:frame rootViewController:lockController] autorelease];
    [self.window.contentView addSubview:self.navigationController.view];
}

@end
