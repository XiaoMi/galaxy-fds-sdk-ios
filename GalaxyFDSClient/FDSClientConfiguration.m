//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//
#import "FDSClientConfiguration.h"
#import "util/FDSArgs.h"

static NSString *URI_HTTP_PREFIX = @"http://";
static NSString *URI_HTTPS_PREFIX = @"https://";
static NSString *URI_SUFFIX = @"fds.api.xiaomi.com";
static NSString *URI_CDN_SUFFIX = @"fds.api.mi-img.com";
static int DEFAULT_TIMEOUT_MS = 50 * 1000;
static int DEFAULT_MAX_RETRY_TIMES = 3;

@implementation FDSClientConfiguration {
  int _maxRetryTimes;
  int _uploadPartSize;
  int _uploadThreadNumber;
  int _timeoutMs;
  NSObject <GalaxyFDSCredential> *_credential;
  NSString *_regionName;
  BOOL _isHttpsEnabled;
  BOOL _isCdnEnabledForUpload;
  BOOL _isCdnEnabledForDownload;
@private
  int _downloadPartSize;
}

@synthesize timeoutMs = _timeoutMs;
@synthesize regionName = _regionName;
@synthesize isHttpsEnabled = _isHttpsEnabled;
@synthesize isCdnEnabledForUpload = _isCdnEnabledForUpload;
@synthesize isCdnEnabledForDownload = _isCdnEnabledForDownload;

@synthesize downloadPartSize = _downloadPartSize;

- (NSObject <GalaxyFDSCredential> *)credential {
  return _credential;
}

- (void)setCredential:(NSObject <GalaxyFDSCredential> *)credential {
  [FDSArgs notNil:credential forName:@"credential"];
  _credential = credential;
}

- (int)maxRetryTimes {
  return _maxRetryTimes;
}

- (void)setMaxRetryTimes:(int)maxRetryTimes {
  [FDSArgs notNegative:maxRetryTimes forName:@"max retry times"];
  _maxRetryTimes = maxRetryTimes;
}

- (int)uploadPartSize {
  return _uploadPartSize;
}

- (void)setUploadPartSize:(int)uploadPartSize {
  [FDSArgs positive:uploadPartSize forName:@"upload part size"];
  _uploadPartSize = uploadPartSize;
}

- (int)uploadThreadNumber {
  return _uploadThreadNumber;
}

- (void)setUploadThreadNumber:(int)uploadThreadNumber {
  [FDSArgs positive:uploadThreadNumber forName:@"upload thread number"];
  _uploadThreadNumber = uploadThreadNumber;
}

- (id)init {
  self = [super init];
  if (self) {
    _timeoutMs = DEFAULT_TIMEOUT_MS;
    _maxRetryTimes = DEFAULT_MAX_RETRY_TIMES;
    _uploadPartSize = FDSClientConfiguration.DEFAULT_PART_SIZE;
    _downloadPartSize = FDSClientConfiguration.DEFAULT_PART_SIZE;
    _uploadThreadNumber = 1;

    _regionName = @"cnbj0";
    _isHttpsEnabled = YES;
    _isCdnEnabledForUpload = NO;
    _isCdnEnabledForDownload = YES;
  }
  return self;
}

- (NSString *)getBaseUri {
  return [self buildBaseUri:NO];
}

- (NSString *)getCdnBaseUri {
  return [self buildBaseUri:YES];
}

- (NSObject *)getDownloadBaseUri {
  return [self buildBaseUri:_isCdnEnabledForDownload];
}

- (NSObject *)getUploadBaseUri {
  return [self buildBaseUri:_isCdnEnabledForUpload];
}

- (NSString *)buildBaseUri:(BOOL)enableCdn {
  return [NSString stringWithFormat:@"%@%@%@.%@",
      _isHttpsEnabled ? URI_HTTPS_PREFIX : URI_HTTP_PREFIX,
      enableCdn ? @"cdn." : @"",
      _regionName,
      enableCdn ? URI_CDN_SUFFIX : URI_SUFFIX];
}

+ (int)DEFAULT_PART_SIZE {
  return 1024 * 128;
}
@end
