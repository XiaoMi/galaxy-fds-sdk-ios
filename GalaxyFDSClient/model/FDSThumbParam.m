//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSThumbParam.h"


@implementation FDSThumbParam
- (id)initWithWidth:(int)width andHeight:(int)height {
  self = [super init];
  if (self) {
    _params[@"thumb"] = @"1";
    _params[@"w"] = [NSString stringWithFormat:@"%d", width];
    _params[@"h"] = [NSString stringWithFormat:@"%d", height];
  }
  return self;
}

@end
