//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSArgs.h"
#import "FDSCommon.h"
#import "FDSInitMultipartUploadResult.h"
#import "FDSHttpHeaders.h"
#import "FDSObjectInputStream.h"
#import "FDSRequestFactory.h"
#import "FDSThumbParam.h"
#import "FDSUploadPartResult.h"
#import "FDSUploadPartResultList.h"
#import "FDSUploadThreadObj.h"
#import "FDSUtilities.h"
#import "FDSXiaomiHeader.h"
#import "GalaxyFDSClient.h"

@implementation GalaxyFDSClient {
  FDSClientConfiguration *_config;
}

- (id)initWithConfig:(FDSClientConfiguration *)fdsConfig {
  if ((self = [super init])) {
    self->_config = fdsConfig;
  }
  return self;
}

- (FDSObjectMetadata *)getMetaDataOfObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName {
  [FDSArgs notEmpty:bucketName forName:@"bucket name"];
  [FDSArgs notEmpty:objectName forName:@"object name"];

  NSString *uriString = [NSString stringWithFormat:@"%@/%@/%@?metadata",
          [_config getBaseUri], bucketName, objectName];
  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:@"GET" andHeader:nil];

  NSHTTPURLResponse *response;
  NSError *error;

  [NSURLConnection sendSynchronousRequest:request returningResponse:&response
      error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to get metadata of object[%@/%@] from URI:%@."
        " Cause: %@", bucketName, objectName, uriString,
        [error localizedDescription]] userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200 && statusCode != 206) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to get metadata of object[%@/%@] from URI:%@."
        "Cause: %ld (%@)", bucketName, objectName, uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }

  FDSObjectMetadata *metadata = [FDSObjectMetadata parseObjectMetadata:
      [response allHeaderFields]];
  return metadata;
}

- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName {
  return [self getObject:objectName fromBucket:bucketName withOffset:0
      andParams:nil];
}

- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andParams:(NSArray *)params {
  return [self getObject:objectName fromBucket:bucketName withOffset:offset
      andParams:params andProgressListener:nil];
}

- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  return [self getObject:objectName fromBucket:bucketName withOffset:offset
      andLength:0 andParams:params andProgressListener:listener];
}

- (FDSObject *)getObject:(NSString *)objectName fromBucket:(NSString *)bucketName
    withOffset:(long long)offset andLength:(long long)length
    andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  [FDSArgs notEmpty:bucketName forName:@"bucket name"];
  [FDSArgs notEmpty:objectName forName:@"object name"];

  NSString *uriString = [NSString stringWithFormat:@"%@/%@/%@",
      [_config getDownloadBaseUri], bucketName, objectName];
  return [self getObjectOnURI:uriString withOffset:offset andLength:length
      andParams:params andProgressListener:listener];
}

- (FDSObject *)getObjectOnURI:(NSString *)uriString withOffset:(long long)offset
    andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  return [self getObjectOnURI:uriString withOffset:offset andLength:0
      andParams:params andProgressListener:listener];
}

- (FDSObject *)getObjectOnURI:(NSString *)uriString withOffset:(long long)offset
    andLength:(long long)length andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  [FDSArgs notEmpty:uriString forName:@"URI"];
  [FDSArgs notNegative:offset forName:@"offset in content"];
  [FDSArgs notNegative:length forName:@"length of content to get"];

  if (params) {
    NSMutableString *query = [NSMutableString stringWithString:uriString];
    for (id param in params) {
      if ([query rangeOfString:@"?"].location == NSNotFound) {
        [query appendString:@"?"];
      } else {
        [query appendString:@"&"];
      }
      [query appendString:[param description]];
    }
    uriString = query;
  }

  NSURL *uri = [NSURL URLWithString:uriString];
  NSString *path = [uri path];
  if ([path length] > 1) {
    path = [path substringFromIndex:1];
  }
  NSUInteger slashIndex = [path rangeOfString:@"/"].location;
  if (slashIndex == NSNotFound) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString stringWithFormat:
        @"Can't parse bucket name and object name from uriString:%@", uriString]
        userInfo:nil];
  }
  NSString *bucketName = [path substringToIndex:slashIndex];
  NSString *objectName = [path substringFromIndex:slashIndex + 1];

  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  if (length > 0 && ![self isGetThumbnail:params]) {
    NSString *range = length == 0 ?
        [NSString stringWithFormat:@"bytes=%lld-", offset] :
        [NSString stringWithFormat:@"bytes=%lld-%lld", offset,
                offset + length - 1];
    headers[[FDSHttpHeaders.RANGE lowercaseString]] = range;
  }

  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:@"GET" andHeader:headers];

  NSHTTPURLResponse *response;
  NSError *error;

  NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to get object[%@/%@] from URI:%@. Cause: %@",
        bucketName, objectName, uriString, [error localizedDescription]]
        userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200 && statusCode != 206) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to get object[%@/%@] from URI:%@. Cause: %ld "
        "(%@)", bucketName, objectName, uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }

  FDSObject *object = [[FDSObject alloc] initWithBucketName:bucketName
      andObjectName:objectName];
  FDSObjectMetadata *metadata = [FDSObjectMetadata parseObjectMetadata:
      [response allHeaderFields]];
  object.objectContent = [[FDSObjectInputStream alloc] initWithData:responseContent
      andMetadata:metadata andListener:listener];
  object.objectMetadata = metadata;
  return object;
}

- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile {
  return [self getObject:objectName fromBucket:bucketName toFile:destinationFile
      withParams:nil];
}

- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile
    withParams:(NSArray *)params {
  return [self getObject:objectName fromBucket:bucketName toFile:destinationFile
      withParams:params andProgressListener:nil];
}

- (FDSObjectMetadata *)getObject:(NSString *)objectName
    fromBucket:(NSString *)bucketName toFile:(NSString *)destinationFile
    withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  [FDSArgs notNil:destinationFile forName:@"Destination File Name"];

  int retriedTimes = 0;
  BOOL isGetThumbnail = [self isGetThumbnail:params];
  BOOL isAppend = NO;
  FDSObjectMetadata *metadata = [self getMetaDataOfObject:objectName
      fromBucket:bucketName];
  if (!metadata) {
    @throw [GalaxyFDSClientException exceptionWithReason:@"Cannot get the length"
        "of " userInfo:nil];
  }
  long long length = [[metadata getAllMetadata][FDSXiaomiHeader.CONTENT_LENGTH]
      longLongValue];
  [FDSArgs positive:length forName:@"length of object"];
  long long offset = 0;
  long long lastTime = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
  while (offset < length) {
    @try {
      isAppend = isAppend && !isGetThumbnail;
      long long partSize = [FDSUtilities min:_config.downloadPartSize
          and:length - offset];
      FDSObject *object = [self getObject:objectName fromBucket:bucketName
          withOffset:offset andLength:partSize
          andParams:params andProgressListener:nil];
      [FDSUtilities downloadObject:object toFile:destinationFile
          withAppendFlag:&isAppend];
      offset += [object.objectMetadata getContentLength];
      if (listener) {
        long long now = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
        if (now - lastTime >= [listener progressInterval] || offset == length) {
          lastTime = now;
          [listener onProgress:offset underTotal:length];
        }
      }
    } @catch (GalaxyFDSClientException *e) {
      if (++retriedTimes >= _config.maxRetryTimes) {
        @throw e;
      }
      offset = isAppend ? [FDSUtilities getFileLength:destinationFile] : 0;
    }
  }
  return metadata;
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName {
  return [self putObject:objectName intoBucket:bucketName fromFile:fileName
      withParams:nil];
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName
    withParams:(NSArray *)params {
  return [self putObject:objectName intoBucket:bucketName fromFile:fileName
      withParams:params andProgressListener:nil];
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromFile:(NSString *)fileName
    withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  [FDSArgs notNil:fileName forName:@"File Name"];

  NSError *error;
  NSDictionary *fileDescription = [FDSUtilities getFileDescription:fileName
      error:&error];
  if (error || !fileDescription) {
    @throw [GalaxyFDSClientException exceptionWithReason:
        [NSString stringWithFormat:@"Cannot retrieve file info of %@ because: %@",
        fileName, [error localizedDescription]] userInfo:[error userInfo]];
  }
  FDSObjectMetadata *metadata = [[FDSObjectMetadata alloc] init];
  [metadata setContentLength:[fileDescription fileSize]];
  [metadata setContentType:[FDSUtilities getFileMineType:fileName]];
  [metadata setLastModified:[fileDescription fileModificationDate]];
  return [self putObject:objectName intoBucket:bucketName
      fromInputStream: [[NSInputStream alloc] initWithFileAtPath:fileName]
      withObjectMetadata:metadata andParams:params andProgressListener:listener];
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata {
  return [self putObject:objectName intoBucket:bucketName fromInputStream:input
      withObjectMetadata:metadata andParams:nil];
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params {
  return [self putObject:objectName intoBucket:bucketName fromInputStream:input
      withObjectMetadata:metadata andParams:params andProgressListener:nil];
}

- (FDSPutObjectResult *)putObject:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  [FDSArgs notEmpty:bucketName forName:@"bucket name"];
  [FDSArgs notNil:input forName:@"input stream"];
  [FDSArgs notNil:metadata forName:@"metadata"];
  long long contentLength = [metadata getContentLength];
  [FDSArgs notNegative:contentLength forName:@"content length"];

  if (![metadata getContentType]) {
    [metadata setContentType:FDSCommon.APPLICATION_OCTET_STREAM];
  }

  NSString *uploadId;
  FDSObjectInputStream *objectInputStream = [[FDSObjectInputStream alloc]
      initWithStream:input andMetadata:metadata andListener:listener];
  @try {
    //choose buffered upload by set length 0 here when multi-threads used
    long long estimatedLength = _config.uploadThreadNumber > 1 ? 0 : contentLength;
    FDSInitMultipartUploadResult *initMultipartUploadResult =
        [self initiateMultipartUpload:objectName intoBucket:bucketName
            withLength:estimatedLength];
    // Object name may be nil
    objectName = initMultipartUploadResult.objectName;
    uploadId = initMultipartUploadResult.uploadId;
    [objectInputStream open];
    FDSUploadThreadObj *threadObj = [[FDSUploadThreadObj alloc]
        initWithClient:self bucketName:bucketName objectName:objectName
        fromStream:objectInputStream uploadId:uploadId
        objectLength:contentLength  partSize:_config.uploadPartSize];
    NSMutableArray *threadArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
      for (int i = 0; i < _config.uploadThreadNumber - 1 ; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:threadObj
            selector:@selector(upload:) object:nil];
        [thread setName:[NSString stringWithFormat:@"Thread%d", i]];
        [thread start];
        [threadArray addObject:thread];
      }
      [threadObj upload:nil];
      while (YES) {
        BOOL finished = YES;
        for (NSThread *thread in threadArray) {
          if (![thread isFinished]) {
            finished = NO;
            break;
          }
        }
        if (finished) {
          break;
        }
        [NSThread sleepForTimeInterval:1]; //sleep 1 second
      }
    }
    if (threadObj.exception) {
      @throw threadObj.exception;
    }
    FDSUploadPartResultList *uploadPartResultList =
        [[FDSUploadPartResultList alloc] init];
    uploadPartResultList.uploadPartResultList = threadObj.results;

    return [self completeMultipartUpload:objectName intoBucket:bucketName
        withId:uploadId andMetadata:metadata andResultList:uploadPartResultList
        andParams:params];
  } @catch (GalaxyFDSClientException *e) {
    if (uploadId) {
      [self abortMultipartUpload:objectName intoBucket:bucketName withId:uploadId];
    }
    @throw e;
  } @finally {
    @try {
      [objectInputStream close];
    } @catch (NSException *e) {
      //Ignore exception when close stream
    }
  }
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName {
  return [self putObjectToBucket:bucketName fromFile:fileName withParams:nil];
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName withParams:(NSArray *)params {
  return [self putObjectToBucket:bucketName fromFile:fileName withParams:params
      andProgressListener:nil];
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromFile:(NSString *)fileName withParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  return [self putObject:nil intoBucket:bucketName fromFile:fileName
      withParams:params andProgressListener:listener];
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata {
  return [self putObjectToBucket:bucketName fromInputStream:input
      withObjectMetadata:metadata andParams:nil];
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata andParams:(NSArray *)params {
  return [self putObjectToBucket:bucketName fromInputStream:input
      withObjectMetadata:metadata andParams:params andProgressListener:nil];
}

- (FDSPutObjectResult *)putObjectToBucket:(NSString *)bucketName
    fromInputStream:(NSInputStream *)input
    withObjectMetadata:(FDSObjectMetadata *)metadata
    andParams:(NSArray *)params
    andProgressListener:(FDSProgressListener *)listener {
  return [self putObject:nil intoBucket:bucketName fromInputStream:input
      withObjectMetadata:metadata andParams:params andProgressListener:listener];
}

- (BOOL)doesObject:(NSString *)objectName existInBucket:(NSString *)bucketName {
  [FDSArgs notEmpty:bucketName forName:@"bucket name"];
  [FDSArgs notEmpty:objectName forName:@"object name"];

  NSString *uriString = [NSString stringWithFormat:@"%@/%@/%@",
      [_config getBaseUri], bucketName, objectName];
  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:@"HEAD" andHeader:nil];
  NSHTTPURLResponse *response;
  NSError *error;
  [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:
        [NSString stringWithFormat:@"Unable to head object[%@/%@] from URI:%@. "
        "Cause: %@", bucketName, objectName, uriString,
        [error localizedDescription]] userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode == 200) {
    return YES;
  } else if (statusCode == 404) {
    return NO;
  } else {
    @throw [GalaxyFDSClientException exceptionWithReason: [NSString
        stringWithFormat:@"Unable to head object[%@/%@] from URI:%@. Cause: %ld "
        "(%@)", bucketName, objectName, uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }
}

- (BOOL)isGetThumbnail:(NSArray *)params {
  for (id param in params) {
    if ([param isKindOfClass:[FDSThumbParam class]]) {
      return YES;
    }
  }
  return NO;
}

- (id)initiateMultipartUpload:(NSString *)objectName
    intoBucket:(NSString *)bucketName
    withLength:(long long)estimatedSize {
  NSString *uriString = [NSString stringWithFormat:@"%@/%@/%@?uploads",
      [_config getUploadBaseUri], bucketName, objectName ? objectName : @""];

  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  headers[FDSCommon.ESTIMATED_OBJECT_SIZE] =
      [NSString stringWithFormat:@"%lld", estimatedSize];
  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:objectName ? @"PUT" : @"POST" andHeader:headers];
  NSHTTPURLResponse *response;
  NSError *error;
  NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to put object[%@/%@] to URI:%@. Cause: %@",
        bucketName, objectName, uriString, [error localizedDescription]]
        userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200) {
    @throw [GalaxyFDSClientException exceptionWithReason: [NSString
        stringWithFormat:@"Unable to upload object[%@/%@] to URI:%@. Fail to "
        "initiate multipart upload. Cause: %ld (%@)", bucketName, objectName,
        uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }
  FDSInitMultipartUploadResult *result = [[FDSInitMultipartUploadResult alloc]
      initFromJson:responseContent];
  if (!(result && result.uploadId && result.objectName && result.objectName)) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Fail to parse the result of init multipart upload. "
        "bucket name: %@, object name: %@", bucketName, objectName] userInfo:nil];
  }
  return result;
}

- (FDSUploadPartResult *)uploadPart:(NSString *)objectName
    intoBucket:(NSString *)bucketName fromStream:(FDSObjectInputStream *)input
    withId:(NSString *)uploadId andPartNumber:(int *)partNumber
    andLength:(long long)contentLength {
  uint8_t buffer[FDSClientConfiguration.DEFAULT_PART_SIZE];
  NSMutableData *data = [[NSMutableData alloc] initWithCapacity:
      (NSUInteger) contentLength];
  int index;
  @try {
    long long remainingBytes = contentLength;
    @synchronized (input) {
      while (remainingBytes > 0) {
        NSUInteger toReadBytes = (NSUInteger) [FDSUtilities min:
            FDSClientConfiguration.DEFAULT_PART_SIZE and:remainingBytes];
        NSInteger readBytes;
        readBytes = [input read:buffer maxLength:toReadBytes];
        if (readBytes == -1 || (readBytes == 0 && remainingBytes != 0)) {
          @throw [NSException exceptionWithName:@"IOException"
              reason:@"Stream read error" userInfo:nil];
        } else if (readBytes == 0) {
          break;
        }
        [data appendBytes:buffer length:(NSUInteger) readBytes];
        remainingBytes -= readBytes;
      }
      index = ++(*partNumber);
    }
  } @catch (NSException *e) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Fail to read data from input stream, size: %lld. "
        "Cause:%@", contentLength, [e reason]] userInfo:[e userInfo]];
  }

  NSString *uriString = [NSString stringWithFormat:
      @"%@/%@/%@?uploadId=%@&partNumber=%d", [_config getUploadBaseUri],
      bucketName, objectName, uploadId, index];

  int retriedTimes = 0;
  while (YES) {
    @try {
      id request = [FDSRequestFactory createRequest:uriString withConfig:_config
          andHTTPMethod:@"PUT" andHeader:nil];
      [request setHTTPBody:data];
      NSHTTPURLResponse *response;
      NSError *error;
      NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
          returningResponse:&response error:&error];
      if (error) {
        @throw [GalaxyFDSClientException exceptionWithReason:[NSString
            stringWithFormat:@"Fail to put part. URI:%@. Cause:%@", uriString,
            [error localizedDescription]] userInfo:[error userInfo]];
      }
      long statusCode = [response statusCode];
      if (statusCode != 200) {
        @throw [GalaxyFDSClientException exceptionWithReason:[NSString
            stringWithFormat:@"Unable to uplaod object[%@/%@] to URI: %@. Fail "
            "to upload part %d. Cause: %ld (%@)", bucketName, objectName,
            uriString, index, statusCode,
            [NSHTTPURLResponse localizedStringForStatusCode:statusCode]]
            userInfo:nil];
      }
      FDSUploadPartResult *result = [[FDSUploadPartResult alloc]
          initFromJson:responseContent];
      if (!(result && result.etag && result.partSize)) {
        @throw [GalaxyFDSClientException exceptionWithReason:[NSString
            stringWithFormat:@"Fail to part the result of uploading part. bucket"
            " name:%@, object name:%@, upload ID:%@", bucketName, objectName,
            uploadId] userInfo:nil];
      }
      return result;
    } @catch (GalaxyFDSClientException *e) {
      if (++retriedTimes >= _config.maxRetryTimes) {
        @throw e;
      }
    }
  }
}

- (FDSPutObjectResult *)completeMultipartUpload:(NSString *)objectName
    intoBucket:(NSString *)bucketName withId:(NSString *)uploadId
    andMetadata:(FDSObjectMetadata *)metadata
    andResultList:(FDSUploadPartResultList *)resultList
    andParams:(NSArray *)params {
  NSMutableString *uriString = [NSMutableString stringWithFormat:
      @"%@/%@/%@?uploadId=%@", [_config getUploadBaseUri], bucketName,
          objectName, uploadId];
  if (params) {
    for (FDSUserParam *param in params) {
      [uriString appendFormat:@"&%@", [param description]];
    }
  }

  NSDictionary *headers = nil;
  if (metadata) {
    headers = [metadata getAllMetadata];
  }

  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:@"PUT" andHeader:headers];
  [request setHTTPBody:[resultList toJson]];
  NSHTTPURLResponse *response;
  NSError *error;
  NSData *responseContent = [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Fail to complete multipart upload. URI:%@. Cause:%@",
        uriString, [error localizedDescription]] userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to uplaod object[%@/%@] to URI: %@. Fail to "
        "complete multipart upload. Cause: %ld (%@)", bucketName, objectName,
        uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }
  FDSPutObjectResult *result = [[FDSPutObjectResult alloc]
      initFromJson:responseContent];
  if (!(result && result.accessKeyId && result.signature && result.expires)) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Fail to parse the result of completing multipart "
        "uplaoad. bucket name:%@, object name:%@, upload ID:%@", bucketName,
        objectName, uploadId] userInfo:nil];
  }
  result.fdsServiceBaseUri = [_config getBaseUri];
  result.cdnServiceBaseUri = [_config getCdnBaseUri];
  return result;
}

- (void)abortMultipartUpload:(NSString *)objectName
    intoBucket:(NSString *)bucketName withId:(NSString *)uploadId {
  NSString *uriString = [NSString stringWithFormat:@"%@/%@/%@?uploadId=%@",
          [_config getUploadBaseUri], bucketName, objectName, uploadId];
  id request = [FDSRequestFactory createRequest:uriString withConfig:_config
      andHTTPMethod:@"DELETE" andHeader:nil];
  NSHTTPURLResponse *response;
  NSError *error;
  [NSURLConnection sendSynchronousRequest:request
      returningResponse:&response error:&error];
  if (error) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Fail to abort multipart upload. URI:%@. Cause:%@",
        uriString, [error localizedDescription]] userInfo:[error userInfo]];
  }
  long statusCode = [response statusCode];
  if (statusCode != 200) {
    @throw [GalaxyFDSClientException exceptionWithReason:[NSString
        stringWithFormat:@"Unable to uplaod object[%@/%@] to URI: %@. Fail to "
        "abort multipart upload. Cause: %ld (%@)", bucketName, objectName,
        uriString, statusCode,
        [NSHTTPURLResponse localizedStringForStatusCode:statusCode]] userInfo:nil];
  }
}

@end
