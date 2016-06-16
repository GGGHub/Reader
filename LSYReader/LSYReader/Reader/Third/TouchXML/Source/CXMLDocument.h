//
//  CXMLDocument.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/07/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "CXMLNode.h"

/*
 Tidy is disabled by default. In order to enable it correctly you need to:
 1) set preprocessor macros TOUCHXMLUSETIDY=1
 2) download and build libtidy into your app (you cannot link against system provided build, because you would use Apple private APIs)
 */
enum {
	CXMLDocumentTidyHTML = 1 << 9, // Based on NSXMLDocumentTidyHTML
	CXMLDocumentTidyXML = 1 << 10, // Based on NSXMLDocumentTidyXML
};

@class CXMLElement;

@interface CXMLDocument : CXMLNode {
	NSMutableSet *nodePool;
}

/*
 Please note that, if you use tidy to repair your HTML/XML source, your node
 graph may change.
 
 For example CTidy adds XHTML namespace to your HTML by default:
 
 An HTML source like this:
    <html>
        <head>
            <title>My Title</title>
    ...
 
 becomes:
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
                        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta name="generator" content=
                "HTML Tidy for Mac OS X (vers 31 October 2006 - Apple Inc. build 15.4), see www.w3.org" />
            <title>My Title</title>
    ...
 
 This affects the way you will query this document with XPath, because you will
 need to pass namespace mappings dictionary and to add "xmlns" to your queries
 (e.g: "//xmlns:title" to reach "<title>" element).
 */
- (id)initWithData:(NSData *)inData options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithData:(NSData *)inData encoding:(NSStringEncoding)encoding options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithXMLString:(NSString *)inString options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithContentsOfURL:(NSURL *)inURL options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithContentsOfURL:(NSURL *)inURL encoding:(NSStringEncoding)encoding options:(NSUInteger)inOptions error:(NSError **)outError;

//- (NSString *)characterEncoding;
//- (NSString *)version;
//- (BOOL)isStandalone;
//- (CXMLDocumentContentKind)documentContentKind;
//- (NSString *)MIMEType;
//- (CXMLDTD *)DTD;

- (CXMLElement *)rootElement;

- (NSData *)XMLData;
- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

- (id)XMLStringWithOptions:(NSUInteger)options;

@end
