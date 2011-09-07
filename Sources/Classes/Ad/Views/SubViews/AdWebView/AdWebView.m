//
//  AdWebView.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "AdWebView.h"
#import "NotificationCenter.h"
#import "UIWebViewAdditions.h"

#import "Utils.h"
#import "Constants.h"

#import "VideoView.h"

@implementation AdWebView

@synthesize adView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width == 0.0 && frame.size.height == 0.0) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, 0, 1);
        }
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		_webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_webView disableBouncesForWebView];
		
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];

		[self addSubview:_webView];

        _defaultFrame = self.frame;
        _javascriptBridge = [[ORMMAJavascriptBridge alloc] init];
        _javascriptBridge.bridgeDelegate = self;
    }
    return self;
}

- (void)dealloc {
    _javascriptBridge.bridgeDelegate = nil;
    [_javascriptBridge release];
	RELEASE_SAFELY(_webView);
	if (_player) {
        [_player stop];
        [_player release];
    }
    
    [super dealloc];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL
{
    [_webView loadData:data MIMEType:MIMEType textEncodingName:encodingName baseURL:baseURL];
}

#pragma mark -
#pragma mark Utility Methods

- (NSInteger)angleFromOrientation:(UIDeviceOrientation)orientation
{
	NSInteger orientationAngle = -1;
	switch ( orientation )
	{
		case UIDeviceOrientationPortrait:
			orientationAngle = 0;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			orientationAngle = 180;
			break;
		case UIDeviceOrientationLandscapeLeft:
			orientationAngle = 270;
			break;
		case UIDeviceOrientationLandscapeRight:
			orientationAngle = 90;
			break;
		default:
			orientationAngle = -1;
			break;
	}
	return orientationAngle;
}

- (void)fireViewableChange
{
    NSString *isDisplayed = @"false";
    if(self.hidden)
    {
        isDisplayed = @"true";
    }
    [self usingWebView:_webView executeJavascript:@"window.ormmaview.fireChangeEvent({viewable:'%@'});", isDisplayed];
}

#pragma mark -
#pragma mark Rotation

- (void)rotateExpandedWindowsToOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat angle = 0.0;
    
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI; 
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI_2; // / 2.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2; // / 2.0f;
            break;
        default: // as UIInterfaceOrientationPortrait
            angle = 0.0;
            break;
    } 
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (UIInterfaceOrientation)currentInterfaceOrientation
{
    // Use device orientation not the statusBarOrientation because the device orientation is being set more accurately.
    // Important when rapidly rotating the device.
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    if((UIDeviceOrientationPortrait != orientation) &&
       (UIDeviceOrientationPortraitUpsideDown != orientation) &&
       (UIDeviceOrientationLandscapeLeft != orientation) &&
       (UIDeviceOrientationLandscapeRight != orientation))
    {
        // Orientation is not of the interface orientation.
        UIApplication *app = [UIApplication sharedApplication];
        orientation = app.statusBarOrientation;
        
    }
    return orientation;
}

- (CGRect)webFrameAccordingToOrientation:(CGRect)rect
{
    CGRect webFrame = CGRectZero;
    UIInterfaceOrientation orientation = [self currentInterfaceOrientation];
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        webFrame = CGRectMake( 0, 0, rect.size.width, rect.size.height );
    }
    else
    {
        webFrame = CGRectMake( 0, 0, rect.size.height, rect.size.width );
    }
    return webFrame;
}

- (CGRect)rectAccordingToOrientation:(CGRect)rect
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow      *keyWindow = [app keyWindow];
	CGFloat statusBarHeight = 0;
    if ( !app.statusBarHidden )
	{
        // status bar is visible
        statusBarHeight = 20.0;
	}
    UIInterfaceOrientation orientation = [self currentInterfaceOrientation];
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            rect.origin.y = keyWindow.frame.size.height - rect.origin.y - rect.size.height;
            rect.origin.x = keyWindow.frame.size.width - rect.origin.x - rect.size.width;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rect = CGRectMake(keyWindow.frame.size.height - rect.origin.y - rect.size.height, rect.origin.x, rect.size.height, rect.size.width);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rect = CGRectMake(rect.origin.y, keyWindow.frame.size.width - rect.origin.x - rect.size.width, rect.size.height, rect.size.width);
            break;
        default: // as UIInterfaceOrientationPortrait
            break;
    }
    return rect;
}



- (CGRect)convertedRectAccordingToOrientation:(CGRect)rect
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow      *keyWindow = [app keyWindow];
    
    UIInterfaceOrientation orientation = [self currentInterfaceOrientation];
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            rect.origin.y = keyWindow.frame.size.height - rect.origin.y - rect.size.height;
            rect.origin.x = keyWindow.frame.size.width - rect.origin.x - rect.size.width;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rect = CGRectMake(rect.origin.y, keyWindow.frame.size.height - rect.origin.x - rect.size.width, rect.size.height, rect.size.width);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rect = CGRectMake(keyWindow.frame.size.width - rect.origin.y - rect.size.height, rect.origin.x, rect.size.height, rect.size.width);
            break;
        default: // as UIInterfaceOrientationPortrait
            break;
    }
    return rect;
}


- (CGSize)statusBarSize:(CGSize)size accordingToOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

#pragma mark -
#pragma mark Constants

NSString * const kAnimationKeyExpand = @"expand";
NSString * const kAnimationKeyCloseExpanded = @"closeExpanded";

NSString * const kInitialORMMAPropertiesFormat = @"{ state: '%@'," \
" network: '%@',"\
" size: { width: %f, height: %f },"\
" maxSize: { width: %f, height: %f },"\
" screenSize: { width: %f, height: %f },"\
" defaultPosition: { x: %f, y: %f, width: %f, height: %f },"\
" orientation: %i,"\
" supports: [ 'level-1', 'orientation', 'network', 'heading', 'location', 'screen', 'shake', 'size', 'tilt', 'sms', 'phone', 'email', 'audio', 'video', 'map'%@ ] }";

NSString * const kDefaultPositionORMMAPropertiesFormat = @"{ defaultPosition: { x: %f, y: %f, width: %f, height: %f }, size: { width: %f, height: %f } }";

#pragma mark -
#pragma mark Javascript Bridge Delegate

- (UIWebView *)webView
{
	return _webView;
}


- (void)adIsORMMAEnabledForWebView:(UIWebView *)webView
{
	//self.isOrmmaAd = YES;
}

- (NSString *)usingWebView:(UIWebView *)webView
		 executeJavascript:(NSString *)javascript
			   withVarArgs:(va_list)args
{
	NSString *js = [[[NSString alloc] initWithFormat:javascript arguments:args] autorelease];
	//NSLog( @"Executing Javascript: %@", js );
	return [webView stringByEvaluatingJavaScriptFromString:js];
}

- (NSString *)usingWebView:(UIWebView *)webView
		 executeJavascript:(NSString *)javascript, ...
{
	// handle variable argument list
	va_list args;
	va_start( args, javascript );
	NSString *result = [self usingWebView:webView executeJavascript:javascript withVarArgs:args];
	va_end( args );
	return result;
}

#pragma mark -
#pragma mark ORMMAJavascriptBridgeDelegate

- (void)showAd:(UIWebView *)webView
{
     //NSLog(@"AdWebView _javascriptBridge.showAdf");
}

- (void)hideAd:(UIWebView *)webView
{
     //NSLog(@"AdWebView _javascriptBridge.hideAd");
}

- (void)closeAd:(UIWebView *)webView
{
    //NSLog(@"AdWebView _javascriptBridge.closeAd");
    [self setFrame:_defaultFrame];
    [_webView setFrame:self.frame];
}

- (void)resizeToWidth:(CGFloat)width height:(CGFloat)height inWebView:(UIWebView *)webView;
{
    //NSLog(@"AdWebView _javascriptBridge.resizeToWidth w = %f, h = %f",width,height);
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
    [_webView setFrame:self.frame];
}

- (void)openBrowser:(UIWebView *)webView withUrlString:(NSString *)urlString enableBack:(BOOL)back enableForward:(BOOL)forward enableRefresh:(BOOL)refresh
{
    //NSLog(@"AdWebView _javascriptBridge.openBrowser url = %@, enableBack = %d, enableForward = %d, enableRefresh = %d", urlString, back, forward, refresh);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)expandTo:(CGRect)newFrame
		 withURL:(NSURL *)url
	   inWebView:(UIWebView *)webView
   blockingColor:(UIColor *)blockingColor
 blockingOpacity:(CGFloat)blockingOpacity
 lockOrientation:(BOOL)allowOrientationChange
{
    [self setFrame:newFrame];
    [_webView setFrame:self.frame];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)openMap:(UIWebView *)webView
  withUrlString:(NSString *)urlString
  andFullScreen:(BOOL)fullscreen
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)playAudio:(UIWebView *)webView
    withUrlString:(NSString *)urlString
         autoPlay:(BOOL)autoplay
         controls: (BOOL)controls
             loop: (BOOL)loop
         position: (BOOL)position
       startStyle:(NSString *)startStyle
        stopStyle:(NSString *) stopStyle
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)playVideo:(UIWebView *)webView
    withUrlString:(NSString *)urlString
       audioMuted: (BOOL)mutedAudio
         autoPlay:(BOOL)autoplay
         controls: (BOOL)controls
             loop: (BOOL)loop
         position:(int[4]) pos
       startStyle:(NSString *)startStyle
        stopStyle:(NSString *) stopStyle
{
    if (_player == nil)
    {
        _player = [[MPMoviePlayerController alloc] init];       
    }
    [_player setRepeatMode:MPMovieRepeatModeOne];
    [_player setScalingMode:MPMovieScalingModeFill];
    [_player setContentURL:[NSURL URLWithString:urlString]];
    if (pos[0]>-1 && pos[1]>-1 && pos[2]>-1 && pos[3]>-1)
    {
        _player.view.frame = CGRectMake(pos[0], pos[1], pos[2], pos[3]);       
    }
    [self setFrame:_player.view.frame];
    _player.movieSourceType = MPMovieSourceTypeFile;
    [self addSubview:_player.view];
    //[_player play];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self injectORMMAStateIntoWebView:webView];
    
    if (self.superview)
    {
        NSString* contentWidth = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('contentwidth').offsetWidth"];
        NSString* contentHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('contentheight').offsetHeight"];
        
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [senfInfo setObject:contentWidth forKey:@"contentWidth"];
        [senfInfo setObject:contentHeight forKey:@"contentHeight"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (adView) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:adView forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDisplayNotification object:senfInfo];
    }
    //ORMMA
    /*NSLog( @"Failed to load URL into Web View: %@", error );

	if ( ( self.ormmaDelegate != nil ) && 
		( [self.ormmaDelegate respondsToSelector:@selector(failureLoadingAd:)] ) )
	{
		[self.ormmaDelegate failureLoadingAd:self];
	}
	m_loadingAd = NO;*/
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //ORMMA
    
    NSURL *url = [request URL];
	//NSLog( @"Verify Web View should load URL: %@", url );
    
	if ( [request.URL isFileURL] )
	{
		// Direct access to the file system is disallowed
		return NO;
	}
  
	// normal ad
	if ( [_javascriptBridge processURL:url forWebView:webView] )
	{
		// the bridge processed the url, nothing else to do
		return NO;
	}
	
	// handle mailto and tel
	NSString *scheme = url.scheme;
	if ( [@"mailto" isEqualToString:scheme] )
	{
        /*
		// handle mail to
		NSLog( @"MAILTO: %@", url );
		NSString *addr = [url.absoluteString substringFromIndex:7];
		if ( [addr hasPrefix:@"//"] )
		{
			NSString *addr = [addr substringFromIndex:2];
		}
		
		[self sendEMailTo:addr withSubject:nil withBody:nil isHTML:NO];
		*/
		//return NO;
	}
	else if ( [@"tel" isEqualToString:scheme] )
	{
		// handle telephone call
		//UIApplication *app = [UIApplication sharedApplication];
		//[app openURL:url];
		//return NO;
	}
	
	
    // for all other cases, just let the web view handle it
	/*NSLog( @"Perform Normal process for URL." );
	return YES;*/

    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if (adView) {
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, adView, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
            
            [[NotificationCenter sharedInstance] postNotificationName:kOpenURLNotification object:info];
        }
        
		return NO;
	}
	else if (navigationType == UIWebViewNavigationTypeOther){
		return YES;
	}
    
	return NO;
}

@end