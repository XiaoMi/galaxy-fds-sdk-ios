//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSObjectInputStream.h"

@implementation FDSObjectInputStream {
  NSInputStream *_inputStream;
  FDSProgressListener *_listener;
  FDSObjectMetadata *_metadata;
  long long _lastNotifyTime;
  long long _totalBytesRead;
}

- (id)initWithData:(NSData *)data andMetadata:(FDSObjectMetadata *)metadata
    andListener:(FDSProgressListener *)listener {
  return [self initWithStream:[[NSInputStream alloc] initWithData:data]
                  andMetadata:metadata
                  andListener:listener];
}

- (id)initWithStream:(NSInputStream *)stream
    andMetadata:(FDSObjectMetadata *)metadata
    andListener:(FDSProgressListener *)listener {
  self = [super init];
  if (self) {
    _inputStream = stream;
    _metadata = metadata;
    _listener = listener;
  }
  return self;
}

- (void)notifyLister:(BOOL)needsCheckTime {
  if (self->_listener) {
    long long now = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
    if (!needsCheckTime || _totalBytesRead == [_metadata getContentLength] ||
      now - _lastNotifyTime >= [self->_listener progressInterval]) {
      _lastNotifyTime = now;
      [self->_listener onProgress:_totalBytesRead
          underTotal:[_metadata getContentLength]];
    }
  }
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
  NSInteger bytesRead = [_inputStream read:buffer maxLength:len];
  if (bytesRead > 0) {
    _totalBytesRead += bytesRead;
    [self notifyLister:true];
  }
  return bytesRead;
}

- (void)open {
  [_inputStream open];
}

- (void)close {
  [_inputStream close];
}
@end
