//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSObjectMetadata : NSObject
@property (readonly) NSDictionary *userMetadata;
@property (readonly) NSDictionary *predefinedMetadata;

- (id)init;

- (void)addUserMetadata:(NSString *)value forKey:(NSString *)key;

- (long long)getContentLength;

- (void)setContentLength:(long long)contentLength;

- (NSString *)getContentMD5;

- (void)setContentMD5:(NSString *)contentMD5;

- (NSString *)getContentType;

- (void)setContentType:(NSString *)contentType;

- (NSString *)getContentEncoding;

- (void)setContentEncoding:(NSString *)contentEncoding;

- (NSString *)getCacheControl;

- (void)setCacheControl:(NSString *)cacheControl;

- (NSDate *)getLastModified;

- (void)setLastModified:(NSDate *)lastModified;

- (void)addPredefinedMetadata:(NSString *)value forKey:(NSString *)key;

- (NSDictionary *)getAllMetadata;

+ (FDSObjectMetadata *)parseObjectMetadata:(NSDictionary *)headers;
@end
