//
// Created by ss on 15-2-28.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSUploadThreadObj.h"
#import "FDSUtilities.h"
#import "GalaxyFDSClient.h"

@implementation FDSUploadThreadObj {
  __weak GalaxyFDSClient *_client;
  NSString *_bucketName;
  NSString *_objectName;
  __weak FDSObjectInputStream *_stream;
  NSString *_uploadId;
  long long _remainingLength;
  long long _partSize;
  int _partId;
  NSMutableArray *_results;
  GalaxyFDSClientException *_exception;
}

@synthesize results = _results;
@synthesize exception = _exception;

- (id)initWithClient:(GalaxyFDSClient *)client bucketName:(NSString *)bucketName
    objectName:(NSString *)objectName fromStream:(FDSObjectInputStream *)input
    uploadId:(NSString *)uploadId objectLength:(long long)length
    partSize:(long long)partSize{
  self = [super init];
  if (self) {
    _client = client;
    _bucketName = bucketName;
    _objectName = objectName;
    _stream = input;
    _uploadId = uploadId;
    _remainingLength = length;
    _partSize = partSize;
    _partId = 0;
    _results = [[NSMutableArray alloc] init];
    _exception = nil;
  }
  return self;
}

- (void)upload:(id)unused {
  long long partSize;
  while (YES) {
    @synchronized (self) {
      if (_exception) {
        return;
      }
      if (_remainingLength == 0) {
        return;
      }
      partSize = [FDSUtilities min:_partSize and:_remainingLength];
      _remainingLength -= partSize;
    }
    @try {
      id result = [_client uploadPart:_objectName intoBucket:_bucketName
          fromStream:_stream withId:_uploadId andPartNumber:&_partId
          andLength:partSize];
      [_results addObject:result];
    } @catch (GalaxyFDSClientException *e) {
      @synchronized (self) {
        if (!_exception) {
          _exception = e;
        }
      }
      return;
    }
  }
}

@end
