//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSObject.h"


@implementation FDSObject {
  NSString *_objectName;
  NSString *_bucketName;
  FDSObjectMetadata *_objectMetadata;
  FDSObjectInputStream *_objectContent;
}

@synthesize objectName = _objectName;
@synthesize bucketName = _bucketName;
@synthesize objectMetadata = _objectMetadata;
@synthesize objectContent = _objectContent;

- (FDSObject *)initWithBucketName:(NSString *)bucketName
    andObjectName:(NSString *)objectName {
  self = [super init];
  if (self) {
    _bucketName = bucketName;
    _objectName = objectName;
  }
  return self;
}
@end
