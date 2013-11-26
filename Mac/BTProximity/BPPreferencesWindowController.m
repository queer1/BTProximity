//
//  BPPreferencesWindowController.m
//  BTProximity
//
//  Created by Bogdan Covaci on 26.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "BPPreferencesWindowController.h"


@implementation BPPreferencesWindowController


/*
 
 NSAttributedString *s = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@\n", [self.dateFormatter stringFromDate:[NSDate date]], text]] autorelease];

 [[weakSelf.loggingTextView textStorage] appendAttributedString:s];
 [weakSelf.loggingTextView scrollRangeToVisible:NSMakeRange([[weakSelf.loggingTextView string] length], 0)];

 */


/*
 
 if(self.currentRSSI == 127)
 {
 self.RSSILabel.stringValue = @"RSSI: not connected";
 }else
 {
 self.RSSILabel.stringValue = [NSString stringWithFormat:@"RSSI: %d", self.currentRSSI];
 }

 */

- (void)dealloc
{
    [super dealloc];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [self release];
}

@end
