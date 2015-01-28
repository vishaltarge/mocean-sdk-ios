/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  MASTNativeAdAttributes.m
//  MASTAdView
//
//  Created  on 26/08/14.

//

#import "MASTNativeAdAttributes.h"

@implementation MASTNativeAdAttributes
@synthesize title;
@synthesize adDescription;
@synthesize callToAction;
@synthesize coverImageURL;
@synthesize iconImageURL;
@synthesize rating;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title=nil;
        self.adDescription=nil;
        self.callToAction=nil;
        self.coverImageURL=nil;
        self.iconImageURL=nil;
        self.rating = nil;
    }
    return self;
}

- (void)dealloc
{
    
    self.title = nil;
    self.adDescription = nil;
    self.callToAction = nil;
    self.coverImageURL = nil;
    self.iconImageURL = nil;
   
}


@end
