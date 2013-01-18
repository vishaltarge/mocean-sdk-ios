MASTAdView SDK 3.0
Copyright (c) 2011, 2012, 2013 Mocean Mobile. All rights reserved.

SDK Information:
http://developer.moceanmobile.com/SDKs

Project Source:
http://code.google.com/p/mocean-sdk-ios/


Release Notes:

3.0.1
- Corrected setting the various sizes to the MRAID bridge on rotation
- Corrected logLevel setting
- Added removeContent message to MASTAdView to allow resetting of ad content without resetting update timers
- Updated MRAID create calendar event logic to flow properly with modal presentation while expanded
- Added mcc and mnc parameters if obtainable via CoreTelephony (and now requires that framework)
- Exposed the UIWebView container to the MASTAdView public interface
- Properly invoke didFailToReceiveAd when a zone has no errors (and updated the logging for it)
- Added delegate message to allow custom modal presentation controller for MASTAdView modal controllers
- Changed calendar create event delegate message to return a BOOL vs. a UIViewController, the controller can now be returned in the new delegate mentioned above.
- Updated size of the SDK close button to increase hit area

3.0.2
- Corrected log type for 404 ad descriptor.
