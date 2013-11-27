//
//  BPPreferencesWindowController.h
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BPPreferencesWindowController : NSWindowController <NSTextFieldDelegate>
{
}

- (IBAction)selectDevicePressed:(id)sender;
- (IBAction)startPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (IBAction)thresholdSliderChanged:(id)sender;

@property (assign) IBOutlet NSTextField *RSSILabel;
@property (assign) IBOutlet NSTextView *logTextView;
@property (assign) IBOutlet NSSecureTextField *passwordTextField;
@property (assign) IBOutlet NSTextField *thresholdLabel;
@property (assign) IBOutlet NSSlider *thresholdSlider;
@end
