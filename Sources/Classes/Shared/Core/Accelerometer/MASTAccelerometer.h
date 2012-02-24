//
//  MASTAccelerometer.h
//

#import <UIKit/UIKit.h>

@interface MASTAccelerometer : NSObject <UIAccelerometerDelegate>

+ (MASTAccelerometer*)sharedInstance;

- (void)addDelegate:(id <UIAccelerometerDelegate>)delegate;
- (void)removeDelegate:(id <UIAccelerometerDelegate>)delegate;

@end
