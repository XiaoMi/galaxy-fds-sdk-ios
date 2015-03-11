//
// Created by ss on 15-3-3.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSXiaomiHeader.h"
#import "FDSCommon.h"

@implementation FDSXiaomiHeader {

}
+ (NSString *)DATE {
  return [NSString stringWithFormat:@"%@date", FDSCommon.XIAOMI_HEADER_PREFIX];
}

+ (NSString *)REQUEST_ID {
  return [NSString stringWithFormat:@"%@request-id",
          FDSCommon.XIAOMI_HEADER_PREFIX];
}

+ (NSString *)ACL {
  return [NSString stringWithFormat:@"%@acl", FDSCommon.XIAOMI_HEADER_PREFIX];
}

+ (NSString *)CONTENT_LENGTH {
  return [NSString stringWithFormat:@"%@content-length",
          FDSCommon.XIAOMI_META_HEADER_PREFIX];
}
@end
