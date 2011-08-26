//
//  AdDescriptorHelper.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import "AdDescriptorHelper.h"


@implementation AdDescriptorHelper

+ (BOOL)isMedialetsContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"medialets:launchAd?"];
	
	return textRange.location != NSNotFound;
}

+ (BOOL)isVideoContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<video"];
	
	return textRange.location != NSNotFound;
}


+ (BOOL)isExternalCampaign:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<!-- client_side_external_campaign"];
	
	return textRange.location != NSNotFound;
}

+ (NSString*)stringByStrippingHTMLcomments:(NSString *)html {
    NSScanner *thescanner;
    NSString *text = nil;
    
    if ([html rangeOfString:@"<!--//"].location == NSNotFound) {
        thescanner = [NSScanner scannerWithString:html];
        
        while ([thescanner isAtEnd] == NO) {
            
            // find start of tag
            [thescanner scanUpToString:@"<!--" intoString:nil] ; 
            
            // find end of tag
            [thescanner scanUpToString:@"-->" intoString:&text] ;
            
            // replace the found tag with a space
            //(you can filter multi-spaces out later if you wish)
            html = [html stringByReplacingOccurrencesOfString:
                    [NSString stringWithFormat:@"%@-->", text] withString:@""];
            
        } // while //
    }
    
    return html;	
}

#pragma mark kJavaScriptOrmma2
NSString * const kJavaScriptOrmma2 = 
@"\nORMMA_STATE_UNKNOWN  = \"unknown\";\n"
"ORMMA_STATE_HIDDEN   = \"hidden\";"
"ORMMA_STATE_DEFAULT  = \"default\";"
"ORMMA_STATE_EXPANDED = \"expanded\";"
"ORMMA_STATE_RESIZED = \"resized\";"

"ORMMA_EVENT_ERROR = \"error\";\n"
"ORMMA_EVENT_HEADING_CHANGE = \"headingChange\";\n"
"ORMMA_EVENT_KEYBOARD_CHANGE = \"keyboardChange\";\n"
"ORMMA_EVENT_LOCATION_CHANGE = \"locationChange\";\n"
"ORMMA_EVENT_NETWORK_CHANGE = \"networkChange\";\n"
"ORMMA_EVENT_ORIENTATION_CHANGE = \"orientationChange\";\n"
"ORMMA_EVENT_READY = \"ready\";\n"
"ORMMA_EVENT_RESPONSE = \"response\";\n"
"ORMMA_EVENT_SCREEN_CHANGE = \"screenChange\";\n"
"ORMMA_EVENT_SHAKE = \"shake\";\n"
"ORMMA_EVENT_SIZE_CHANGE = \"sizeChange\";\n"
"ORMMA_EVENT_STATE_CHANGE = \"stateChange\";\n"
"ORMMA_EVENT_TILT_CHANGE = \"tiltChange\";\n"


"(function() {\n"
"window.Ormma = {\n"
"events : [],\n"
"dimensions : {},\n"
"expandProperties :  {\n"
"\"use-background\":false,\n"
"\"background-color\" : \"#000000\",\n"
"\"background-opacity\" : 1.0,\n"
"\"is-modal\" : true},\n"


"shakeProperties : {"
"\"interval\" : \"10\","
"\"intensity\" : \"20\""
"},"

"resizeProperties : {\n"
"transition : ORMMA_STATE_UNKNOWN \n"
"},\n"

"state : ORMMA_STATE_DEFAULT,\n"
"lastState : ORMMA_STATE_DEFAULT,\n"

"addEventListener : function (event, listener) {\n"
"if (typeof listener == 'function') {\n"
"if (!this.events[event]) {\n"
"this.events[event] = [];\n"
"}\n"
"if (!this.events[event].listeners) {\n"
"this.events[event].listeners = [];\n"
"}\n"
"if (getListenerIndex(event, listener) === -1) {\n"
"this.events[event].listeners.splice(0, 0, listener);\n"
"}\n"
"}\n"
"},\n"

"removeEventListener : function (event, listener) {\n"
"if (typeof listener == 'function' && this.events[event] && this.events[event].listeners) {\n"
"var listenerIndex = getListenerIndex(event, listener);\n"
"if (listenerIndex !== -1) {\n"
"this.events[event].listeners.splice(listenerIndex, 1);\n"
"}\n"
"}\n"
"},\n"

"expand : function (dimensions, URL){\n"

"this.dimensions = dimensions;\n"
"_expand(dimensions, URL, this.expandProperties);\n"
"var data = { dimensions : dimensions,\n"
"properties : this.expandProperties };\n"
"Ormma.fireEvent('sizeChange', data);\n"
"Ormma.fireEvent('stateChange', ORMMA_STATE_HIDDEN);\n"
"},\n"

"unexpand : function (){\n"
"Ormma.fireEvent('stateChange', ORMMA_STATE_DEFAULT);\n"
"},\n"

"resize : function (width, height) {\n"
"_resize(width, height);\n"

"var data = { dimensions : {width : width, height: height},\n"
"properties : this.expandProperties };\n"
"Ormma.fireEvent(ORMMA_EVENT_SIZE_CHANGE, data);\n"
"Ormma.fireEvent(ORMMA_EVENT_STATE_CHANGE, ORMMA_STATE_RESIZED);\n"
"},\n"

"getResizeProperties: function() {\n"
"return this.resizeProperties;\n"
"},\n"

"setResizeProperties: function(properties) {\n"
"this.resizeProperties = properties;\n"
"},\n"
"getExpandProperties: function() {\n"
"return this.expandProperties;\n"
"},\n"

"setExpandProperties: function(properties) {\n"
"this.expandProperties = properties;\n"
"},\n"

"close : function () {\n"
"_close();\n"
"Ormma.fireEvent(ORMMA_EVENT_STATE_CHANGE, ORMMA_STATE_DEFAULT);\n"
"},\n"

"open : function (URL, controls) {\n"
"_open(URL, controls);\n"
"Ormma.fireEvent(ORMMA_EVENT_STATE_CHANGE, ORMMA_STATE_DEFAULT);\n"
"},\n"

"hide : function() {\n"
"_hide();\n"
"Ormma.fireEvent(ORMMA_EVENT_STATE_CHANGE, ORMMA_STATE_HIDDEN);\n"
"},\n"

"show : function() {\n"
"_show();\n"
"Ormma.fireEvent(ORMMA_EVENT_STATE_CHANGE, this.lastState);\n"
"},\n"
"getState : function() {\n"
"return this.state;\n"
"},\n"

"setState : function(state) {\n"
"this.state = state;\n"
"},\n"

"/* Level-2 */\n"
"getHeading: function() {\n"
"return _getHeading();\n"
"},\n"

"getLocation: function() {\n"
"return _getLocation();\n"
"},\n"

"getNetwork: function() {\n"
"return _getNetwork();\n"
"},\n"

"getTilt: function() {\n"
"return _getTilt();\n"
"},\n"

"getResizeDimensions: function() {\n"
"return dimensions;\n"
"},\n"

"getExpandProperties: function() {\n"
"return this.expandProperties;\n"
"},\n"

"getScreenSize: function() {\n"
"return _getScreenSize();\n"
"},\n"

"getShakeProperties: function() {\n"
"return _getShakeProperties();\n"
"},\n"

"getSize: function() {\n"
"return _getSize();\n"
"},\n"

"getMaxSize: function() {\n"
"return _getMaxSize();\n"
"},\n"

"supports: function(feature) {\n"
"return _supports(feature);\n"
"},\n"

"getResizeProperties: function() {\n"
"return this.resizeProperties;\n"
"},\n"

"setResizeProperties: function(properties) {\n"
"this.resizeProperties = properties;\n"
"},\n"
"getExpandProperties: function() {\n"
"return this.expandProperties;\n"
"},\n"

"setExpandProperties: function(properties) {\n"
"this.expandProperties = properties;\n"
"},\n"

"fireError: function(action, message){\n"
"var data = { message : message,\n"
"action : action };\n"
"Ormma.fireEvent(ORMMA_EVENT_ERROR, data);\n"
"},\n"

"/*Level-2*/\n"
"sendSMS: function(recipient, body){\n"
"_sendSMS(recipient, body);\n"
"},\n"

"sendMail: function(recipient,subject,body){\n"
"//window.external.sendMail(recipient,subject,body);\n"
"},\n"

"makeCall: function(number){\n"
"_makeCall(number);\n"
"},\n"

"storePicture: function( url)\n"
"{\n"
"_storePicture(url);\n"
"},\n"

"createEvent: function(date, title, body)\n"
"{\n"
"//window.external.createEvent(date,title,body);\n"
"},\n"

"/*Level-3*/\n"
"addAsset: function( url, alias )\n"
"{\n"
"_addAsset( url, alias );\n"
"},\n"

"addAssets: function( assets )\n"
"{\n"
"_addAssets( assets );\n"
"},\n"

"getAssetURL: function( alias )\n"
"{\n"
"return _getAssetURL( alias );\n"
"},\n"

"getCacheRemaining: function()\n"
"{\n"
"return _getCacheRemaining();\n"
"},\n"

"removeAllAssets: function()\n"
"{\n"
"_removeAllAssets();\n"
"},\n"

"removeAsset: function( alias )\n"
"{\n"
"_removeAsset( alias );\n"
"},\n"

"request: function( val, prx )\n"
"{\n"
"return _request( val, prx );\n"
"},\n"

"playVideo: function(URL, properties) {"
"_playVideo(URL, properties);"
"},\n"

"playAudio: function(URL, properties) {"
"_playAudio(URL, properties);"
"},\n"

"openMap: function(URL, properties) {"
"_openMap(URL, properties);"
"},\n"

"fireEvent: function (event, args) {\n"
"var len, i;\n"
"if (Ormma.events[event] && Ormma.events[event].listeners) {\n"
"len = Ormma.events[event].listeners.length;\n"
"for (i = len-1; i >= 0; i--) {\n"
"(Ormma.events[event].listeners[i])(event, args);\n"
"}\n"
"}\n"
"}\n"
"};\n"



"function getListenerIndex (event, listener) {\n"
"var len, i;\n"
"if (Ormma.events[event] && Ormma.events[event].listeners) {\n"
"len = Ormma.events[event].listeners.length;\n"
"for (i = len-1;i >= 0;i--) {\n"
"if (Ormma.events[event].listeners[i] === listener) {\n"
"return i;\n"
"}\n"
"}\n"
"}\n"
"return -1;\n"
"}\n"


"/* implementations of public methods for specific vendors */\n"

"function _expand(dimensions, URL, properties) {\n"
"window.location = \"ios_ormma://expand?url=\"+URL+\"&\"+convertJsonToUrlStringPerametrs(dimensions);\n"
"//window.external.expand(convertJsonToString(dimensions), URL, properties);\n"
"}\n"

"function _open(URL, controls) {\n"
"//window.location = \"ios_ormma://open?url=\"+URL+\"&back=\"+controls[0]+\"&forward=\"+controls[1]+\"&refresh=\"+controls[2];\n"
"window.location = \"ios_ormma://open?url=\"+URL;\n"
"//window.external.open(URL);\n"
"}\n"

"function _resize (width, height) {\n"
"window.location = \"ios_ormma://resize?w=\" + width + \"&h=\" + height;\n"
"//window.external.resize(width, height);\n"
"}\n"

"function _close () {\n"
"window.location = \"ios_ormma://close\";\n"
"//window.external.close();\n"
"}\n"

"function _hide() {\n"
"window.location = \"ios_ormma://hide\";\n"
"//window.external.hide();\n"
"}\n"

"function _show() {\n"
"window.location = \"ios_ormma://show\";\n"
"\n"
"}\n"

"function _storePicture(url) {\n"
"\n"
"}\n"

"function _addAsset( url, alias )\n"
"{\n"
"\n"
"}\n"

"function _addAssets( assets )\n"
"{\n"
"\n"
"}\n"

"function _getAssetURL( alias )\n"
"{\n"
"\n"
"}\n"

"function _removeAllAssets()\n"
"{\n"
"\n"
"}\n"

"function _removeAsset(alias)\n"
"{\n"
"\n"
"}\n"

"function _getCacheRemaining()\n"
"{\n"
"\n"
"}\n"

"function _getMaxSize(){\n"
"\n"
"}\n"

"function _getSize(){\n"
"\n"
"}\n"

"function _supports(feature){\n"
"return 1;\n"
"}\n"

"function _getScreenSize() {\n"
"\n"
"}\n"

"function _request(val, prx) {\n"
"return \"\";window.external.request(val,prx);\n"
"}\n"

"function _playVideo(URL, properties) {\n"
"//window.location = \"ios_ormma://playvideo?url=\"+URL+\"&\"+convertJsonToUrlStringPerametrs(properties);\n"
"var audioMuted = false, autoPlay = false, controls = false, loop = false, position = [-1, -1, -1, -1], startStyle = 'normal', stopStyle = 'normal';\n"
"if ( properties != null ) {\n"
"if ( ( typeof properties.audio != \"undefined\" ) && ( properties.audio != null ) ) {\n"
"    audioMuted = true;\n"
"    }\n"
"    if ( ( typeof properties.autoplay != \"undefined\" ) && ( properties.autoplay != null ) ) {\n"
"        autoPlay = true;\n"
"    }\n"
"if ( ( typeof properties.controls != \"undefined\" ) && ( properties.controls != null ) ) {\n"
"       controls = true;\n"
"}\n"
"    if ( ( typeof properties.loop != \"undefined\" ) && ( properties.loop != null ) ) {\n"
"        loop = true;\n"
"   }\n"
"    if ( ( typeof properties.position != \"undefined\" ) && ( properties.position != null ) ) {\n"
"         position = new Array(4);\n"
"        position[0] = properties.position.top;\n"  
"        position[1] = properties.position.left;\n"
"        if ( ( typeof properties.width != \"undefined\" ) && ( properties.width != null ) ) {\n"
"            position[2] =  properties.width;\n"
"        }\n"
"        else{\n"
"        }\n"
"        if ( ( typeof properties.height != \"undefined\" ) && ( properties.height != null ) ) {\n"
"            position[3] =  properties.height;\n"
"        }\n"
"        else{\n"
"        }\n"
"    }\n"
"    if ( ( typeof properties.startStyle != \"undefined\" ) && ( properties.startStyle != null ) ) {\n"
"       startStyle = properties.startStyle;\n"
"    }\n"
"    if ( ( typeof properties.stopStyle != \"undefined\" ) && ( properties.stopStyle != null ) ) {\n"
"stopStyle = properties.stopStyle;\n"
"    }\n"
"    if (loop) {\n"
"        stopStyle = 'normal';\n"
"        controls = true;\n"
"    }\n"
"    if (!autoPlay)\n"
"        controls = true;\n"
"    if (!controls) {\n"
"        stopStyle = 'exit';\n"
"    } \n"
"    if(position[0]== -1 || position[1] == -1)   {\n"
"        startStyle = \"fullscreen\";\n"
"}\n"
"}\n"
"window.location = \"ios_ormma://playvideo?url=\"+URL+\"&audiomuted=\"+audioMuted+\"&autoplay=\"+autoPlay+\"&controls=\"+controls+\"&loop=\"+loop+\"&position_top=\"+position[0]+\"&position_left=\"+position[1]+\"&position_width=\"+position[2]+\"&position_height=\"+position[3] +\"&startStyle=\"+startStyle+\"&stopStyle=\"+stopStyle;\n"   
"}\n"

"function _playAudio(URL, properties) {\n"
"//window.location = \"ios_ormma://playaudio?url=\"+URL+convertJsonToUrlStringPerametrs(properties);\n"
"}\n"

"function _openMap(URL, properties) {\n"
"window.location = \"ios_ormma://openmap?url=\"+URL+\"&\"+convertJsonToUrlStringPerametrs(properties);\n"
"}\n"

"function convertJsonToUrlStringPerametrs(jsonData)"
"{\n"
"  var res = '';\n"
"  for(var key in jsonData)"
"  {\n"
"    if (res == '') {res = key + \"=\"+ jsonData[key];}"
"    else"
"      res += \"&\" + key + \"=\"+ jsonData[key];\n"
"  }\n"
"  return res;\n"
"}\n"

"function convertJsonToString(jsonData){\n"
"var res = '{';\n"

"for(var key in jsonData) {\n"
"res += '\"' + key + '\"';\n"
"res += ': ';\n"
"res += '\"' + jsonData[key] + '\"';\n"
"res += ', ';\n"
"}\n"

"res += '}';\n"
"return res; \n"
"}\n"
"})();\n"

"function _fireOrmmaAssetReady( alias )\n"
"{\n"
"Ormma.fireEvent('assetReady', alias);\n"
"}\n"

"function _fireOrmmaAssetRemoved( alias )\n"
"{\n"
"Ormma.fireEvent('assetRemoved', alias);\n"
"}\n"

"function _fireOrmmaRequest( val )\n"
"{\n"
"Ormma.fireEvent('response', val);\n"
"}";

+ (NSString*)wrapHTML:(NSString *)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter {
	/*NSString* html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@ %@</script></head><body>%@</body></html>",kJavaScript_ormma_bridge,kJavaScript_ormma, data];
     */
    NSString* html = nil;
    if (aligmentCenter) {
         html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@</script></head><body><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" width=\"%f\" height=\"%f\"><tr><td align=\"center\" valign=\"middle\"><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></td></tr></table></body></html>",kJavaScriptOrmma2, frameSize.width, frameSize.height, data];
     } else {
         html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@</script></head><body><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></body></html>",kJavaScriptOrmma2, data];
     }
    /*
	[html appendFormat:@"<html><head><meta name=\"viewport\" content=\"width=%.0f,minimum-scale=1.0,maximum-scale=1.0\">", formWidth];

	[html appendFormat:@"<style> body { margin:0; padding:0; } img { max-width:%.0f; max-height:%.0f; }</style>", frameSize.width, frameSize.height];
	[html appendString:@"</head><body>"];
	[html appendString:data];
	[html appendString:@"</body></html>"];
	*/
    return html;
}

@end
