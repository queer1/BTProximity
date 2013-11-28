//
//  BPAppDelegate.h
//  BTProximity
//
//  Created by Alex Covaci on 23.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BPAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
}

- (IBAction)statusBarPreferencesPressed:(id)sender;
- (IBAction)statusBarStatusPressed:(id)sender;
- (IBAction)statusBarQuitPressed:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusBarMenu;
@property (assign) IBOutlet NSMenuItem *statusBarStatus;

@end
