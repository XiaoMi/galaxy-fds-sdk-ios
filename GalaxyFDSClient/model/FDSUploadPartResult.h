//
// Created by ss on 15-2-25.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSUploadPartResult : NSObject
@property int partNumber;
@property NSString *etag;
@property long long partSize;

- (id)initWithNumber:(int)partNumber partSize:(long long)size eTag:(NSString *)tag;

- (id)initFromJson:(NSData *)data;

- (id)toJsonPart;
@end

