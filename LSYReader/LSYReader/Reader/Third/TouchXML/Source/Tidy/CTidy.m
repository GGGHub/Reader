//
//  CTidy.m
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

#ifdef TOUCHXMLUSETIDY

#import "CTidy.h"

@interface CTidy ()
@end

@implementation CTidy

/*
 Values include: ascii, latin1, raw, utf8, iso2022, mac, win1252, utf16le, utf16be, utf16, big5 and shiftjis. Case in-sensitive.
 http://tidy.sourceforge.net/docs/api/group__Basic.html#g2612e184472c2a59ca822a37d030e9af
 */
+ (NSString *)tidyEncodingFromStringEncoding:(NSStringEncoding)encoding {
    NSString *tidyEncoding;
    
    switch (encoding) {
        case NSASCIIStringEncoding:
            tidyEncoding = @"ascii";
            break;
            
        case NSISOLatin1StringEncoding:
            tidyEncoding = @"latin1";
            break;
            
        // raw?
            
        case NSUTF8StringEncoding:
            tidyEncoding = @"utf8";
            break;
            
        case NSISO2022JPStringEncoding:
            tidyEncoding = @"iso2022";
            break;
            
        case NSMacOSRomanStringEncoding:
            tidyEncoding = @"mac";
            break;
            
        case NSWindowsCP1252StringEncoding:
            tidyEncoding = @"win1252";
            break;
            
        case NSUTF16LittleEndianStringEncoding:
            tidyEncoding = @"utf16le";
            break;
            
        case NSUTF16BigEndianStringEncoding:
            tidyEncoding = @"utf16be";
            break;
            
        case NSUTF16StringEncoding:
            tidyEncoding = @"utf16";
            break;
            
        // big5 not enumerated in NSStringEncoding
            
        case NSShiftJISStringEncoding:
            tidyEncoding = @"shiftjis";
            break;
            
        default:
            tidyEncoding = nil;
            break;
    }
    
    return tidyEncoding;
}

- (NSData *)tidyData:(NSData *)inData inputFormat:(CTidyFormat)inInputFormat outputFormat:(CTidyFormat)inOutputFormat encoding:(const char*)encoding diagnostics:(NSString **)outDiagnostics error:(NSError **)outError
{
    TidyDoc theTidyDocument = tidyCreate();

    int theResultCode = 0;

    // Set input format if input is XML (xhtml & html are the tidy 'default')
    if (inInputFormat == TidyFormat_XML) {
        theResultCode = tidyOptSetBool(theTidyDocument, TidyXmlTags, YES);
        NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");
    }

    // Set output format
    TidyOptionId theOutputValue = TidyXmlOut;
    if (inOutputFormat == TidyFormat_HTML) {
        theOutputValue = TidyHtmlOut;
    }
        
    else if (inOutputFormat == TidyFormat_XHTML) {
        theOutputValue = TidyXhtmlOut;
    }
    theResultCode = tidyOptSetBool(theTidyDocument, theOutputValue, YES);
    NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");

    // Force output even if errors found
    theResultCode = tidyOptSetBool(theTidyDocument, TidyForceOutput, YES);
    NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");

    // Set encoding - same for input and output
    theResultCode = tidySetInCharEncoding(theTidyDocument, encoding);
    NSAssert(theResultCode >= 0, @"tidySetInCharEncoding() should return 0");
    theResultCode = tidySetOutCharEncoding(theTidyDocument, encoding);
    NSAssert(theResultCode >= 0, @"tidySetOutCharEncoding() should return 0");

    // Create an error buffer
    TidyBuffer theErrorBuffer;
    tidyBufInit(&theErrorBuffer);
    theResultCode = tidySetErrorBuffer(theTidyDocument, &theErrorBuffer);
    NSAssert(theResultCode >= 0, @"tidySetErrorBuffer() should return 0");

    // #############################################################################

    // Create an input buffer and copy input to it (TODO uses 2X memory == bad!)
    TidyBuffer theInputBuffer;
    /*
     Without this line following memcpy crashes compiling with LLVM 4, because
     realloc does not find a NULL pointer to malloc in tidyBufAlloc() call
     */
    theInputBuffer.bp = NULL;
    tidyBufAlloc(&theInputBuffer, [inData length]);
    memcpy(theInputBuffer.bp, [inData bytes], [inData length]);
    theInputBuffer.size = [inData length];

    // Parse the data.
    theResultCode = tidyParseBuffer(theTidyDocument, &theInputBuffer);
    if (theResultCode < 0) {
        if (outError) {
            NSDictionary *theUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)theErrorBuffer.bp], NSLocalizedDescriptionKey, nil];

            *outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:theResultCode userInfo:theUserInfo];
        }
        
        return nil;
    }

    // Clean up input buffer.	
    tidyBufFree(&theInputBuffer);

    // Repair the data
    theResultCode = tidyCleanAndRepair(theTidyDocument);
    if (theResultCode < 0) {
        return nil;
    }

    //theResultCode = tidyRunDiagnostics(theTidyDocument);

    // 
    TidyBuffer theOutputBuffer;
    tidyBufInit(&theOutputBuffer);
    theResultCode = tidySaveBuffer(theTidyDocument, &theOutputBuffer);
    if (theResultCode < 0) {
        return nil;
    }

    NSAssert(theOutputBuffer.bp != NULL, @"The buffer should not be null.");
    NSData *theOutput = [[NSData alloc] initWithBytes:theOutputBuffer.bp length:theOutputBuffer.size];
    tidyBufFree(&theOutputBuffer);

    // 
    if (outDiagnostics && theErrorBuffer.bp != NULL) {
        NSData *theErrorData = [[NSData alloc] initWithBytes:theErrorBuffer.bp length:theErrorBuffer.size];
        *outDiagnostics = [[NSString alloc] initWithData:theErrorData encoding:NSUTF8StringEncoding];
    }
    tidyBufFree(&theErrorBuffer);

    // #############################################################################

    tidyRelease(theTidyDocument);

    return theOutput;
}

- (NSString *)tidyString:(NSString *)inString inputFormat:(CTidyFormat)inInputFormat outputFormat:(CTidyFormat)inOutputFormat encoding:(const char*)encoding diagnostics:(NSString **)outDiagnostics error:(NSError **)outError
{
    TidyDoc theTidyDocument = tidyCreate();

    int theResultCode = 0;

    // Set input format if input is XML (xhtml & html are the tidy 'default')
    if (inInputFormat == TidyFormat_XML) {
        theResultCode = tidyOptSetBool(theTidyDocument, TidyXmlTags, YES);
        NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");
    }

    // Set output format
    TidyOptionId theOutputValue = TidyXmlOut;
    if (inOutputFormat == TidyFormat_HTML) {
        theOutputValue = TidyHtmlOut;
    }
    else if (inOutputFormat == TidyFormat_XHTML) {
        theOutputValue = TidyXhtmlOut;
    }
    theResultCode = tidyOptSetBool(theTidyDocument, theOutputValue, YES);
    NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");

    // Force output even if errors found
    theResultCode = tidyOptSetBool(theTidyDocument, TidyForceOutput, YES);
    NSAssert(theResultCode >= 0, @"tidyOptSetBool() should return 0");

    // Set encoding - same for input and output
    theResultCode = tidySetInCharEncoding(theTidyDocument, encoding);
    NSAssert(theResultCode >= 0, @"tidySetInCharEncoding() should return 0");
    theResultCode = tidySetOutCharEncoding(theTidyDocument, encoding);
    NSAssert(theResultCode >= 0, @"tidySetOutCharEncoding() should return 0");

    // Create an error buffer
    TidyBuffer theErrorBuffer;
    tidyBufInit(&theErrorBuffer);
    theResultCode = tidySetErrorBuffer(theTidyDocument, &theErrorBuffer);
    NSAssert(theResultCode >= 0, @"tidySetErrorBuffer() should return 0");

    // #############################################################################

    // Parse the data.
    theResultCode = tidyParseString(theTidyDocument, [inString UTF8String]);
    if (theResultCode < 0) {
        if (outError) {
            NSDictionary *theUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithUTF8String:(char *)theErrorBuffer.bp], NSLocalizedDescriptionKey, nil];
            *outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:theResultCode userInfo:theUserInfo];
        }
        return nil;
    }

    // Repair the data
    theResultCode = tidyCleanAndRepair(theTidyDocument);
    if (theResultCode < 0) {
        return nil;
    }

    //theResultCode = tidyRunDiagnostics(theTidyDocument);

    // 
    uint theBufferLength = 0;

    theResultCode = tidySaveString(theTidyDocument, NULL, &theBufferLength);

    NSMutableData *theOutputBuffer = [[NSMutableData alloc] initWithLength:theBufferLength];

    theResultCode = tidySaveString(theTidyDocument, [theOutputBuffer mutableBytes], &theBufferLength);

    NSString *theString = [[NSString alloc] initWithData:theOutputBuffer encoding:NSUTF8StringEncoding];

    // 
    if (outDiagnostics && theErrorBuffer.bp != NULL) {
        NSData *theErrorData = [[NSData alloc] initWithBytes:theErrorBuffer.bp length:theErrorBuffer.size];
        *outDiagnostics = [[NSString alloc] initWithData:theErrorData encoding:NSUTF8StringEncoding];
    }
    tidyBufFree(&theErrorBuffer);

    // #############################################################################

    tidyRelease(theTidyDocument);

    return theString;
}

@end

#endif /* TOUCHXMLUSETIDY */
