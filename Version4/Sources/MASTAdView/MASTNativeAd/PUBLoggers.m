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
//  PUBLoggers.m

//


//SYSTEM INCLUDES
#import "TargetConditionals.h"

//USER INCLUDES
#import "PUBLoggers.h"


//#import "PUBUtil.h"
@interface PUBLoggers()
// Log into file with respective LogTag
+(void)log:(NSString *)message WithLogTag:(PUBLogMode) tempLogMode;

// Creates FileName According to present date
+(NSString *) createFileName;

// Checks if the desired file exists
+(BOOL) fileExists:(NSString *) fileName;

// This function actually writes into file
+(void) logToFile:(NSString *) message;

// Create Logs in desire format
+(NSString *) createLogMessageUsingMessage:(NSString *) message  withLogTag:(PUBLogMode) logtag;

// Reads a particular file
+(NSString *) readFileWithTitle:(NSString *) title;

// Deletes a particular file
+(void) deleteFileWithTitle:(NSString*) title;

// Returns the string format of LogTag
+(NSString *) getLogModeStringWithLogTag:(PUBLogMode) logtag;

@end


@implementation PUBLoggers

static BOOL _logEnable;
static PUBLogMode _logMode;


#pragma mark -  Public Functions
+(void) debugLog:(NSString *) message
{
    [PUBLoggers log:message WithLogTag:PUBLogDebug];
}
+(void) enableLogging : (BOOL) enable
{
    _logEnable = enable;
}

+(BOOL) isLoggingEnabled
{
    return _logEnable;
}

+(void) infoLog:(NSString *) message
{
    [PUBLoggers log:message WithLogTag:PUBLogInfo];
}

+(void) warnLog:(NSString *) message
{
    [PUBLoggers log:message WithLogTag:PUBLogWarn];
}

+(void) errorLog:(NSString *) message
{
    [PUBLoggers log:message WithLogTag:PUBLogError];
}


+(NSString *) getLogModeStringWithLogTag:(PUBLogMode) logtag
{
    switch(logtag)
    {
        case PUBLogInfo: return @"PUBLogInfo";
            break;
            
        case PUBLogDebug: return @"PUBLogDebug";
            break;
            
        case PUBLogWarn: return @"PUBLogWarn";
            break;
            
        case PUBLogError: return @"PUBLogError";
            break;
        case PUBLogNone: return @"PUBLogNone";
            break;   
            
    }
    return nil;
}

+(void) setLogMode:(PUBLogMode) logMode
{
    _logMode = logMode;
}

+(PUBLogMode) getLogMode
{
    return _logMode;
}


+(NSString *) stringFromLogMode
{
    return [PUBLoggers getLogModeStringWithLogTag:_logMode];
}


#pragma mark -  Private Functions

+(void)logWithfunctionName:(const char*)functionName lineNumber:(int)lineNumber withLogTag:(PUBLogMode) logmode format:(NSString*)format, ...
{
    if(_logEnable)
    {
        if(_logMode >= logmode)
        {
            va_list ap;
            NSString *msg,*fName;
            va_start(ap,format);
            msg=[[NSString alloc] initWithFormat:format arguments:ap];
            fName = [NSString stringWithUTF8String:functionName];
            va_end(ap);
            NSString *message = [NSString stringWithFormat:@"%s [Line %d]: %@",[[fName lastPathComponent] UTF8String],lineNumber,msg];
            NSLog(@"%@",message);
            NSString *logMessage = [PUBLoggers createLogMessageUsingMessage: message  withLogTag:logmode];
            [PUBLoggers logToFile: logMessage];
            
        }
    }
}

+(void)log:(NSString *)message WithLogTag:(PUBLogMode) tempLogMode;
{
    if(_logEnable)
    {
        if(_logMode >= tempLogMode)
        {
            NSLog(@"%@",message);
            NSString *logMessage = [PUBLoggers createLogMessageUsingMessage: message  withLogTag:tempLogMode];
            [PUBLoggers logToFile: logMessage];
        }
    }
}

+(void) logToFile:(NSString *) message
{
    #if TARGET_IPHONE_SIMULATOR
    {
            NSString *fileName = @"pubmatic_sdk_logs";
            
            // For error information
            NSError *error;
            
            // Point to Document directory
            NSString *documentsDirectory = [NSHomeDirectory() 
                                            stringByAppendingPathComponent:@"Documents"];   
            NSString *filePath = [documentsDirectory 
                                  stringByAppendingPathComponent:fileName];
            
            
            // Check if file is created if not create it, If created then copy all contents of file 
            //  append new log message and write whole string to file.
            if([PUBLoggers readFileWithTitle:fileName] != nil)
            {
                NSMutableString *mutableString = [[NSMutableString alloc] init ];
                [mutableString appendString:[PUBLoggers readFileWithTitle:fileName]];
                
                NSString *fileContents = [mutableString stringByAppendingString:message];
                // NSLog(@"qwerty: %@",fileContents);
                // Write the file
                [fileContents writeToFile:filePath atomically:YES 
                                 encoding:NSUTF8StringEncoding error:&error];
            }
            else
            {
                // Write the file
                [message writeToFile:filePath atomically:YES 
                            encoding:NSUTF8StringEncoding error:&error];
            }
    }
    #endif
       
}

+(NSString *) createLogMessageUsingMessage:(NSString *) message  withLogTag:(PUBLogMode) logtag
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] 
                                    components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:today];
    
    NSInteger day = [components day];    
    NSInteger month = [components month] -1;
    NSInteger year = [components year];
    
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"HH:mm:ss"];
    
    NSMutableString *log = [[NSMutableString alloc] init ] ;
    [log appendFormat:@"\n %ld-%ld-%ld %@ : %@ :",(long)year,(long)month,(long)day,[dt stringFromDate:today],[PUBLoggers getLogModeStringWithLogTag:logtag]];
    
    return [log stringByAppendingString:message];
    
}
+(void) deleteFileWithTitle:(NSString*) title
{
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() 
                                    stringByAppendingPathComponent:@"Documents"]; 
    NSString *filePath = [documentsDirectory 
                          stringByAppendingPathComponent:title];
    // For error information
    NSError *error;
    
    if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
}

+(NSString *) createFileName
{
    NSMutableString *fileName = [[NSMutableString alloc] initWithString:@"pubmatic_sdk_logs_"];
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] 
                                    components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit fromDate:today];
    
    NSInteger day = [components day];    
    NSInteger month = [components month] -1;
    NSInteger year = ([components year]%100);
    
    [fileName appendFormat:@"%ld_%ld_%ld.txt",(long)month,(long)day,(long)year];
    
    return fileName;
}

+(BOOL) fileExists:(NSString *) fileName
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return fileExists;
}

+(void) printTitleofAllLogFiles
{
    // For error information
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() 
                                    stringByAppendingPathComponent:@"Documents"];   
    // Show contents of Documents directory
    NSLog(@"LogFiles: %@",
          [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

+(NSString *) readFileWithTitle:(NSString *) title
{
    NSError *error;
    NSStringEncoding encoding;
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:title];
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:filePath
                                                          usedEncoding:&encoding
                                                                 error:&error];
    return fileContents;
}

@end
