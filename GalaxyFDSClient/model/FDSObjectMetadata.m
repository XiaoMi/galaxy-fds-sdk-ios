//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSCommon.h"
#import "FDSHttpHeaders.h"
#import "FDSObjectMetadata.h"
#import "FDSUtilities.h"

static NSSet *PREDEFINED_HEADERS;

@implementation FDSObjectMetadata {
  NSMutableDictionary *_userMetadata;
  NSMutableDictionary *_predefinedMetadata;
}

@synthesize userMetadata = _userMetadata;
@synthesize predefinedMetadata = _predefinedMetadata;

- (id)init {
  self = [super init];
  if (self) {
    _userMetadata = [[NSMutableDictionary alloc] init];
    _predefinedMetadata = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)addUserMetadata:(NSString *)value forKey:(NSString *)key {
  _userMetadata[key] = value;;
}

- (long long)getContentLength {
  NSString *contentLength = _predefinedMetadata[FDSHttpHeaders.CONTENT_LENGTH];
  if (contentLength) {
    return [contentLength longLongValue];
  }
  return -1;
}

- (void)setContentLength:(long long)contentLength {
  _predefinedMetadata[FDSHttpHeaders.CONTENT_LENGTH] =
      [NSString stringWithFormat:@"%lld", contentLength];
}

- (NSString *)getContentMD5 {
  return _predefinedMetadata[FDSHttpHeaders.CONTENT_MD5];
}

- (void)setContentMD5:(NSString *)contentMD5 {
  _predefinedMetadata[FDSHttpHeaders.CONTENT_MD5] = contentMD5;
}

- (NSString *)getContentType {
  return _predefinedMetadata[FDSHttpHeaders.CONTENT_TYPE];
}

- (void)setContentType:(NSString *)contentType {
  _predefinedMetadata[FDSHttpHeaders.CONTENT_TYPE] = contentType;

}

- (NSString *)getContentEncoding {
  return _predefinedMetadata[FDSHttpHeaders.CONTENT_ENCODING];
}

- (void)setContentEncoding:(NSString *)contentEncoding {
  _predefinedMetadata[FDSHttpHeaders.CONTENT_ENCODING] = contentEncoding;
}

- (NSString *)getCacheControl {
  return _predefinedMetadata[FDSHttpHeaders.CACHE_CONTROL];
}

- (void)setCacheControl:(NSString *)cacheControl {
  _predefinedMetadata[FDSHttpHeaders.CACHE_CONTROL] = cacheControl;

}

- (NSDate *)getLastModified {
  NSString *lasModified = _predefinedMetadata[FDSHttpHeaders.LAST_MODIFIED];
  if (lasModified) {
    return [FDSUtilities parseDate:lasModified];
  }
  return nil;
}

- (void)setLastModified:(NSDate *)lastModified {
  _predefinedMetadata[FDSHttpHeaders.LAST_MODIFIED] =
      [FDSUtilities formatDateString:lastModified];
}

- (void)addPredefinedMetadata:(NSString *)value forKey:(NSString *)key {
  _predefinedMetadata[key] = value;
}

- (NSDictionary *)getAllMetadata {
  NSMutableDictionary *copy = [[NSMutableDictionary alloc] init];
  [_predefinedMetadata enumerateKeysAndObjectsUsingBlock:^(id key, id obj,
      BOOL *stop) {
    copy[key] = obj;
  }];
  [_userMetadata enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    copy[key] = obj;
  }];
  return copy;
}

+ (FDSObjectMetadata *)parseObjectMetadata:(NSDictionary *)headers {
  FDSObjectMetadata *metadata = [[FDSObjectMetadata alloc] init];
  [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([key hasPrefix:FDSCommon.XIAOMI_META_HEADER_PREFIX]) {
      [metadata addUserMetadata:obj forKey:key];
    } else if ([PREDEFINED_HEADERS containsObject:key]) {
      [metadata addPredefinedMetadata:obj forKey:key];
    }
  }];
  return metadata;
}

+ (void)initialize {
  PREDEFINED_HEADERS = [NSSet setWithObjects:FDSHttpHeaders.LAST_MODIFIED,
      FDSHttpHeaders.CONTENT_MD5, FDSHttpHeaders.CONTENT_TYPE,
      FDSHttpHeaders.CONTENT_LENGTH, FDSHttpHeaders.CONTENT_ENCODING,
      FDSHttpHeaders.CACHE_CONTROL, nil];
}

@end
