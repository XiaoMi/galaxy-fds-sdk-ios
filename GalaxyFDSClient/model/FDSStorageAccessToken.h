//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSStorageAccessToken : NSObject
@property NSString *token;
@property long long expireTime;

- (id)initWithToken:(NSString *)token andExpireTime:(long long)expireTime;

- (id)initFromJson:(NSData *)data;
@end
