//
//  AdUpdater.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/9/11.
//

#import <Foundation/Foundation.h>
#import "AdView_Private.h"
#import "AdView.h"
#import "AdModel.h"

@interface AdUpdater : NSObject {
	BOOL			_updateStarted;
    BOOL            _viewVisible;
	AdView*			_adView;
    BOOL            _valid;
}

- (void)invalidate;

@property (assign) AdView* adView;
@property (retain) NSTimer* updateTimer;
@property (assign) NSTimeInterval updateTimeInterval;

@end
