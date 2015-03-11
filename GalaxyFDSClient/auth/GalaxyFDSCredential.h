//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Credential information for FDS Client
 */
@protocol GalaxyFDSCredential

/**
 * Add HTTP header to request
 * @param request
 */
- (void)addHeaderToRequest:(NSMutableURLRequest *)request;

/**
 * Adds parameter to the URL string
 * @param uri
 * @return
 */
- (NSString *)addParamToURI:(NSString *)uri;
@end
