//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSSignatureCredential.h"
#import "FDSUtilities.h"
#import "FDSHttpHeaders.h"
#import "FDSSigner.h"

@implementation FDSSignatureCredential {
  NSString *_accessKeyId;
  NSString *_secretAccessKeyId;
}

- (id)initWithAccessKeyId:(NSString *)accessKeyId
    andSecretAccessKeyId:(NSString *)secretAccessKeyId {
  self = [super init];
  if (self) {
    self->_accessKeyId = accessKeyId;
    self->_secretAccessKeyId = secretAccessKeyId;
  }
  return self;
}

- (void)addHeaderToRequest:(NSMutableURLRequest *)request {
  [request setValue:[FDSUtilities formatDateString:[NSDate date]]
      forHTTPHeaderField:FDSHttpHeaders.DATE];
  NSString *signature = [FDSSigner signToBase64withMethod:[request HTTPMethod]
      andURI:[request URL] andHeaders:[request allHTTPHeaderFields]
      andAccessSecret:_secretAccessKeyId usingAlgorithm:kCCHmacAlgSHA1];
  [request setValue:[NSString stringWithFormat:@"Galaxy-V2 %@:%@", _accessKeyId,
      signature] forHTTPHeaderField:FDSHttpHeaders.AUTHORIZATION];
}

- (NSString *)addParamToURI:(NSString *)uri {
  return uri;
}

@end
