#import "FDSOAuthCredential.h"
#import "FDSSSOCredential.h"
#import "GalaxyFDSClient.h"
#import "GalaxyFDSClientException.h"

// This is a simple demo for FDS iOS SDK, note that before use iOS
// sdk, you should do the following preparation:
//    1. Create the bucket which you want to upload your object
//    2. Grant proper bucket permission for your 'app'

static id getSSOCredential() {
  NSString *appId = @"your_app_id";
  NSString *ssoServiceToken = @"your_sso_service_token";
  return [[FDSSSOCredential alloc] initWithToken:ssoServiceToken andAppId:appId];
}

static id getOAuthCredential(NSString *serviceUri) {
  NSString *APP_ID = @"your_app_id";
  NSString *OAUTH_APP_ID = @"your_oauth_app_id";
  NSString *OAUTH_PROVIDER = @"XiaoMi";
  NSString *OAUTH_MAC_ALGORITHM = @"HmacSHA1";
  NSString *OAUTH_MAC_KEY = @"your_oauth_mac_key";
  NSString *OAUTH_ACCESS_TOKEN = @"your_oauth_access_token";
  return [[FDSOAuthCredential alloc] initWithURI:serviceUri
      appId:APP_ID oauthAppId:OAUTH_APP_ID token:OAUTH_ACCESS_TOKEN
      provider:OAUTH_PROVIDER macKey:OAUTH_MAC_KEY
      algorithm:OAUTH_MAC_ALGORITHM];
}

@interface ExampleListener : FDSProgressListener
@end

@implementation ExampleListener
- (void)onProgress:(long long)transferred underTotal:(long long)total {
  NSLog(@"%lld of %lld\n", transferred, total);
}
@end

static NSString *BUCKET_NAME = @"ios-sdk-example";

int main(int argc, const char *argv[]) {
  @try {
    @autoreleasepool {
      id listener = [[ExampleListener alloc] init];
      // ==== SSO ====
      FDSClientConfiguration *ssoConfig = [[FDSClientConfiguration alloc] init];
      ssoConfig.credential = getSSOCredential();
      ssoConfig.uploadThreadNumber = 5;
      GalaxyFDSClient *ssoClient = [[GalaxyFDSClient alloc]
          initWithConfig:ssoConfig];

      // Put an object to a specified bucket with a given name, if the object
      // already exists, it will be override.
      NSString *objectContent = @"This is a simple test object";
      NSData *data = [objectContent dataUsingEncoding:NSUTF8StringEncoding];
      NSInputStream *inputStream = [NSInputStream inputStreamWithData:data];
      NSString *objectName = [NSString stringWithFormat:@"text-object%lld",
          (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
      FDSObjectMetadata *metadata = [[FDSObjectMetadata alloc] init];
      [metadata setContentType:@"plain/text"];
      [metadata setContentLength:(long long)[data length]];

      [ssoClient putObject:objectName intoBucket:BUCKET_NAME
          fromInputStream:inputStream withObjectMetadata:metadata];
      //Download the object with the bucket name and object name specified
      FDSObject *object = [ssoClient getObject:objectName fromBucket:BUCKET_NAME
        withOffset:0 andParams:nil andProgressListener:listener];
      long long receivedLength = [object.objectMetadata getContentLength];
      uint8_t buffer[receivedLength];
      long long offset = 0;
      [object.objectContent open];
      while (offset < receivedLength) {
        long long readBytes = [object.objectContent read:buffer + offset
            maxLength:(NSUInteger) (receivedLength - offset)];
        if (readBytes <= 0) {
          NSLog(@"get object content error!");
          exit(-1);
        }
        offset += readBytes;
      }
      NSString *receivedString = [[NSString alloc] initWithBytes:buffer
          length:(NSUInteger) receivedLength encoding:NSUTF8StringEncoding];
      NSLog(@"%@\n", receivedString);

      // ===== OAuth ======
      // Put an object to a specified bucket, the server will generate an unique
      // object name for the object.
      FDSClientConfiguration *oauthConfig = [[FDSClientConfiguration alloc] init];
      oauthConfig.credential = getOAuthCredential([oauthConfig getBaseUri]);
      GalaxyFDSClient *oauthClient = [[GalaxyFDSClient alloc]
          initWithConfig:oauthConfig];
      inputStream = [[NSInputStream alloc] initWithData:data];
      FDSPutObjectResult *result = [oauthClient putObjectToBucket:BUCKET_NAME
          fromInputStream:inputStream withObjectMetadata:metadata andParams:nil
          andProgressListener:listener];
      NSLog(@"%@\n", result.objectName);

      // Download the object with the bucket name and object name specified
      object = [oauthClient getObject:result.objectName fromBucket:BUCKET_NAME];
      receivedLength = [object.objectMetadata getContentLength];
      offset = 0;
      [object.objectContent open];
      while (offset < receivedLength) {
        long long readBytes = [object.objectContent read:buffer + offset
            maxLength:(NSUInteger) (receivedLength - offset)];
        if (readBytes <= 0) {
          NSLog(@"get object content error!");
          exit(-1);
        }
        offset += readBytes;
      }
      receivedString = [[NSString alloc] initWithBytes:buffer
          length:(NSUInteger) receivedLength encoding:NSUTF8StringEncoding];
      NSLog(@"%@\n", receivedString);
    }
    return 0;
  } @catch (GalaxyFDSClientException *e){
    NSLog(@"error:%@", [e reason]);
    return -1;
  }
}
