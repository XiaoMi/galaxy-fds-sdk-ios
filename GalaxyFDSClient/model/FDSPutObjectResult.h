//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSPutObjectResult : NSObject
@property NSString *bucketName;
@property NSString *objectName;
@property NSString *accessKeyId;
@property NSString *signature;
@property NSString *fdsServiceBaseUri;
@property NSString *cdnServiceBaseUri;
@property long long expires;

- (id)initFromJson:(NSData *)data;

- (NSString *)getRelativePresignedUri;

- (NSString *)getAbsolutePresignedUri;

- (NSString *)getCdnPresignedUri;
@end
