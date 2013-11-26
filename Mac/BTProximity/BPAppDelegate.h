//
//  BPAppDelegate.h
//  BTProximity
//
//  Created by Bogdan Covaci on 23.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BPAppDelegate : NSObject <NSApplicationDelegate>
{
}

- (IBAction)selectDevicePressed:(id)sender;
- (IBAction)startPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;

- (IBAction)statusBarPreferencesPressed:(id)sender;
- (IBAction)statusBarStatusPressed:(id)sender;
- (IBAction)statusBarQuitPressed:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *startButton;
@property (assign) IBOutlet NSButton *stopButton;
@property (assign) IBOutlet NSTextField *RSSILabel;
@property (assign) IBOutlet NSTextView *loggingTextView;
@property (assign) IBOutlet NSTextField *passwordTextField;
@property (assign) IBOutlet NSMenu *statusBarMenu;
@property (assign) IBOutlet NSMenuItem *statusBarStatus;

@end
