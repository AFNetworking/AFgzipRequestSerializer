// AFgzipRequestSerializer.m
//
// Copyright (c) 2014 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFgzipRequestSerializer.h"

#import "NSData+Godzippa.h"

@interface AFgzipRequestSerializer ()
@property (readwrite, nonatomic, strong) id <AFURLRequestSerialization> serializer;
@end

@implementation AFgzipRequestSerializer

+ (instancetype)serializerWithSerializer:(id<AFURLRequestSerialization>)serializer {
    AFgzipRequestSerializer *gzipSerializer = [self serializer];
    gzipSerializer.serializer = serializer;

    return gzipSerializer;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError * __autoreleasing *)error
{
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [[self.serializer requestBySerializingRequest:request withParameters:parameters error:&serializationError] mutableCopy];
    if (!serializationError && mutableRequest.HTTPBody) {
        NSError *compressionError = nil;
        NSData *compressedData = [mutableRequest.HTTPBody dataByGZipCompressingWithError:&compressionError];

        if (compressedData && !compressionError) {
            [mutableRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
            [mutableRequest setHTTPBody:compressedData];
        } else {
            if (error) {
                *error = compressionError;
            }
        }
    } else {
        if (error) {
            *error = serializationError;
        }
    }

    return mutableRequest;
}

#pragma mark - NSCoder

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.serializer = [decoder decodeObjectForKey:NSStringFromSelector(@selector(serializer))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.serializer forKey:NSStringFromSelector(@selector(serializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFgzipRequestSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.serializer = self.serializer;

    return serializer;
}

@end
