//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GalaxyFDSCredential.h"

@interface FDSClientConfiguration : NSObject
/**
 * The maximum number of retry attempts for failed requests, used by
 * putObject and getObject:toFile
 */
@property int maxRetryTimes;

/**
 * Time out milliseconds by underlying connection
 */
@property int timeoutMs;

/**
 * The credential information of FDS client
 * NOTE: MUST set credential information before calling any method of Client
 */
@property NSObject <GalaxyFDSCredential> *credential;

@property NSString *regionName;

@property BOOL isHttpsEnabled;

@property BOOL isCdnEnabledForUpload;

@property BOOL isCdnEnabledForDownload;

@property int uploadPartSize;

@property int uploadThreadNumber;

@property int downloadPartSize;

+ (int)DEFAULT_PART_SIZE;

- (NSString *)getBaseUri;

- (NSObject *)getDownloadBaseUri;

- (NSObject *)getUploadBaseUri;

- (NSString *)buildBaseUri:(BOOL)enableCdn;

- (NSString *)getCdnBaseUri;
@end
