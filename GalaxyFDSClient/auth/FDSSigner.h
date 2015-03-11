//
// Created by ss on 15-2-11.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface FDSSigner : NSObject
+ (NSString *)signToBase64withMethod:(NSString *)httpMethod andURI:(NSURL *)uri
    andHeaders:(NSDictionary *)header andAccessSecret:(NSString *)secret
    usingAlgorithm:(CCHmacAlgorithm)algorithm;
@end
