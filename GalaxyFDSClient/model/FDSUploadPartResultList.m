//
// Created by ss on 15-2-25.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSUploadPartResult.h"
#import "FDSUploadPartResultList.h"


@implementation FDSUploadPartResultList {
  NSArray *_uploadPartResultList;
}
@synthesize uploadPartResultList = _uploadPartResultList;

- (NSData *)toJson {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  for (FDSUploadPartResult *result in _uploadPartResultList) {
    [array addObject:[result toJsonPart]];
  }
  NSDictionary *dictionary = @{@"uploadPartResultList" : array};
  NSError *error;
  NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary
      options:NSJSONWritingPrettyPrinted error:&error];
  if (error) {
    return nil;
  }
  return json;
}
@end
