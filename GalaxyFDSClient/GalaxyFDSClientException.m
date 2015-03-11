//
// Created by ss on 15-2-15.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "GalaxyFDSClientException.h"


@implementation GalaxyFDSClientException {

}
+ (id)exceptionWithReason:(NSString *)reason userInfo:(NSDictionary *)info {
  return [GalaxyFDSClientException exceptionWithName:@"GalaxyFDSClientException"
      reason:reason userInfo:info];
}

@end
