//
//  OrmmaAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import "OrmmaAdaptor.h"
#import "OrmmaConstants.h"
#import "OrmmaHelper.h"
#import "UIViewAdditions.h"
#import "Reachability.h"
#import "NotificationCenter.h"
#import "LocationManager.h"
#import "Accelerometer.h"
#import "SharedModel.h"
#import "NetworkQueue.h"
#import "ObjectStorage.h"
#import "ExpandWebView.h"
#import "UIColorAdditions.h"

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor() <UIAccelerometerDelegate>

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) AdView*           adView;
@property (nonatomic, retain) ExpandWebView*    expandView;

@property (nonatomic, assign) ORMMAState        nonHideState;
@property (nonatomic, assign) ORMMAState        currentState;
@property (nonatomic, assign) CGRect            defaultFrame;
@property (nonatomic, retain) UIView*           lastSuperView;
@property (nonatomic, retain) UIColor*          lastBackgroundColor;
@property (nonatomic, assign) CGSize            maxSize;

- (void)viewVisible:(NSNotification*)notification;
- (void)viewInvisible:(NSNotification*)notification;
- (void)invalidate:(NSNotification*)notification;
- (void)frameChanged:(NSNotification*)notification;
- (void)orientationChanged:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)handleReachabilityChangedNotification:(NSNotification *)notification;
- (void)locationDetected:(NSNotification*)notification;
- (void)headingDetected:(NSNotification*)notification;
- (void)expandViewClosed:(NSNotification*)notification;
- (void)evalJS:(NSString*)js;
- (void)click:(NSString*)url;

@end

@implementation OrmmaAdaptor

@synthesize webView, adView, expandView, nonHideState, currentState, defaultFrame, lastSuperView, lastBackgroundColor, maxSize, interstitial;

- (id)initWithWebView:(UIWebView*)view adView:(AdView*)ad {
    self = [super init];
    if (self) {
        self.webView = view;
        self.adView = ad;
        self.defaultFrame = ad.frame;
        
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(viewVisible:) name:kAdViewBecomeVisibleNotification object:nil];
		[[NotificationCenter sharedInstance] addObserver:self selector:@selector(viewInvisible:) name:kAdViewBecomeInvisibleNotification object:nil];        
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(invalidate:) name:kUnregisterAdNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(frameChanged:) name:kAdViewFrameChangedNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(locationDetected:) name:kNewLocationDetectedNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(headingDetected:) name:kLocationUpdateHeadingNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(expandViewClosed:) name:kCloseExpandNotification object:nil];
        
        // setup our network reachability        
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self
							   selector:@selector(orientationChanged:)
								   name:UIDeviceOrientationDidChangeNotification
								 object:nil];
		[notificationCenter addObserver:self 
							   selector:@selector(keyboardWillShow:) 
								   name:UIKeyboardWillShowNotification
								 object:nil];
		[notificationCenter addObserver:self 
							   selector:@selector(keyboardWillHide:) 
								   name:UIKeyboardWillHideNotification
								 object:nil];
		[notificationCenter addObserver:self
							   selector:@selector(handleReachabilityChangedNotification:)
								   name:kReachabilityChangedNotification
								 object:nil];
        
		// start up reachability notifications
        Reachability* reachability = [Reachability reachabilityForInternetConnection];
        if ([reachability respondsToSelector:@selector(startNotifier)]) {
            [reachability startNotifier];
        }
        
        [[Accelerometer sharedInstance] addDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    self.adView = nil;
    self.webView = nil;
    [[NotificationCenter sharedInstance] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[Accelerometer sharedInstance] removeDelegate:self];
    [super dealloc];
}

- (BOOL)isOrmma:(NSURLRequest *)request {
    return [[[request URL] scheme] isEqualToString:ORMMA_SHAME];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self evalJS:[OrmmaHelper signalReadyInWebView]];
}

- (NSString*)getDefaultsJSCode {
    NSMutableString* result = [NSMutableString string];
    UIDevice* device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    // Register up case 'Ormma' object
    [result appendString:[OrmmaHelper registerOrmmaUpCaseObject]];
    
    // Default state
    self.currentState = ORMMAStateDefault;
    self.nonHideState = self.currentState;
    [result appendString:[OrmmaHelper setState:self.currentState]];
    
    // Viewable
    [result appendString:[OrmmaHelper setViewable:[webView isViewVisible]]];
    
    // Network
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [result appendString:[OrmmaHelper setNetwork:[reachability currentReachabilityStatus]]];
    
    // Frame size
    [result appendString:[OrmmaHelper setSize:self.webView.frame.size]];
    
    // Max size
    UIViewController* parentVC = [self.adView viewControllerForView];
    
    if (parentVC && parentVC.view) {
        self.maxSize = parentVC.view.frame.size;
    } else {
        UIView* sv = self.adView.superview;
        if (sv) {
            self.maxSize = sv.frame.size;
        } else {
            self.maxSize = self.webView.frame.size;
        }
    }
    
    [result appendString:[OrmmaHelper setMaxSize:self.maxSize]];
    
    // Screen size
	CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
    [result appendString:[OrmmaHelper setScreenSize:screenSize]];
    
    // Default position
    [result appendString:[OrmmaHelper setDefaultPosition:self.adView.frame]];
    
    // Orientation
    [result appendString:[OrmmaHelper setOrientation:orientation]];
    
    // Placement
    [result appendString:[OrmmaHelper setPlacementInterstitial:self.interstitial]];
    
    CGFloat expandHeight = screenSize.height;
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        expandHeight -= 20.0f;
    }
    
    // Expand properties expandProperties
    [result appendString:[OrmmaHelper setExpandPropertiesWithMaxSize:CGSizeMake(screenSize.width, expandHeight)]];
    
    // Location
    SharedModel* sharedModel = [SharedModel sharedInstance];
    if (sharedModel && sharedModel.latitude && sharedModel.longitude && sharedModel.accuracy) {
        [result appendString:[OrmmaHelper setLatitude:[sharedModel.latitude floatValue] longitude:[sharedModel.longitude floatValue] accuracy:[sharedModel.accuracy floatValue]]];
    }
    
#ifdef INCLUDE_LOCATION_MANAGER
    // Heading
    if ([LocationManager headingAvailable] && [LocationManager sharedInstance].currentHeading) {
        [result appendString:[OrmmaHelper setHeading:[LocationManager sharedInstance].currentHeading.trueHeading]];
    }
#endif
    
    NSMutableArray* supports = [NSMutableArray array];
    [supports addObject:@"'level-1'"];
    [supports addObject:@"'level-2'"];
    [supports addObject:@"'level-3'"];
    [supports addObject:@"'orientation'"];
    [supports addObject:@"'network'"];
    [supports addObject:@"'screen'"];
    [supports addObject:@"'shake'"];
    [supports addObject:@"'size'"];
    [supports addObject:@"'tilt'"];
    [supports addObject:@"'audio'"];
    [supports addObject:@"'video'"];
    [supports addObject:@"'map'"];
    
	if (NSClassFromString(@"EKEventStore")) {
		[supports addObject:@"'calendar'"]; 
	}

#ifdef INCLUDE_LOCATION_MANAGER
    if ([LocationManager headingAvailable]) {
        [supports addObject:@"'heading'"];
    }
    
    if ([LocationManager sharedInstance].locationManager) {
        [supports addObject:@"'location'"];
    }
#endif
    
    if ([device.model isEqualToString:@"iPhone"]) {
        [supports addObject:@"'phone'"];
    }
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [supports addObject:@"'email'"];
        }
    }
    
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil) {
        if ([smsClass canSendText]) {
            [supports addObject:@"'sms'"];
        }
    }
    
    /*
    Class cameraClass = (NSClassFromString(@"UIImagePickerController"));
    if (cameraClass != nil) {
        if ([cameraClass isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [supports addObject:@"'camera'"];
        }
    }*/
    
    [result appendString:[OrmmaHelper setSupports:supports]];
    
    return result;
}

- (void)evalJS:(NSString*)js {
    if ([NSThread isMainThread]) {
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    } else {
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js waitUntilDone:NO];
    }
}
         
         
- (void)click:(NSString*)url {
    if (self.adView) {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, self.adView, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenURLNotification object:info];
    }
}

- (void)processEvent:(NSString*)event parameters:(NSDictionary*)parameters {
    if ([event isEqualToString:@"ormmaenabled"]) {
        //
    } else if ([event isEqualToString:@"show"]) {
        if (self.adView.hidden) {
            self.currentState = self.nonHideState;
            [self evalJS:[OrmmaHelper setState:self.currentState]];
            [self.adView setHidden:NO];
        }
    } else if ([event isEqualToString:@"hide"]) {
        self.nonHideState = self.currentState;
        self.currentState = ORMMAStateHidden;
        [self evalJS:[OrmmaHelper setState:self.currentState]];
        [self.adView setHidden:YES];
    } else if ([event isEqualToString:@"close"]) {
        // if we're in the default state already, there is nothing to do
        if (self.currentState == ORMMAStateDefault) {
            // do same as hide command
            self.nonHideState = self.currentState;
            self.currentState = ORMMAStateHidden;
            [self evalJS:[OrmmaHelper setState:self.currentState]];
            [self.adView setHidden:YES];
        } else if (self.currentState == ORMMAStateHidden) {
            // hidden ad, nothing to do
        } else if (self.currentState == ORMMAStateExpanded) {            
            if (self.expandView) {
                // we need to close expandView
                [self.expandView close];
                self.expandView = nil;
                
                self.currentState = ORMMAStateDefault;
                self.nonHideState = self.currentState;
                [self evalJS:[OrmmaHelper setState:self.currentState]];
            } else {
                self.adView.frame = [self.lastSuperView convertRect:self.adView.frame fromView:self.adView.superview];
                [self.lastSuperView addSubview:self.adView];
                self.lastSuperView = nil;
                
                self.adView.backgroundColor = self.lastBackgroundColor;
                self.lastBackgroundColor = nil;
                
                // resize to normal frame
                [UIView animateWithDuration:0.2 animations:^(void) {
                    self.adView.frame = self.defaultFrame;
                } completion:^(BOOL finished) {
                    self.currentState = ORMMAStateDefault;
                    self.nonHideState = self.currentState;
                    [self evalJS:[OrmmaHelper setState:self.currentState]];
                }];
            }
        } else {
            [UIView animateWithDuration:0.2 animations:^(void) {
                self.adView.frame = self.defaultFrame;
            } completion:^(BOOL finished) {
                self.currentState = ORMMAStateDefault;
                self.nonHideState = self.currentState;
                [self evalJS:[OrmmaHelper setState:self.currentState]];
            }];
        }
    } else if ([event isEqualToString:@"expand"]) {
        if (self.currentState != ORMMAStateDefault) {
            // Already Expanded
            [self evalJS:[OrmmaHelper fireError:@"Can only expand from the default state." forEvent:event]];
        } else {            
            NSString* url = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"url"];
            CGFloat w = [OrmmaHelper floatFromDictionary:parameters forKey:@"width"];
            CGFloat h = [OrmmaHelper floatFromDictionary:parameters forKey:@"height"];
            UIDevice* device = [UIDevice currentDevice];
            UIDeviceOrientation orientation = device.orientation;
            CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
            
            if (w > screenSize.width) {
                [self evalJS:[OrmmaHelper fireError:@"Cannot expand an ad larger than allowed." forEvent:event]];
            } else {
                if (h > screenSize.height) {
                    [self evalJS:[OrmmaHelper fireError:@"Cannot expand an ad larger than allowed." forEvent:event]];
                } else {
                    //[[NotificationCenter sharedInstance] postNotificationName:kAdStopUpdateNotification object:self.adView];
                    
                    self.currentState = ORMMAStateExpanded;
                    self.nonHideState = self.currentState;
                    [self evalJS:[OrmmaHelper setState:self.currentState]];
                    
                    BOOL useBackground = [OrmmaHelper booleanFromDictionary:parameters forKey:@"useBackground"];
                    UIColor* backgroundColor = [UIColor colorWithHexString:[[OrmmaHelper requiredStringFromDictionary:parameters forKey:@"backgroundColor"] stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                    CGFloat backgroundOpacity = [OrmmaHelper floatFromDictionary:parameters forKey:@"backgroundOpacity"];
                    
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
                    
                    if (url) {                        
                        self.expandView = [[[ExpandWebView alloc] initWithFrame:CGRectMake(0, 0, w, h)] autorelease];
                        self.expandView.adView = self.adView;
                        self.expandView.backgroundColor = expandBackgroundColor;
                        
                        [self.adView.window addSubview:self.expandView];
                        [self.expandView loadUrl:url];
                    } else {
                        // to make shure
                        self.expandView = nil;
                        self.lastBackgroundColor = self.adView.backgroundColor;
                        self.adView.backgroundColor = expandBackgroundColor;
                        
                        CGRect newFrame = [self.adView.superview convertRect:self.adView.frame toView:self.adView.window];
                        self.lastSuperView = self.adView.superview;
                        [self.adView.window addSubview:self.adView];
                        self.adView.frame = newFrame;
                        
                        CGFloat originY = 20;
                        if ([UIApplication sharedApplication].isStatusBarHidden) {
                            originY = 0;
                        }
                        
                        // resize
                        [UIView animateWithDuration:0.3 animations:^(void) {
                            self.adView.frame = CGRectMake(newFrame.origin.x, originY, w, h);
                        } completion:^(BOOL finished) {
                            [self evalJS:[OrmmaHelper setState:self.currentState]];
                        }];
                    }
                }
            }
        }
    } else if ([event isEqualToString:@"resize"]) {
        if (self.currentState != ORMMAStateDefault) {
            // Already Resized
            [self evalJS:[OrmmaHelper fireError:@"Cannot resize an ad that is not in the default state." forEvent:event]];
        } else {
            self.currentState = ORMMAStateResized;
            self.nonHideState = self.currentState;
            CGFloat w = [OrmmaHelper floatFromDictionary:parameters forKey:@"w"];
            if (w > maxSize.width) {
                [self evalJS:[OrmmaHelper fireError:@"Cannot resize an ad larger than allowed." forEvent:event]];
            } else {
                CGFloat h = [OrmmaHelper floatFromDictionary:parameters forKey:@"h"];
                if (h > maxSize.height) {
                    [self evalJS:[OrmmaHelper fireError:@"Cannot resize an ad larger than allowed." forEvent:event]];
                } else {
                    //[[NotificationCenter sharedInstance] postNotificationName:kAdStopUpdateNotification object:self.adView];
                    
                    [UIView animateWithDuration:0.2 animations:^(void) {
                        self.adView.frame = CGRectMake(self.adView.frame.origin.x, self.adView.frame.origin.y, w, h);
                    } completion:^(BOOL finished) {
                        [self evalJS:[OrmmaHelper setState:self.currentState]];
                    }];
                }
            }
        }
    } else if ([event isEqualToString:@"addasset"]) {
        //
    } else if ([event isEqualToString:@"removeasset"]) {
        //
    } else if ([event isEqualToString:@"removeallassets"]) {
        //
    } else if ([event isEqualToString:@"calendar"]) {        
        NSString *dateString = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                                  forKey:@"date"];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMMddHHmm"];
        NSDate *date = [formatter dateFromString:dateString];
        
        NSString *title = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                             forKey:@"title"];
        NSString *body = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                            forKey:@"body"];
        if (date && title && body) {
            // handle internally
            EKEventStore* eventStore = [[[EKEventStore alloc] init] autorelease];
            EKEvent* ekEvent = [EKEvent eventWithEventStore:eventStore];
            ekEvent.title = title;
            
            ekEvent.notes = body;
            
            ekEvent.startDate = date;
            ekEvent.endDate   = [[[NSDate alloc] initWithTimeInterval:600 
                                                           sinceDate:ekEvent.startDate] autorelease];
            [ekEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
            
            RIButtonItem *noItem = [RIButtonItem item];
            noItem.label = @"No";
            
            RIButtonItem *yesItem = [RIButtonItem item];
            yesItem.label = @"Yes";
            yesItem.action = ^ {
                BOOL status = [eventStore saveEvent:ekEvent 
                                               span:EKSpanThisEvent 
                                              error:nil]; 
                if (status) {
                    UIAlertView *eventSavedSuccessfully = [[[UIAlertView alloc] initWithTitle:@"Event Status" 
                                                                                     message:@"Event successfully added." 
                                                                                    delegate:nil 
                                                                           cancelButtonTitle:@"Ok" 
                                                                           otherButtonTitles:nil] autorelease];
                    [eventSavedSuccessfully show];
                } else {
                    UIAlertView *eventSavedUNSuccessfully = [[[UIAlertView alloc] initWithTitle:@"Event Status" 
                                                                                       message:@"Event not added." 
                                                                                      delegate:nil 
                                                                             cancelButtonTitle:@"Ok" 
                                                                             otherButtonTitles:nil] autorelease];
                    [eventSavedUNSuccessfully show];
                }
            };
            
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Event Status"
                                                                message:@"Do you wish to save calendar event?"
                                                       cancelButtonItem:noItem 
                                                       otherButtonItems:yesItem, nil] autorelease];
            [alertView show];         
        }
    } else if ([event isEqualToString:@"camera"]) {
        //
    } else if ([event isEqualToString:@"email"]) {
        NSString *to = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"to"];
        NSString *subject = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"subject"];
        NSString *body = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"body"];
        BOOL html = [OrmmaHelper booleanFromDictionary:parameters forKey:@"html"];
        if (body && to && subject) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *vc = [[[MFMailComposeViewController alloc] init] autorelease];
                NSArray *recipients = [NSArray arrayWithObject:to];
                [vc setToRecipients:recipients];
                [vc setSubject:subject];
                [vc setMessageBody:body  isHTML:html];
                vc.mailComposeDelegate = self;
                
                UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
                if (!rvc) {
                    rvc = [[UIApplication sharedApplication].keyWindow viewControllerForView];
                }
                if (!rvc) {
                    rvc = [self.adView viewControllerForView];
                }
                [rvc presentModalViewController:vc animated:YES];
            } else {
                [self evalJS:[OrmmaHelper fireError:@"Cannot send email: device mailbox not configured." forEvent:event]];
            }
        } else {
            [self evalJS:[OrmmaHelper fireError:@"Cannot send email: body, subject and to are required." forEvent:event]];
        }
    } else if ([event isEqualToString:@"phone"]) {
        NSString *phoneNumber = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                                   forKey:@"number"];
        [self click:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
    } else if ([event isEqualToString:@"sms"]) {
        NSString *to = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"to"];
        NSString *body = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"body"];
        if (body && to && NSClassFromString(@"MFMessageComposeViewController") && [MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *vc = [[[MFMessageComposeViewController alloc] init] autorelease];
            NSArray *recipients = [NSArray arrayWithObject:to];
            vc.recipients = recipients;
            vc.body = body;
            vc.messageComposeDelegate = self;
            
            UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (!rvc) {
                rvc = [[UIApplication sharedApplication].keyWindow viewControllerForView];
            }
            if (!rvc) {
                rvc = [self.adView viewControllerForView];
            }
            [rvc presentModalViewController:vc animated:YES];
        }
    } else if ([event isEqualToString:@"open"]) {
        NSString *url = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                           forKey:@"url"];
        [self click:url];
    } else if ([event isEqualToString:@"openmap"]) {
        NSString *poi = [OrmmaHelper requiredStringFromDictionary:parameters 
                                                           forKey:@"url"];
        [self click:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", [poi stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else if ([event isEqualToString:@"playaudio"]) {
        NSString *url = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"url"];
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:url forKey:@"url"];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:parameters forKey:@"properties"];
        [[NotificationCenter sharedInstance] postNotificationName:kPlayAudioNotification object:info];
    } else if ([event isEqualToString:@"playvideo"]) {
        NSString *url = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"url"];
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:url forKey:@"url"];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:parameters forKey:@"properties"];
        [[NotificationCenter sharedInstance] postNotificationName:kPlayVideoNotification object:info];
    } else if ([event isEqualToString:@"request"]) {
        NSString *uri = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"uri"];
        NSString *display = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"display"];
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:uri]];
        
        if ([display isEqualToString:@"proxy"]) {
            Reachability* reachability = [Reachability reachabilityForInternetConnection];
            if ([reachability currentReachabilityStatus] == NotReachable) {
                [ObjectStorage objectForKey:uri block:^(id obj) {
                    NSData* cachedData = obj;
                    if (cachedData) {
                        [self evalJS:[OrmmaHelper fireResponseEvent:cachedData uri:uri]];
                    }
                }];
            } else {
                [NetworkQueue loadWithRequest:req completion:^(NSURLRequest *r, NSHTTPURLResponse *response, NSData *data, NSError *error) {
                    if (!error) {
                        [self evalJS:[OrmmaHelper fireResponseEvent:data uri:uri]];
                        [ObjectStorage storeObject:data key:uri];
                    }
                }];
            }
        } else if ([display isEqualToString:@"ignore"]) {
            [NetworkQueue loadWithRequest:req completion:^(NSURLRequest *r, NSHTTPURLResponse *response, NSData *data, NSError *error) {
                if (!error) {
                    [ObjectStorage storeObject:data key:uri];
                }
            }];
        } else {
            [NetworkQueue loadWithRequest:req completion:^(NSURLRequest *r, NSHTTPURLResponse *response, NSData *data, NSError *error) {
                if (!error) {
                    [self evalJS:[OrmmaHelper fireResponseEvent:data uri:uri]];
                }
            }];
        }
    } else if ([event isEqualToString:@"service"]) {
        NSString *name = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"name"];
        NSString *enabled = [OrmmaHelper requiredStringFromDictionary:parameters forKey:@"enabled"];
        if ([name isEqualToString:@"headingChange"] && [enabled isEqualToString:@"Y"]) {
            [[LocationManager sharedInstance] startUpdatingHeading];
        }
    }
    
    // send callback
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    [info setObject:self.adView forKey:@"adView"];
    [info setObject:event forKey:@"event"];
    [info setObject:parameters forKey:@"dic"];
    [[NotificationCenter sharedInstance] postNotificationName:kORMMAEventNotification object:info];
}

- (void)moveToDefaultState {
    if (self.currentState == ORMMAStateResized || self.currentState == ORMMAStateExpanded) {
        [self processEvent:@"close" parameters:[NSDictionary dictionary]];
    }
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        NSLog(@"Dev log: %@", [[request URL] absoluteString]);
        
        // notify JS that we've completed the last request
        NSString* event = [[[request URL] host] lowercaseString];
        NSDictionary* parameters = [OrmmaHelper parametersFromJSCall:[[request URL] query]];
        [self evalJS:[OrmmaHelper nativeCallComplete:event]];
        
        [self processEvent:event parameters:parameters];
    }
}

- (void)viewVisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        [self evalJS:[OrmmaHelper setViewable:YES]];
	}
}

- (void)viewInvisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        [self evalJS:[OrmmaHelper setViewable:NO]];
	}
}

- (void)invalidate:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.adView = nil;
        self.webView = nil;
		[[NotificationCenter sharedInstance] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[Accelerometer sharedInstance] removeDelegate:self];
	}
}

- (void)frameChanged:(NSNotification*)notification {
    NSDictionary* info = [notification object];
	AdView* adViewNotify = [info objectForKey:@"adView"];
    if (adViewNotify == self.adView) {
        NSValue* frameValue = [info objectForKey:@"newFrame"];
        CGRect newFrame = [frameValue CGRectValue];
        
        if (self.currentState != ORMMAStateResized && self.currentState != ORMMAStateExpanded) {
            self.defaultFrame = newFrame;
        }
        
        [self evalJS:[OrmmaHelper setSize:newFrame.size]];
        [self evalJS:[OrmmaHelper setDefaultPosition:newFrame]];
	}
}


#pragma mark - Notification Center Dispatch Methods


- (void)orientationChanged:(NSNotification *)notification {
	UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    [self evalJS:[OrmmaHelper setOrientation:orientation]];
    
	CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
    [self evalJS:[OrmmaHelper setScreenSize:screenSize]];
    
    // TODO
    //[self.bridgeDelegate rotateExpandedWindowsToCurrentOrientation];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [self evalJS:[OrmmaHelper setKeyboardShow:true]];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [self evalJS:[OrmmaHelper setKeyboardShow:false]];
}


- (void)handleReachabilityChangedNotification:(NSNotification *)notification {
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
	[self evalJS:[OrmmaHelper setNetwork:[reachability currentReachabilityStatus]]];
}

- (void)locationDetected:(NSNotification*)notification {
#ifdef INCLUDE_LOCATION_MANAGER
    CLLocation* location = [notification object];
    [self evalJS:[OrmmaHelper setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude accuracy:location.horizontalAccuracy]];
#endif   
}

- (void)headingDetected:(NSNotification*)notification {
#ifdef INCLUDE_LOCATION_MANAGER
    CLHeading* heading = [notification object];
    [self evalJS:[OrmmaHelper setHeading:heading.trueHeading]];
#endif
}

- (void)expandViewClosed:(NSNotification*)notification {
    NSDictionary* info = [notification object];
	AdView* adViewNotify = [info objectForKey:@"adView"];
    if (adViewNotify == self.adView) {
        self.currentState = ORMMAStateDefault;
        self.nonHideState = self.currentState;
        [self evalJS:[OrmmaHelper setState:self.currentState]];
	}
}


#pragma mark - Accelerometer Delegete

         
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// Send accelerometer data
    [self evalJS:[OrmmaHelper setTilt:acceleration]];
	
	// Deal with shakes
    BOOL shake = NO;
    CGFloat kDefaultShakeIntensity = 1.5;
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if (shake) {
        // Shake detected
        [self evalJS:[OrmmaHelper fireShakeEventInWebView]];
    }
}


#pragma mark - MFMessageComposeViewController Delegete


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rvc) {
        rvc = [[UIApplication sharedApplication].keyWindow viewControllerForView];
    }
    if (!rvc) {
        rvc = [self.adView viewControllerForView];
    }
    [rvc dismissModalViewControllerAnimated:YES];
}


#pragma mark - MFMailComposeViewController Delegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIViewController* rvc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rvc) {
        rvc = [[UIApplication sharedApplication].keyWindow viewControllerForView];
    }
    if (!rvc) {
        rvc = [self.adView viewControllerForView];
    }
    [rvc dismissModalViewControllerAnimated:YES];
}


@end
