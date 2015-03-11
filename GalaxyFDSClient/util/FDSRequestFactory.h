//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDSClientConfiguration.h"

@interface FDSRequestFactory : NSObject
+ (NSURLRequest *)createRequest:(NSString *)uri
    withConfig:(FDSClientConfiguration *)config andHTTPMethod:(NSString *)method
    andHeader:(NSDictionary *)headers;
@end
