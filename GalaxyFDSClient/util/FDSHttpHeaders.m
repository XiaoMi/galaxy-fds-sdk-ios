//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSHttpHeaders.h"


@implementation FDSHttpHeaders {

}
/** RFC 1945 (HTTP/1.0) Section 10.2, RFC 2616 (HTTP/1.1) Section 14.8 */
+ (NSString *)AUTHORIZATION {
  return @"Authorization";
}

/** RFC 2616 (HTTP/1.1) Section 14.9 */
+ (NSString *)CACHE_CONTROL {
  return @"Cache-Control";
}

/** RFC 1945 (HTTP/1.0) Section 10.3, RFC 2616 (HTTP/1.1) Section 14.11 */
+ (NSString *)CONTENT_ENCODING {
  return @"Content-Encoding";
}

/** RFC 1945 (HTTP/1.0) Section 10.4, RFC 2616 (HTTP/1.1) Section 14.13 */
+ (NSString *)CONTENT_LENGTH {
  return @"Content-Length";
}

/** RFC 2616 (HTTP/1.1) Section 14.15 */
+ (NSString *)CONTENT_MD5 {
  return @"Content-MD5";
}

/** RFC 2616 (HTTP/1.1) Section 14.16 */
+ (NSString *)CONTENT_RANGE {
  return @"Content-Range";
}

/** RFC 1945 (HTTP/1.0) Section 10.5, RFC 2616 (HTTP/1.1) Section 14.17 */
+ (NSString *)CONTENT_TYPE {
  return @"Content-Type";
}

/** RFC 1945 (HTTP/1.0) Section 10.6, RFC 2616 (HTTP/1.1) Section 14.18 */
+ (NSString *)DATE {
  return @"Date";
}

/** RFC 1945 (HTTP/1.0) Section 10.10, RFC 2616 (HTTP/1.1) Section 14.29 */
+ (NSString *)LAST_MODIFIED {
  return @"Last-Modified";
}

/** RFC 2616 (HTTP/1.1) Section 14.35 */
+ (NSString *)RANGE {
  return @"Range";
}
@end
