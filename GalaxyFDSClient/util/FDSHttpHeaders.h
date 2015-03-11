//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSHttpHeaders : NSObject
/** RFC 1945 (HTTP/1.0) Section 10.2, RFC 2616 (HTTP/1.1) Section 14.8 */
+ (NSString *)AUTHORIZATION;

/** RFC 2616 (HTTP/1.1) Section 14.9 */
+ (NSString *)CACHE_CONTROL;

/** RFC 1945 (HTTP/1.0) Section 10.3, RFC 2616 (HTTP/1.1) Section 14.11 */
+ (NSString *)CONTENT_ENCODING;

/** RFC 1945 (HTTP/1.0) Section 10.4, RFC 2616 (HTTP/1.1) Section 14.13 */
+ (NSString *)CONTENT_LENGTH;

/** RFC 2616 (HTTP/1.1) Section 14.15 */
+ (NSString *)CONTENT_MD5;

/** RFC 2616 (HTTP/1.1) Section 14.16 */
+ (NSString *)CONTENT_RANGE;

/** RFC 1945 (HTTP/1.0) Section 10.5, RFC 2616 (HTTP/1.1) Section 14.17 */
+ (NSString *)CONTENT_TYPE;

/** RFC 1945 (HTTP/1.0) Section 10.6, RFC 2616 (HTTP/1.1) Section 14.18 */
+ (NSString *)DATE;

/** RFC 1945 (HTTP/1.0) Section 10.10, RFC 2616 (HTTP/1.1) Section 14.29 */
+ (NSString *)LAST_MODIFIED;

/** RFC 2616 (HTTP/1.1) Section 14.35 */
+ (NSString *)RANGE;
@end
