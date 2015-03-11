//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSUserParam.h"


@implementation FDSUserParam;
@synthesize params = _params;

- (id)init {
  self = [super init];
  if (self) {
    self->_params = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (NSString *)description {
  NSMutableString *string = [[NSMutableString alloc] init];
  [_params enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
    if (val) {
      [string appendFormat:@"&%@=%@", key, val];
    } else {
      [string appendFormat:@"&%@", key];
    }
  }];
  if ([string length] > 0) {
    return [string substringFromIndex:1];
  }
  return nil;
}

@end
