//
//  LogBasicFormatter.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/19/10.
//

#import <Foundation/Foundation.h>


@interface LogBasicFormatter : NSObject {

}

+ (NSString *)stringWithFormat:(NSString *)fmt valist:(va_list)args;

@end
