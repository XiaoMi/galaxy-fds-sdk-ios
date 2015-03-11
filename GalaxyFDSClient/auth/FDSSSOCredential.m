//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSArgs.h"
#import "FDSHttpHeaders.h"
#import "FDSSSOCredential.h"

static NSString *HEADER_VALUE = @"SSO";
static NSString *SERVICE_TOKEN_PARAM = @"serviceToken";
static NSString *APP_ID = @"appId";

@implementation FDSSSOCredential {
  NSString *_appId;
  NSString *_serviceToken;
}

- (id)initWithToken:(NSString *)serviceToken {
  [FDSArgs notEmpty:serviceToken forName:@"Service token"];
  self = [super init];
  if (self) {
    _serviceToken = serviceToken;
    _appId = nil;
  }
  return self;
}

- (id)initWithToken:(NSString *)serviceToken andAppId:(NSString *)appId {
  [FDSArgs notEmpty:serviceToken forName:@"Service token"];
  [FDSArgs notEmpty:appId forName:@"App id"];
  self = [super init];
  if (self) {
    _serviceToken = serviceToken;
    _appId = appId;
  }
  return self;
}

- (void)addHeaderToRequest:(NSMutableURLRequest *)request {
  [request addValue:HEADER_VALUE forHTTPHeaderField:FDSHttpHeaders.AUTHORIZATION];
}

- (NSString *)addParamToURI:(NSString *)uri {
  NSMutableString *uriString = [NSMutableString stringWithString:uri];
  if ([uriString rangeOfString:@"?"].location == NSNotFound) {
    [uriString appendString:@"?"];
  } else {
    [uriString appendString:@"&"];
  }
  [uriString appendFormat:@"%@=%@", SERVICE_TOKEN_PARAM, _serviceToken];

  if (_appId) {
    [uriString appendFormat:@"&%@=%@", APP_ID, _appId];
  }
  return uriString;
}

@end
