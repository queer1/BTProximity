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

- (IBAction)thresholdSliderChanged:(id)sender
{
    int value = self.thresholdSlider.intValue;

    self.thresholdLabel.stringValue = [NSString stringWithFormat:@"Threshold: %d", value];
    [BPTracker sharedTracker].inRangeThreshold = value;
}

#pragma mark - text field delegate
- (void)controlTextDidChange:(NSNotification *)obj
{
    [BPSecHelpers setPassword:self.passwordTextField.stringValue];
}

@end
