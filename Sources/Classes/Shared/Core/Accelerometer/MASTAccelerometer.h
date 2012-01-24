//
//  Accelerometer.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 9/12/11.
//

#import <Foundation/Foundation.h>

@interface Accelerometer : NSObject <UIAccelerometerDelegate>

+ (Accelerometer*)sharedInstance;

- (void)addDelegate:(id <UIAccelerometerDelegate>)delegate;
- (void)removeDelegate:(id <UIAccelerometerDelegate>)delegate;

@end
