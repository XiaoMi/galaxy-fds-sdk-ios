//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSCommon.h"
#import "FDSPutObjectResult.h"


@implementation FDSPutObjectResult {
  NSString *_fdsServiceBaseUri;
  NSString *_bucketName;
  NSString *_objectName;
  NSString *_accessKeyId;
  NSString *_signature;
  NSString *_cdnServiceBaseUri;
  long long int _expires;
}
@synthesize fdsServiceBaseUri = _fdsServiceBaseUri;
@synthesize bucketName = _bucketName;
@synthesize objectName = _objectName;
@synthesize accessKeyId = _accessKeyId;
@synthesize signature = _signature;
@synthesize cdnServiceBaseUri = _cdnServiceBaseUri;
@synthesize expires = _expires;

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
      _accessKeyId = json[@"accessKeyId"];
      _signature = json[@"signature"];
      _expires = [json[@"expires"] longLongValue];
    }
  }
  return self;
}

- (NSString *)getRelativePresignedUri {
  return [NSString stringWithFormat:@"/%@/%@?%@=%@&%@=%lld&%@=%@",
      _bucketName, _objectName, FDSCommon.GALAXY_ACCESS_KEY_ID, _accessKeyId,
      FDSCommon.EXPIRES, _expires, FDSCommon.SIGNATURE, _signature];
}

- (NSString *)getAbsolutePresignedUri {
  return [NSString stringWithFormat:@"%@%@", _fdsServiceBaseUri,
          [self getRelativePresignedUri]];
}

- (NSString *)getCdnPresignedUri {
  return [NSString stringWithFormat:@"%@%@", _cdnServiceBaseUri,
          [self getRelativePresignedUri]];
}

@end
