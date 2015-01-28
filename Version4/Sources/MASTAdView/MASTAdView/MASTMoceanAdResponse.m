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
//  MASTAdView
//
//  Created on 9/21/12.

//

#import "MASTMoceanAdResponse.h"
#import "MASTMoceanAdDescriptor.h"


@interface MASTMoceanAdResponse()
@property (nonatomic, strong) NSMutableArray* descriptors;
@property (nonatomic, strong) NSXMLParser* xmlParser;
@property (nonatomic, strong) MASTMoceanAdDescriptor* parsingDescriptor;
@end


@implementation MASTMoceanAdResponse

@synthesize descriptors, xmlParser, errorCode, errorMessage, parsingDescriptor;

- (void)dealloc
{
    [self.xmlParser setDelegate:nil];
    self.xmlParser = nil;
}

- (id)initWithXML:(NSData*)xmlData
{
    self = [super init];
    if (self)
    {
        self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
        self.xmlParser.delegate = self;
        
        self.descriptors = [NSMutableArray new];
    }
    return self;
}

- (void)parse
{
    [self.xmlParser parse];
    [self.xmlParser setDelegate:nil];
    self.xmlParser = nil;
}

- (NSArray*)adDescriptors
{
    [self parse];
    
    return self.descriptors;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([@"ad" isEqualToString:elementName])
    {
        self.parsingDescriptor = [[MASTMoceanAdDescriptor alloc] initWithParser:parser attributes:attributeDict];
    }
    else if ([@"error" isEqualToString:elementName])
    {
        self.errorCode = [attributeDict valueForKey:@"code"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ((self.parsingDescriptor != nil) && [@"ad" isEqualToString:elementName])
    {
        [self.descriptors addObject:self.parsingDescriptor];
        self.parsingDescriptor = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.errorCode != nil)
    {
        if (self.errorMessage == nil)
        {
            self.errorMessage = string;
        }
        else
        {
            self.errorMessage = [self.errorMessage stringByAppendingString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    
}

@end
