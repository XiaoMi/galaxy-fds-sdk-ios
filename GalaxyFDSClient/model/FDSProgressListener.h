//
// Created by ss on 15-2-12.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
* Listener interface for transfer progress events. The user of Galaxy FDS
* client should implement the abstract method by himself.
*/
@interface FDSProgressListener : NSObject

/**
 * Called when some bytes have been transferred since the last time it was
 * called and the progress interval has passed
 *
 * @param transferred
 *            The number of bytes transferred.
 * @param total
 *            The size of the object in bytes
 *
 */
- (void)onProgress:(long long)transferred underTotal:(long long)total;

/**
 * Should return how often transferred bytes should be reported to this
 * listener, in milliseconds. It is not guaranteed that updates will happen
 * at this exact interval, but that at least this amount of time will pass
 * between updates. The default implementation always returns 500 milliseconds.
 */
- (long long)progressInterval;
@end
