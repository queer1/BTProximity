//
//  BPAppDelegate.h
//  BTProximity
//
//  Created by Alex Covaci on 23.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BPPreferencesWindowController.h"
#import "BPCalibrationWindowController.h"


@interface BPAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
}

+ (BPAppDelegate*)instance;

- (IBAction)statusBarPreferencesPressed:(id)sender;
- (IBAction)statusBarStatusPressed:(id)sender;
- (IBAction)statusBarQuitPressed:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusBarMenu;
@property (assign) IBOutlet NSMenuItem *statusBarStatus;

@property (nonatomic, retain) BPPreferencesWindowController *preferencesController;
@property (nonatomic, retain) BPCalibrationWindowController *calibrationWindowController;

@end
