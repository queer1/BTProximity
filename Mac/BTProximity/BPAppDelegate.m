//
//  BPAppDelegate.m
//  BTProximity
//
//  Created by Bogdan Covaci on 23.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "BPAppDelegate.h"
#import "BPPreferencesWindowController.h"


@interface BPAppDelegate ()
@property (nonatomic, retain) NSStatusItem *statusBarItem;
@end

@implementation BPAppDelegate

- (void)dealloc
{
    self.statusBarItem = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusBarItem.image = [NSRunningApplication currentApplication].icon;
    self.statusBarItem.menu = self.statusBarMenu;

    [BPLogger log:[NSString stringWithFormat:@"power loss over 1 meter (perfect conditions): %.02f", [BPTracker powerLossOverMeters:1]]];

    [BPTracker sharedTracker].rangeStatusUpdateBlock = ^(BPTracker *tracker){
        if(tracker.deviceInRange)
        {
            [BPLogger log:@"device in range"];
        }else
        {
            [BPLogger log:@"device not in range"];
        }
    };
}

#pragma mark - actions
- (void)startMonitoring
{
    self.statusBarStatus.title = @"Disable BTProximity";
    [[BPTracker sharedTracker] startMonitoring];
}

- (void)stopMonitoring
{
    self.statusBarStatus.title = @"Enable BTProximity";
    [[BPTracker sharedTracker] stopMonitoring];
}

- (IBAction)statusBarPreferencesPressed:(id)sender
{
    BPPreferencesWindowController *controller = [[BPPreferencesWindowController alloc] initWithWindowNibName:@"BPPreferencesWindowController"];

    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[controller.window makeKeyAndOrderFront:nil];
}

- (IBAction)statusBarStatusPressed:(id)sender
{
    if([BPTracker sharedTracker].device)
    {
        [BPTracker sharedTracker].isMonitoring ? [self stopMonitoring] : [self startMonitoring];
    }
}

- (IBAction)statusBarQuitPressed:(id)sender
{
    [[NSRunningApplication currentApplication] terminate];
}

@end
