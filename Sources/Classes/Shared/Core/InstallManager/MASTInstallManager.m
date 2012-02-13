//
//  InstallManager.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/28/11.
//

#import "MASTInstallManager.h"
#import "MASTConstants.h"
#import "MASTNetworkQueue.h"

@interface MASTInstallManager ()

- (BOOL)notificationDone;
- (void)save;
- (void)sendRequest;


@end


@implementation MASTInstallManager

@synthesize advertiserId, groupCode, udid;

static MASTInstallManager* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
    self = [super init];
    
	if (self) {
        _started = NO;
	}
	
	return self;
}

+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (oneway void)superRelease {
    RELEASE_SAFELY(groupCode);
    RELEASE_SAFELY(udid);
    
	[super release];
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}

- (id)retain {
	return sharedInstance;
}

- (unsigned)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	// Do nothing.
}

- (id)autorelease {
	return sharedInstance;
}


#pragma mark -
#pragma mark Public



- (void)sendNotificationWith:(NSInteger)adId groupCode:(NSString*)gCode {
    @synchronized(self) {
        if (!_started) {
            _started = YES;
            
            if (![self notificationDone]) {
                self.advertiserId = adId;
                self.groupCode = gCode;
                self.udid = [MASTUtils md5HashForString:[[UIDevice currentDevice] uniqueIdentifier]];
                
                [self performSelector:@selector(sendRequest) withObject:nil afterDelay:2];
            }
        }
    }
}


#pragma mark -
#pragma mark Private


- (BOOL)notificationDone {
    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/MojivaAd"];
    
    // createDirectoryIfNotExist
	BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDirectory] && !isDirectory) {
		[[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
	NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AdMobile SDK.plist"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
		NSDictionary *tempDictionary = (NSDictionary *)[NSPropertyListSerialization
														propertyListFromData:plistXML
														mutabilityOption:NSPropertyListMutableContainersAndLeaves
														format:&format
														errorDescription:&errorDesc];
		if (tempDictionary) {
			NSString *isFirst = [tempDictionary objectForKey:@"isFirst"];
			if([isFirst isEqualToString:@"true"]) {
				return YES;
			} 
		}
	}
    
    return NO;
}

- (void)sendRequest {
    NSMutableString* url = [NSMutableString stringWithFormat:kMoceanServerUrl];
    [url appendFormat:@"?advertiser_id=%d", self.advertiserId];
    [url appendFormat:@"&group_code=%@", [self.groupCode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [url appendFormat:@"&udid=%@", [self.udid stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    [MASTNetworkQueue loadWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] completion:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self performSelector:@selector(sendRequest) withObject:nil afterDelay:15];
        } else {
            if (data && [data length] > 0) {
                NSString *strResponce = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSRange range = [strResponce rangeOfString:@"<result>OK</result>"];
                if ( range.length > 0) {
                    [self save];
                }
                else
                {
                    range = [strResponce rangeOfString:@"<errorcode>"];
                    if ( range.length > 0 )	{
                        NSString *str = [strResponce substringFromIndex:range.location + range.length];
                        range = [str rangeOfString:@"<"];
                        str = [str substringToIndex:range.location];
                        [[MASTNotificationCenter sharedInstance] postNotificationName:kFailInstallNotification object:str];
                    }
                    else {
                        //<errorcode>1</errorcode>
                        [[MASTNotificationCenter sharedInstance] postNotificationName:kFailInstallNotification object:nil];			
                    }
                }
                [strResponce release];
                
            }
            else {
                [[MASTNotificationCenter sharedInstance] postNotificationName:kFailInstallNotification object:nil];		
            }
        }
    }];
}

- (void)save {
    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/MojivaAd"];
    
    // createDirectoryIfNotExist
	BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDirectory] && !isDirectory) {
		[[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
	NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AdMobile SDK.plist"];
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: @"true", nil] forKeys:[NSArray arrayWithObjects: @"isFirst", nil]];
    NSString *errorDesc = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:
                         plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kFinishInstallNotification object:nil];
    }
}

@end

