//
// Created by ss on 15-2-25.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSUploadPartResult.h"


@implementation FDSUploadPartResult {
  int _partNumber;
  NSString *_etag;
  long long int _partSize;
}
@synthesize partNumber = _partNumber;
@synthesize etag = _etag;
@synthesize partSize = _partSize;

- (id)initWithNumber:(int)partNumber partSize:(long long)size eTag:(NSString *)tag {
  self = [super init];
  if (self) {
    _partNumber = partNumber;
    _partSize = size;
    _etag = tag;
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
      _partNumber = [json[@"partNumber"] intValue];
      _partSize = [json[@"partSize"] longLongValue];
      _etag = json[@"etag"];
    }
  }
  return self;
}

- (id)toJsonPart {
  return @{@"partNumber" : @(_partNumber), @"etag" : _etag,
      @"partSize" : @(_partSize)};
}
@end
