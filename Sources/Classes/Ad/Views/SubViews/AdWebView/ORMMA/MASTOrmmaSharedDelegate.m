//
//  MASTOrmmaSharedDelegate.m
//

#import "MASTOrmmaSharedDelegate.h"
#import "MASTExpandView.h"
#import "MASTOrmmaHelper.h"
#import "MASTUIColorAdditions.h"
#import "MASTExpandViewController.h"
#import "MASTUIWebViewAdditions.h"
#import "MASTInternalAVPlayer.h"
#import "MASTNotificationCenter.h"
#import "MASTNetworkQueue.h"
#import "MASTConstants.h"

@interface MASTOrmmaSharedDelegate ()

@property (nonatomic, retain) MASTExpandViewController *expandVC;
@property (nonatomic, retain) MASTExpandView *expandView;
@property (nonatomic, retain) UIView *lastSuperView;
@property (nonatomic, retain) UIColor *lastBackgroundColor;
@property (assign) UIViewAutoresizing lastAutoresizing;
@property (nonatomic, retain) NSMutableDictionary *adControls;
@property (nonatomic, assign) CGRect defaultFrame;

-(UIViewController*)viewControllerForView:(UIView*)view;
-(CGRect)loadDefaultFrame:(NSDictionary*)frameValue;
-(void)saveOptions:(id)adControl;
-(void)loadOptions:(id)adControl;

@end

@implementation MASTOrmmaSharedDelegate

@synthesize expandVC, expandView, lastSuperView, lastBackgroundColor, defaultFrame, adControls, lastAutoresizing;

static MASTOrmmaSharedDelegate *sharedDelegate = nil;

#pragma mark - Public method

+ (id)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^ { 
        sharedDelegate = [self new]; 
        sharedDelegate.adControls = [NSMutableDictionary new];
    });
    return sharedDelegate;
}

#pragma mark - Private methods

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.expandVC = nil;
    self.expandView = nil;
    self.lastSuperView = nil;
    self.lastBackgroundColor = nil;
    self.adControls = nil;
    
    [super dealloc];
}

- (UIViewController*)viewControllerForView:(UIView*)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self viewControllerForView:nextResponder];
    } else {
        return nil;
    }
}

- (CGRect)loadDefaultFrame:(NSDictionary*)frameValue {
    float x = [[frameValue objectForKey:@"frameX"] floatValue];
    float y = [[frameValue objectForKey:@"frameY"] floatValue];
    float width = [[frameValue objectForKey:@"sizeWidth"] floatValue];
    float height = [[frameValue objectForKey:@"sizeHeight"] floatValue];
    
    return CGRectMake(x, y, width, height); 
}

- (void)saveOptions:(id)adControl {
    NSMutableDictionary *options = [[NSMutableDictionary new] autorelease];
    
    if (self.expandVC)
        [options setObject:self.expandVC forKey:@"expandVC"];
    
    if (self.expandView) 
        [options setObject:self.expandView forKey:@"expandView"];
    
    if (self.lastAutoresizing || self.lastAutoresizing == UIViewAutoresizingNone) 
        [options setObject:[NSNumber numberWithUnsignedInt:self.lastAutoresizing] forKey:@"lastAutoresizing"];
    
    if (self.lastSuperView)
        [options setObject:self.lastSuperView forKey:@"lastSuperView"];
    
    if (self.lastBackgroundColor) 
        [options setObject:self.lastBackgroundColor forKey:@"lastBackgroundColor"];
	
    [options setObject:[NSNumber numberWithInt:self.defaultFrame.origin.x] forKey:@"frameX"];
    [options setObject:[NSNumber numberWithInt:self.defaultFrame.origin.y] forKey:@"frameY"];
    [options setObject:[NSNumber numberWithInt:self.defaultFrame.size.width] forKey:@"sizeWidth"];
    [options setObject:[NSNumber numberWithInt:self.defaultFrame.size.height] forKey:@"sizeHeight"];
    
    [self.adControls setObject:options forKey:[NSString stringWithFormat:@"%ld", adControl]];
}

- (void)loadOptions:(id)adControl {
    NSDictionary *options = [self.adControls objectForKey:[NSString stringWithFormat:@"%ld", adControl]];
    
    self.expandVC = [options objectForKey:@"expandVC"];
    self.expandView = [options objectForKey:@"expandView"];
    self.lastSuperView = [options objectForKey:@"lastSuperView"];
    self.lastBackgroundColor = [options objectForKey:@"lastBackgroundColor"];
    self.lastAutoresizing = [[options objectForKey:@"lastAutoresizing"] unsignedIntValue];
    self.defaultFrame = [self loadDefaultFrame:options];
}

#pragma mark - Support delegate methods

- (BOOL)supportAudioForAd:(id)sender {
    return YES;
}

- (BOOL)supportVideoForAd:(id)sender {
    return YES;
}

- (BOOL)supportMASTForAd:(id)sender {
    return YES;
}

- (BOOL)supportCalendarForAd:(id)sender {
    if (NSClassFromString(@"EKEventStore")) {
		return YES; 
	}
    return NO;
}

- (BOOL)supportEmailForAd:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)supportSmsForAd:(id)sender {
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil) {
        if ([smsClass canSendText]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)supportPhoneForAd:(id)sender {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        return YES;
    }
    return NO;
}

- (CGSize)maxSizeForAd:(id)sender {
    UIViewController* vc = [self viewControllerForView:(UIView*)sender];
    if (vc) {
        return vc.view.frame.size;
    } else {
        return CGSizeZero;
    }
}

#pragma mark - Main delegate methods

- (void)showAd:(id)sender {
    UIView *adControl = sender;
    if (adControl.hidden) {
        adControl.hidden = NO;
    }
}

- (void)hideAd:(id)sender {
    UIView *adControl = sender;
    adControl.hidden = YES;
}

- (void)closeFromState:(ORMMAState)state ad:(id)sender {
    UIView *adControl = sender;
    
    //load options
    [self loadOptions:adControl];
    
    if (state == ORMMAStateExpanded) {
        [self.expandVC dismissModalViewControllerAnimated:NO];
        
        if (self.expandView && self.expandVC) {
            // we need to close expandView
            self.expandView = nil;
        } else {
            [self.lastSuperView addSubview:adControl];
            self.lastSuperView = nil;
            
            if (self.lastBackgroundColor) {
                adControl.backgroundColor = self.lastBackgroundColor;
                self.lastBackgroundColor = nil;
            }
            
            if (self.lastAutoresizing || self.lastAutoresizing == UIViewAutoresizingNone) {
                adControl.autoresizingMask = self.lastAutoresizing;
            }
            
            // resize to normal frame
            adControl.frame = self.defaultFrame;
            /*[UIView animateWithDuration:0.2 animations:^(void) {
			 adControl.frame = self.defaultFrame;
			 }];*/
        }
        self.expandVC = nil;
        
        if ([sender respondsToSelector:@selector(removeUpdateFlag:)]) {
            [sender performSelector:@selector(removeUpdateFlag:) withObject:@"expand"];
        }
    } else {
        adControl.frame = self.defaultFrame;
        /*[UIView animateWithDuration:0.2 animations:^(void) {
		 adControl.frame = self.defaultFrame;
		 }];*/
    }
}

- (void)expandURL:(NSString*)url parameters:(NSDictionary*)parameters ad:(id)sender {
    UIView *adControl = sender;
    self.defaultFrame = adControl.frame;
    self.lastAutoresizing = adControl.autoresizingMask;
    
    CGFloat w = [MASTOrmmaHelper floatFromDictionary:parameters forKey:@"width"];
    CGFloat h = [MASTOrmmaHelper floatFromDictionary:parameters forKey:@"height"];
    BOOL lockOrientation = [MASTOrmmaHelper booleanFromDictionary:parameters forKey:@"lockOrientation"];
    BOOL useCustomClose = [MASTOrmmaHelper booleanFromDictionary:parameters forKey:@"useCustomClose"];
    
    BOOL useBackground = [MASTOrmmaHelper booleanFromDictionary:parameters forKey:@"useBackground"];
    UIColor* backgroundColor = [UIColor colorWithHexString:[[MASTOrmmaHelper requiredStringFromDictionary:parameters forKey:@"backgroundColor"] stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    CGFloat backgroundOpacity = [MASTOrmmaHelper floatFromDictionary:parameters forKey:@"backgroundOpacity"];
    
    UIColor* expandBackgroundColor = nil;
    
    NSArray* rgba = [backgroundColor arrayFromRGBAComponents];
    if (useBackground && backgroundColor && rgba && [rgba count] >= 3) {
        CGFloat r = [(NSNumber*)[rgba objectAtIndex:0] floatValue];
        CGFloat g = [(NSNumber*)[rgba objectAtIndex:1] floatValue];
        CGFloat b = [(NSNumber*)[rgba objectAtIndex:2] floatValue];
        expandBackgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:backgroundOpacity];
    } else {
        expandBackgroundColor = [UIColor whiteColor];
    }
    
    self.expandVC = [[[MASTExpandViewController alloc] initWithLockOrientation:lockOrientation] autorelease];
    self.expandVC.view.backgroundColor = expandBackgroundColor;
    
    UIViewController* rootVC = [self viewControllerForView:adControl.superview];
    
    if (rootVC) {
        if ([sender respondsToSelector:@selector(setUpdateFlag:)]) {
            [sender performSelector:@selector(setUpdateFlag:) withObject:@"expand"];
        }
		
        [rootVC presentModalViewController:self.expandVC animated:NO];
    }
    
    if (!lockOrientation) {
        adControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (url) {                        
        self.expandView = [[[MASTExpandView alloc] initWithFrame:CGRectMake(0, 0, w, h)] autorelease];
        self.expandView.adView = adControl;
        self.expandView.backgroundColor = expandBackgroundColor;
        
        [self.expandVC.view addSubview:self.expandView];
        
        [self.expandView loadUrl:url];
        
        self.expandVC.expandView = self.expandView;
        [self.expandVC useCustomClose:NO];
    } else {        
        // to make shure
        self.expandView = nil;
        self.lastBackgroundColor = adControl.backgroundColor;
        adControl.backgroundColor = expandBackgroundColor;
        
        self.lastSuperView = adControl.superview;
        [self.expandVC.view addSubview:adControl];
        
        // resize
        adControl.frame = CGRectMake(0.0, 0.0, w, h);
        
        self.expandVC.expandView = adControl;
        [self.expandVC useCustomClose:useCustomClose];
    }
    
    //save options
    [self saveOptions:adControl];
}

- (void)resize:(CGSize)size ad:(id)sender {
    UIView *adControl = sender;
    self.defaultFrame = adControl.frame;
    
    adControl.frame = CGRectMake(adControl.frame.origin.x, adControl.frame.origin.y, size.width, size.height);
    /*[UIView animateWithDuration:0.2 animations:^(void) {
	 adControl.frame = CGRectMake(adControl.frame.origin.x, adControl.frame.origin.y, size.width, size.height);
	 }];*/
    
    //save options
    [self saveOptions:adControl];
}

- (void)phone:(NSString*)number ad:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)sms:(NSString*)to body:(NSString*)body ad:(id)sender {
    UIView *adControl = sender;
    if (body && to && NSClassFromString(@"MFMessageComposeViewController") && [MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *vc = [[[MFMessageComposeViewController alloc] init] autorelease];
        NSArray *recipients = [NSArray arrayWithObject:to];
        vc.recipients = recipients;
        vc.body = body;
        vc.messageComposeDelegate = self;
        
        UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!rvc) {
            rvc = [self viewControllerForView:[UIApplication sharedApplication].keyWindow];
        }
        if (!rvc) {
            rvc = [self viewControllerForView:adControl];
        }
        [rvc presentModalViewController:vc animated:YES];
    }
}

- (void)email:(NSString*)to subject:(NSString*)subject body:(NSString*)body useHtml:(BOOL)useHtml ad:(id)sender {
    UIView *adControl = sender;
    MFMailComposeViewController *vc = [[[MFMailComposeViewController alloc] init] autorelease];
    NSArray *recipients = [NSArray arrayWithObject:to];
    [vc setToRecipients:recipients];
    [vc setSubject:subject];
    [vc setMessageBody:body  isHTML:useHtml];
    vc.mailComposeDelegate = self;
	
    UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rvc) {
        rvc = [self viewControllerForView:[UIApplication sharedApplication].keyWindow];
    }
    if (!rvc) {
        rvc = [self viewControllerForView:adControl];
    }
    [rvc presentModalViewController:vc animated:YES];
}

- (void)calendar:(NSString*)title body:(NSString*)body date:(NSDate*)date ad:(id)sender {
    // handle internally
    EKEventStore* eventStore = [[[EKEventStore alloc] init] autorelease];
    EKEvent* ekEvent = [EKEvent eventWithEventStore:eventStore];
    ekEvent.title = title;
	
    ekEvent.notes = body;
	
    ekEvent.startDate = date;
    ekEvent.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:ekEvent.startDate];
    [ekEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    BOOL status = [eventStore saveEvent:ekEvent span:EKSpanThisEvent error:nil];
}

- (void)openMASTWithPOI:(NSString*)poi ad:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kGoogleMapsUrl, [poi stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)playAudio:(NSString*)url parameters:(NSDictionary*)parameters ad:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [info setObject:url forKey:@"url"];
    if (self.expandVC) {
        [info setObject:self.expandVC.view forKey:@"adView"];
    } else {
        [info setObject:sender forKey:@"adView"];
    }
    
    [[MASTInternalAVPlayer sharedInstance] playAudio:info];
}

- (void)playVideo:(NSString*)url parameters:(NSDictionary*)parameters ad:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [info setObject:url forKey:@"url"];
    if (self.expandVC) {
        [info setObject:self.expandVC.view forKey:@"adView"];
    } else {
        [info setObject:sender forKey:@"adView"];
    }
    
    [[MASTInternalAVPlayer sharedInstance] playVideo:info];
}

- (void)sendRequest:(NSString*)url display:(NSString*)display response:(void (^)(NSString* response))response ad:(id)sender {
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [MASTNetworkQueue loadWithURLRequest:request completion:^(NSURLRequest *request, NSHTTPURLResponse *httpResponse, NSData *data, NSError *error) {
        if (!error && data && [data length] > 0) {
            NSString* responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            response(responseString);
        }
    }];
}

#pragma mark - MFMessageComposeViewController Delegete


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    /*UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
	 if (!rvc) {
	 rvc = [self viewControllerForView:[UIApplication sharedApplication].keyWindow];
	 }
	 if (!rvc) {
	 rvc = [self.adView viewControllerForView];
	 }
	 [rvc dismissModalViewControllerAnimated:YES];*/
    [controller dismissModalViewControllerAnimated:YES];
}


#pragma mark - MFMailComposeViewController Delegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    /*UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
	 if (!rvc) {
	 rvc = [[UIApplication sharedApplication].keyWindow viewControllerForView];
	 }
	 if (!rvc) {
	 rvc = [self.adView viewControllerForView];
	 }
	 [rvc dismissModalViewControllerAnimated:YES];*/
    [controller dismissModalViewControllerAnimated:YES];
}

@end
