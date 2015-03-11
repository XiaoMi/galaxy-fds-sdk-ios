//
// Created by ss on 15-2-10.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FDSObjectMetadata.h"
#import "FDSProgressListener.h"


@interface FDSObjectInputStream : NSObject
- (id)initWithData:(NSData *)data andMetadata:(FDSObjectMetadata *)metadata
    andListener:(FDSProgressListener *)listener;

- (id)initWithStream:(NSInputStream *)stream
    andMetadata:(FDSObjectMetadata *)metadata
    andListener:(FDSProgressListener *)listener;

- (void)notifyLister:(BOOL)needsCheckTime;

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;

- (void)open;

- (void)close;
@end
