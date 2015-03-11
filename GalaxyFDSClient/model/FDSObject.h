/**
* Represents an object stored in Galaxy FDS. This object contains the data
* content and the object metadata stored by Galaxy FDS, such as content type,
* content length, etc.
*
* @see ObjectMetadata
*/

#import <Foundation/Foundation.h>
#import "FDSObjectInputStream.h"
#import "FDSObjectMetadata.h"

@interface FDSObject : NSObject
@property NSString *objectName;
@property NSString *bucketName;
@property FDSObjectMetadata *objectMetadata;
@property FDSObjectInputStream *objectContent;

- (FDSObject *)initWithBucketName:(NSString *)bucketName
    andObjectName:(NSString *)objectName;
@end

