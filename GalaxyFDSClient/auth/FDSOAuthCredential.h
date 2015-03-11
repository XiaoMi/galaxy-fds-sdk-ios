//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GalaxyFDSCredential.h"

@interface FDSOAuthCredential : NSObject <GalaxyFDSCredential>
- (id)initWithURI:(NSString *)fdsServiceBaseUri appId:(NSString *)appId
    oauthAppId:(NSString *)oauthAppId token:(NSString *)oauthAccessToken
    provider:(NSString *)oauthProvider macKey:(NSString *)macKey
    algorithm:(NSString *)macAlgorithm;
@end
