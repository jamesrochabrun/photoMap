//
//  SessionManager.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SessionManager : NSObject
- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;

@end
