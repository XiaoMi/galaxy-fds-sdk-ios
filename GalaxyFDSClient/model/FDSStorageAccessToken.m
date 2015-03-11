//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSStorageAccessToken.h"


@implementation FDSStorageAccessToken {
  NSString *_token;
  long long int _expireTime; //ms
}
@synthesize token = _token;
@synthesize expireTime = _expireTime;

- (id)initWithToken:(NSString *)token andExpireTime:(long long)expireTime {
  self = [super init];
  if (self) {
    _token = token;
    _expireTime = expireTime;
  }
  return self;
}

- (id)initFromJson:(NSData *)data {
  NSError *error;
  id json = [NSJSONSerialization JSONObjectWithData:data
      options:NSJSONReadingMutableLeaves error:&error];
  if (error) {
    self = nil;
  } else {
    self = [super init];
    if (self) {
      _token = json[@"token"];
      _expireTime = [json[@"objectName"] longLongValue];
    }
  }
  return self;
}
@end
