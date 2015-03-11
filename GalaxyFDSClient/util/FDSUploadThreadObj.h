//
// Created by ss on 15-2-28.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDSObjectInputStream.h"
#import "GalaxyFDSClientException.h"
@class GalaxyFDSClient;

@interface FDSUploadThreadObj : NSObject
@property (readonly)NSArray *results;
@property (readonly)GalaxyFDSClientException *exception;

- (id)initWithClient:(GalaxyFDSClient *)client bucketName:(NSString *)bucketName
    objectName:(NSString *)objectName fromStream:(FDSObjectInputStream *)input
    uploadId:(NSString *)uploadId objectLength:(long long)length
    partSize:(long long)partSize;

- (void)upload:(id)unused;
@end
