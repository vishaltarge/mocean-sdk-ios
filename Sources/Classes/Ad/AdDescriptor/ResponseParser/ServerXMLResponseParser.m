//
//  ServerResponseParser.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 10/8/10.
//

#import "ServerXMLResponseParser.h"


@implementation ServerXMLResponseParser

@synthesize parser = _parser;
//@synthesize delegate = _delegate;

@synthesize adContentType = _adContentType;
@synthesize propertyName = _propertyName;
@synthesize propertyContent = _propertyContent;
@synthesize content;

@synthesize campaignId = _campaignId;
@synthesize trackUrl = _trackUrl;
@synthesize appId = _appId;
@synthesize adId = _adId;
@synthesize adType = _adType;
@synthesize latitude, longitude, zip;

- (void) startParseSynchronous:(NSString*)contentSrc {
    _adContentType = AdContentTypeUndefined;
	[self.campaignId release];
    self.campaignId = nil;
	[self.trackUrl release];
    self.trackUrl = nil;
	[self.appId release];
    self.appId = nil;
	[self.adId release];
    self.adId = nil;
	[self.adType release];
    self.adType = nil;
	[self.latitude release];
    self.latitude = nil;
	[self.longitude release];
    self.longitude = nil;
	[self.zip release];
    self.zip = nil;
    self.content = [NSMutableDictionary dictionary];
    
	_startSynchronous = YES;
	_adContentType = AdContentTypeUndefined;
	
	contentSrc = [contentSrc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSRange start = [contentSrc rangeOfString:@"<!-- client_side_external_campaign"];
	NSRange end = [contentSrc rangeOfString:@"-->"];
	NSString* result = [contentSrc substringWithRange:NSMakeRange(start.location+start.length, end.location-start.location-start.length)];  
	
	self.parser = [[NSXMLParser alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];
	
	[self.parser setDelegate:self];
	[self.parser setShouldProcessNamespaces:NO];
	[self.parser setShouldReportNamespacePrefixes:NO];
	[self.parser setShouldResolveExternalEntities:NO];
    
    [self.parser parse];
}

#pragma mark -
#pragma mark NSXMLParser functions

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"param"] && [attributeDict count] == 1) {
		self.propertyName = [attributeDict valueForKey:@"name"];
    }
	self.propertyContent = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{    
	if ([elementName caseInsensitiveCompare:@"campaign_id"] == NSOrderedSame) {
        [self.content setObject:self.propertyContent forKey:@"campaign_id"];
        
		self.campaignId = self.propertyContent;
	}
	else if ([elementName caseInsensitiveCompare:@"type"] == NSOrderedSame) {
        [self.content setObject:self.propertyContent forKey:@"type"];
        
		if ([self.propertyContent caseInsensitiveCompare:@"iAds"] == NSOrderedSame) {
			_adContentType = AdContentTypeIAd;
		}
		else if ([self.propertyContent caseInsensitiveCompare:@"GreyStripe"] == NSOrderedSame) {
			_adContentType = AdContentTypeGreystripe;
		}
		else if ([self.propertyContent caseInsensitiveCompare:@"iVdopia"] == NSOrderedSame) {
			_adContentType = AdContentTypeiVdopia;
		}
	}
	else if ([elementName caseInsensitiveCompare:@"track_url"] == NSOrderedSame) {
        [self.content setObject:self.propertyContent forKey:@"track_url"];
        
		self.trackUrl = self.propertyContent;
	}
	else if ([elementName caseInsensitiveCompare:@"param"] == NSOrderedSame) {
        [self.content setObject:self.propertyContent forKey:self.propertyName];
        
		if ([self.propertyName caseInsensitiveCompare:@"id"] == NSOrderedSame) {
			if (_adContentType == AdContentTypeGreystripe) {
				self.appId = self.propertyContent;
			}
			else {
				self.adId = self.propertyContent;
			}
		}
		else if ([self.propertyName caseInsensitiveCompare:@"applicationKey"] == NSOrderedSame) {
			if (_adContentType == AdContentTypeiVdopia) {
				self.appId = self.propertyContent;
			}
		}
	}
	[self.propertyContent release];
    self.propertyContent = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//[self performSelector:@selector(callXmlParsingFinished:) onThread:_curThread withObject:[self getLocations] waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.propertyContent) {
		[self.propertyContent appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	//[Logger logWithString:[parseError localizedDescription]];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
	//[Logger logWithString:[validationError localizedDescription]];
}

- (void) dealloc {
    self.content = nil;
    [_parser release];
	[_propertyName release];
	[_propertyContent release];
	[_campaignId release];
	[_adId release];
	[_trackUrl release];
    [self.latitude release];
    [self.longitude release];
    [self.zip release];
	
	[super dealloc];
}

@end
