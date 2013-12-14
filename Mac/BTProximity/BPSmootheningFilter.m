//
//  BPSmootheningFilter.m
//  BTProximity
//
//  Created by Bogdan Covaci on 29.11.2013.
//  Copyright (c) 2013 Alex Covaci. All rights reserved.
//

#import "BPSmootheningFilter.h"


@interface BPSmootheningFilter ()
@property (nonatomic, retain) NSMutableArray *samples;
@property (nonatomic, assign) int currentSampleIndex;
@end

@implementation BPSmootheningFilter

+ (BPSmootheningFilter*)sharedInstance
{
    static BPSmootheningFilter *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BPSmootheningFilter alloc] init];
        sharedInstance.numberOfSamples = 10;
        sharedInstance.currentSampleIndex = 0;
    });
    return sharedInstance;
}

- (void)addSample:(int)value
{
    if(self.currentSampleIndex == 0)
    {
        self.samples = [NSMutableArray array];
    }

    if(self.currentSampleIndex > self.numberOfSamples-1)
    {
        [self.samples removeLastObject];
    }else
    {
        self.currentSampleIndex++;
    }

    [self.samples insertObject:[NSNumber numberWithInt:value] atIndex:0];
}

- (void)reset
{
    self.currentSampleIndex = 0;
}

- (int)getMedianValue
{
    int accumulator = 0;
    for(NSNumber *n in self.samples)
    {
        accumulator += [n intValue];
    }
    return accumulator / (int)self.samples.count;
}

- (int)getMaximumVariation
{
    int min = [[self.samples firstObject] intValue];
    int max = [[self.samples firstObject] intValue];

    for(NSNumber *n in self.samples)
    {
        int nn = [n intValue];
        if(nn > max) max = nn;
        if(nn < min) min = nn;
    }

    return max - min;
}

#pragma mark - setters
- (void)setNumberOfSamples:(int)numberOfSamples
{
    _numberOfSamples = numberOfSamples;
    self.currentSampleIndex = 0;
}

@end
