//
//  PhotoController.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>
#import <SimpleAuth/SimpleAuth.h>

@class VenueObject;

extern NSString *const DATA_VERSION_DATE;
extern NSString *const DATA_FORMAT;
extern NSString *const HTTPURLVERSION;

@interface PhotoController : NSObject
@property (nonatomic) NSString *accessToken;
+ (void)imageForPhoto:(VenueObject *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

- (void)accessTokenWithcompletion:(void (^)(BOOL finished))completion;


@end
