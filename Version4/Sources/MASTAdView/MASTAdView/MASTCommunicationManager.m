//
//  MASTCommunicationManager.m
//  MASTAdView
//
//  Created by Shrinivas Prabhu on 21/07/14.
//  Copyright (c) 2014 Mocean Mobile. All rights reserved.
//

#import "MASTCommunicationManager.h"

@implementation MASTCommunicationManager

- (void)requestWithCompletionHandler:(MPNativeAdRequestHandler)handler
{
    if(handler)
    {
//        NSURLConnection sendAsynchronousRequest:<#(NSURLRequest *)#> queue:[NSOperation m] completionHandler:<#^(NSURLResponse *response, NSData *data, NSError *connectionError)handler#>
    }
    else
    {
        NSLog(@"Handler would be necessary while making a request. Kindly provide a handler");
    }
}

@end
