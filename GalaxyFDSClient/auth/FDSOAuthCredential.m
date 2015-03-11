//
// Created by ss on 15-2-27.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSHttpHeaders.h"
#import "FDSOAuthCredential.h"
#import "FDSStorageAccessToken.h"
#import "GalaxyFDSClientException.h"

static NSString *STORAGE_ACCESS_TOKEN = @"storageAccessToken";
static NSString *APP_ID = @"appId";
static NSString *OAUTH_APPID = @"oauthAppId";
static NSString *OAUTH_ACCESS_TOKEN = @"oauthAccessToken";
static NSString *OAUTH_PROVIDER = @"oauthProvider";
static NSString *OAUTH_MAC_KEY = @"oauthMacKey";
static NSString *OAUTH_MAC_ALGORITHM = @"oauthMacAlgorithm";
static NSString *HEADER_VALUE = @"OAuth";

@implementation FDSOAuthCredential {
  NSString *_appId;
  FDSStorageAccessToken *_storageAccessToken;
}

- (id)initWithURI:(NSString *)fdsServiceBaseUri appId:(NSString *)appId
    oauthAppId:(NSString *)oauthAppId token:(NSString *)oauthAccessToken
    provider:(NSString *)oauthProvider macKey:(NSString *)macKey
    algorithm:(NSString *)macAlgorithm {
  self = [super init];
  if (self) {
    _appId = appId;
    _storageAccessToken = [self getStorageAccessTokenWithUri:fdsServiceBaseUri
        appId:appId oauthAppId:oauthAppId token:oauthAccessToken
        provider:oauthProvider macKey:macKey algorithm:macAlgorithm];
  }
  return self;
}

- (FDSStorageAccessToken *)getStorageAccessTokenWithUri:(NSString *)serviceBaseUri
    appId:(NSString *)appId oauthAppId:(NSString *)oauthAppId
    token:(NSString *)oauthAccessToken provider:(NSString *)oauthProvider
    macKey:(NSString *)macKey algorithm:(NSString *)macAlgorithm {
  NSString *uriString = [NSString stringWithFormat:
      @"%@/?%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", serviceBaseUri,
      STORAGE_ACCESS_TOKEN, APP_ID, _appId, OAUTH_APPID, oauthAppId,
      OAUTH_ACCESS_TOKEN, oauthAccessToken, OAUTH_PROVIDER, oauthProvider,
      OAUTH_MAC_ALGORITHM, macAlgorithm, OAUTH_MAC_KEY, macKey];
  id request = [NSMutableURLRequest requestWithURL:
      [NSURL URLWithString:uriString]];
  [request addValue:HEADER_VALUE forHTTPHeaderField:FDSHttpHeaders.AUTHORIZATION];
  NSHTTPURLResponse *response;
  NSError *error;
  NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:
        [NSString stringWithFormat:@"Failed to get the storage access token"
        "Cause: %@", [error localizedDescription]] userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200) {
    @throw [GalaxyFDSClientException exceptionWithReason:
        [NSString stringWithFormat:@"Failed to get the storage access token from"
        " FDS server. URI:%@. Cause: %ld (%@)", uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }
  id token = [[FDSStorageAccessToken alloc] initFromJson:responseContent];
  return token;
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
  [uriString appendFormat:@"%@=%@&%@=%@", APP_ID, _appId, STORAGE_ACCESS_TOKEN,
      _storageAccessToken.token];
  return uriString;
}
@end
