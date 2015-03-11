//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSCommon.h"

@implementation FDSCommon
+ (NSString *)XIAOMI_HEADER_PREFIX {
  return @"x-xiaomi-";
}

+ (NSString *)XIAOMI_META_HEADER_PREFIX {
  return [NSString stringWithFormat:@"%@meta-", FDSCommon.XIAOMI_HEADER_PREFIX];
}

+ (NSString *)GALAXY_ACCESS_KEY_ID {
  return @"GalaxyAccessKeyId";
}

+ (NSString *)SIGNATURE {
  return @"Signature";
}

+ (NSString *)EXPIRES {
  return @"Expires";
}

+ (NSString *)CONTENT_MD5 {
  return @"content-md5";
}

+ (NSString *)CONTENT_TYPE {
  return @"content-type";
}

+ (NSString *)APPLICATION_OCTET_STREAM {
  return @"application/octet-stream";
}

+ (NSString *)ESTIMATED_OBJECT_SIZE {
  return [NSString stringWithFormat:@"%@estimated-object-size",
      FDSCommon.XIAOMI_HEADER_PREFIX];
}
@end
