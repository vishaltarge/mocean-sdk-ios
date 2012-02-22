//
//  MASTAccelerometer.h
//  Copyright (c) Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASTAccelerometer : NSObject <UIAccelerometerDelegate>

+ (MASTAccelerometer*)sharedInstance;

- (void)addDelegate:(id <UIAccelerometerDelegate>)delegate;
- (void)removeDelegate:(id <UIAccelerometerDelegate>)delegate;

@end
