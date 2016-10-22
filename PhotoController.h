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
@class VenueObject;

@interface PhotoController : NSObject
+ (void)imageForPhoto:(VenueObject *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
