//
// Created by ss on 15-2-13.
// Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "FDSRequestFactory.h"
#import "FDSHttpHeaders.h"
#import "FDSUtilities.h"

@implementation FDSRequestFactory {

}
+ (NSURLRequest *)createRequest:(NSString *)uri
    withConfig:(FDSClientConfiguration *)config andHTTPMethod:(NSString *)method
    andHeader:(NSDictionary *)headers {
  uri = [config.credential addParamToURI:uri];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
      [NSURL URLWithString:uri]];
  request.timeoutInterval = config.timeoutMs / 1000;
  request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  request.HTTPMethod = method;
  [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if (![key isEqual:FDSHttpHeaders.CONTENT_LENGTH]) {
      [request addValue:obj forHTTPHeaderField:[key lowercaseString]];
    }
  }];
  [request addValue:[FDSUtilities formatDateString:[NSDate date]]
      forHTTPHeaderField:[FDSHttpHeaders.DATE lowercaseString]];
  [config.credential addHeaderToRequest:request];
  return request;
}
@end
