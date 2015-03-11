//
// Created by ss on 15-2-11.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSSigner.h"
#import "FDSHttpHeaders.h"
#import "FDSCommon.h"
#import "FDSUtilities.h"
#import "FDSSubResource.h"

@implementation FDSSigner
+ (NSString *)signToBase64withMethod:(NSString *)httpMethod
                              andURI:(NSURL *)uri
                          andHeaders:(NSDictionary *)headers
                     andAccessSecret:(NSString *)secret
                      usingAlgorithm:(CCHmacAlgorithm)algorithm {
  NSMutableString *data = [[NSMutableString alloc] init];
  [data appendFormat:@"%@\n%@\n%@\n",
                     httpMethod,
                     [self emptyIfNullIn:headers forKey:FDSCommon.CONTENT_MD5],
                     [self emptyIfNullIn:headers forKey:FDSCommon.CONTENT_TYPE]];
  long long expires = [self getExpires:uri];
  if (expires > 0) {
    //For pre-signed URI
    [data appendFormat:@"%lld\n", expires];
  } else {
    id date = [self emptyIfNullIn:headers forKey:FDSHttpHeaders.DATE];
    [data appendFormat:@"%@\n", date];
  }
  [data appendString:[self canonicalizeXiaomiHeaders:headers]];
  [data appendString:[self canonicalizeResource:uri]];
  return [FDSSigner sign:data withSecret:secret usingAlgorithm:algorithm];
}

+ (NSString *)canonicalizeXiaomiHeaders:(NSDictionary *)headers {
  if (!headers) {
    return @"";
  }
  NSMutableDictionary *keyValues = [[NSMutableDictionary alloc] init];
  [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *lowerKey = [key lowercaseString];
    if ([lowerKey hasPrefix:FDSCommon.XIAOMI_HEADER_PREFIX]) {
      keyValues[lowerKey] = obj;
    }
  }];
  NSMutableString *result = [[NSMutableString alloc] init];
  for (NSString *key in
      [[keyValues allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
    [result appendFormat:@"%@:%@\n", key, keyValues[key]];
  }
  return result;
}

+ (NSString *)canonicalizeResource:(NSURL *)uri {
  NSMutableString *result = [NSMutableString stringWithString:[uri path]];
  NSString *fixedPath = [NSString stringWithFormat:@"%@/", result];
  if ([[uri absoluteString] rangeOfString:fixedPath].location != NSNotFound) {
    [result appendString:@"/"];
  }
  NSArray *query = [[uri query] componentsSeparatedByString:@"&"];

  BOOL first = YES;
  for (NSString *item in [query sortedArrayUsingSelector:@selector(compare:)]) {
    id key = [item componentsSeparatedByString:@"="];
    if (key && [FDSSubResource hasSubResource:key[0]]) {
      if (first) {
        [result appendString:@"?"];
        first = NO;
      } else {
        [result appendString:@"&"];
      }
      if ([key count] == 1) {
        [result appendString:key[0]];
      } else {
        [result appendFormat:@"%@=%@", key[0], key[1]];
      }
    }
  }
  return result;
}

+ (NSString *)sign:(NSString *)data
        withSecret:(NSString *)key
    usingAlgorithm:(CCHmacAlgorithm)algorithm{
  NSAssert(data, @"data cannot be nil");
  NSAssert(key, @"key cannot be nil");
  const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
  const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];

  unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
  CCHmac(algorithm, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
  NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
  NSString *hash = [HMAC base64EncodedStringWithOptions:0];
  return hash;
}

+ (long long)getExpires:(NSURL *)uri {
  NSDictionary *params = [FDSUtilities parseUriParameters:uri];
  NSArray *expires = [params objectForKey:FDSCommon.EXPIRES];
  NSString *mili = [expires objectAtIndex:0];
  if (mili) {
    return [mili longLongValue];
  }
  return 0;
}

+ (NSString *)emptyIfNullIn:(NSDictionary *)dictionary forKey:(NSString *)key {
  id value = [dictionary objectForKey:key];
  return value ? value : @"";
}
@end
