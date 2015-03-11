//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSInitMultipartUploadResult : NSObject
@property NSString *bucketName;
@property NSString *objectName;
@property NSString *uploadId;

- (id)initFromJson:(NSData *)data;
@end
