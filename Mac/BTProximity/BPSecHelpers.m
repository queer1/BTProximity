//
//  BPSecHelpers.m
//  BTProximity
//
//  Created by Alex Covaci on 26.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPSecHelpers.h"


NSString *password;

@implementation BPSecHelpers

+ (BOOL)isScreenLocked
{
    BOOL locked = NO;
    id o = [(NSDictionary*)CGSessionCopyCurrentDictionary() objectForKey:@"CGSSessionScreenIsLocked"];
    if(o)
    {
        locked = [o boolValue];
    }
    return locked;
}

+ (void)lock
{
    if([BPSecHelpers isScreenLocked]) return;

    int screensaverDelay = [BPSecHelpers getScreensaverDelay];
    BOOL screensaverAskForPassword = [BPSecHelpers getScreensaverAskForPassword];

    [BPSecHelpers setScreensaverDelay:0];
    [BPSecHelpers setScreensaverAskForPassword:YES];

    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if(r)
    {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanTrue);
        IOObjectRelease(r);
    }

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
        if(r)
        {
            IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
            IOObjectRelease(r);
        }

        [BPSecHelpers setScreensaverDelay:screensaverDelay];
        [BPSecHelpers setScreensaverAskForPassword:screensaverAskForPassword];
    });
}

+ (void)unlock
{
    while(![BPSecHelpers isScreenLocked]) {};

    NSString *s = @"\
tell application \"System Events\" to keystroke \"%@\"\n\
tell application \"System Events\" to keystroke return\
    ";

    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:s, password]] autorelease];
    [script executeAndReturnError:nil];
}

+ (void)setPassword:(NSString*)p
{
    if(password)
    {
        [password release];
    }

    password = [p copy];
}

+ (NSString*)getPassword
{
    return [[password copy] autorelease];
}

#pragma mark - helpers
+ (int)getScreensaverDelay
{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"];
    return [[prefs objectForKey:@"askForPasswordDelay"] intValue];
}

+ (BOOL)getScreensaverAskForPassword
{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"];
    return [[prefs objectForKey:@"askForPassword"] boolValue];
}

+ (void)setScreensaverDelay:(int)value
{
    NSArray *arguments = @[@"write",@"com.apple.screensaver",@"askForPasswordDelay", [NSString stringWithFormat:@"%i", value]];
    NSTask *resetDelayTask = [[[NSTask alloc] init] autorelease];
    [resetDelayTask setArguments:arguments];
    [resetDelayTask setLaunchPath: @"/usr/bin/defaults"];
    [resetDelayTask launch];
}

+ (void)setScreensaverAskForPassword:(BOOL)value
{
    NSArray *arguments = @[@"write",@"com.apple.screensaver",@"askForPassword", [NSString stringWithFormat:@"%i", value]];
    NSTask *resetDelayTask = [[[NSTask alloc] init] autorelease];
    [resetDelayTask setArguments:arguments];
    [resetDelayTask setLaunchPath: @"/usr/bin/defaults"];
    [resetDelayTask launch];

    NSAppleScript *kickSecurityPreferencesScript = [[[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:@"tell application \"System Events\" to tell security preferences to set require password to wake to %@", value ? @"true" : @"false"]] autorelease];
    [kickSecurityPreferencesScript executeAndReturnError:nil];
}

@end
