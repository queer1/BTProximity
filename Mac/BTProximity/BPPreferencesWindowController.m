//
//  BPPreferencesWindowController.m
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPPreferencesWindowController.h"


@interface BPPreferencesWindowController ()
@property (nonatomic, retain) NSTimer *updateTimer;
@end

@implementation BPPreferencesWindowController

- (void)dealloc
{
    [BPTracker sharedTracker].deviceSelectedBlock = nil;
    [self.updateTimer invalidate];
    self.updateTimer = nil;

    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    self.passwordTextField.stringValue = [BPSecHelpers getPassword] ? [BPSecHelpers getPassword] : @"";

    __block typeof(self) weakSelf = self;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                         block:^(NSTimer *timer) {
                                                             weakSelf.RSSILabel.stringValue = [BPTracker sharedTracker].device ? [NSString stringWithFormat:@"RSSI: %d", [BPTracker sharedTracker].currentRSSI] : @"RSSI: not connected";
                                                             NSString *deviceAddress = [BPTracker sharedTracker].device.addressString;
                                                             weakSelf.thresholdLabel.stringValue = [NSString stringWithFormat:@"Device:\t%@\nIdle RSSI:\t\t%d\nThreshold RSSI:\t%d", [BPTracker sharedTracker].device.name, [BPDeviceRepo getIdleRSSIForDevice:deviceAddress], [BPDeviceRepo getThresholdRSSIForDevice:deviceAddress]];

                                                             NSAttributedString *s = [[[NSAttributedString alloc] initWithString:[BPLogger getStorage]] autorelease];

                                                             [[weakSelf.logTextView textStorage] setAttributedString:s];
                                                             [weakSelf.logTextView scrollRangeToVisible:NSMakeRange([[weakSelf.logTextView string] length], 0)];
                                                         }
                                                       repeats:YES];
}

#pragma mark - actions
- (IBAction)selectDevicePressed:(id)sender
{
    [[BPTracker sharedTracker] selectDevice];
}

- (IBAction)startPressed:(id)sender
{
    [[BPTracker sharedTracker] startMonitoring];
}

- (IBAction)stopPressed:(id)sender
{
    [[BPTracker sharedTracker] stopMonitoring];
}

#pragma mark - text field delegate
- (void)controlTextDidChange:(NSNotification *)obj
{
    [BPSecHelpers setPassword:self.passwordTextField.stringValue];
}

@end
