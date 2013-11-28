//
//  BPAppDelegate.m
//  BTProximity
//
//  Created by Alex Covaci on 23.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPAppDelegate.h"
#import "BPPreferencesWindowController.h"


@interface BPAppDelegate ()
@property (nonatomic, retain) NSStatusItem *statusBarItem;
@property (nonatomic, retain) BPPreferencesWindowController *preferencesController;
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

    [BPSecHelpers setPassword:[SSKeychain passwordForService:@"BTProximity" account:@"BTProximity"]];

    [BPTracker sharedTracker].rangeStatusUpdateBlock = ^(BPTracker *tracker){
        if(tracker.deviceInRange)
        {
            [BPLogger log:@"device in range"];
            [BPSecHelpers unlock];
        }else
        {
            [BPLogger log:@"device not in range"];
            [BPSecHelpers lock];
        }
    };

    dispatch_async(dispatch_get_main_queue(), ^{
        [self statusBarPreferencesPressed:nil];
    });
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
    if(!self.preferencesController)
    {
        self.preferencesController = [[[BPPreferencesWindowController alloc] initWithWindowNibName:@"BPPreferencesWindowController"] autorelease];
        self.preferencesController.window.delegate = self;
    }

    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.preferencesController.window makeKeyAndOrderFront:nil];
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

#pragma mark - window delegate
- (void)windowWillClose:(NSNotification *)notification
{
    NSWindow *window = (NSWindow*)notification.object;

    if(window == self.preferencesController.window)
    {
        self.preferencesController = nil;
    }
}

@end
