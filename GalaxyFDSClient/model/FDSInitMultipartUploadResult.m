//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSInitMultipartUploadResult.h"


@implementation FDSInitMultipartUploadResult {
  NSString *_bucketName;
  NSString *_objectName;
  NSString *_uploadId;
}
@synthesize bucketName = _bucketName;
@synthesize objectName = _objectName;
@synthesize uploadId = _uploadId;

- (id)initFromJson:(NSData *)data {
  NSError *error;
  id json = [NSJSONSerialization JSONObjectWithData:data
      options:NSJSONReadingMutableLeaves error:&error];
  if (error) {
    self = nil;
  } else {
    self = [super init];
    if (self) {
      _bucketName = json[@"bucketName"];
      _objectName = json[@"objectName"];
      _uploadId = json[@"uploadId"];
    }
  }
  return self;
}
@end
