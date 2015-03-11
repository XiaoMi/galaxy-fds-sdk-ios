//
// Created by ss on 15-2-15.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSSubResource.h"

NSSet *SubResourceSet;

@implementation FDSSubResource {

}

+ (BOOL)hasSubResource:(NSString *)value {
  for (NSString *item in SubResourceSet) {
    if ([value isEqualToString:item]) {
      return YES;
    }
  }
  return NO;
}

+ (void)initialize {
  SubResourceSet = [NSSet setWithObjects:
      @"acl",
      @"quota",
      @"uploads",
      @"partNumber",
      @"uploadId",
      @"storageAccessToken",
      @"metadata",
      nil];
}

@end
