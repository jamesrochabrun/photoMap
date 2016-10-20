//
//  PhotoController.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//
#import "PhotoController.h"
@implementation PhotoController

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {
    
    
    if (!photo  || !size || !completion) {
        NSLog(@"%@, %@, %@", photo, size, completion);
        return;
    };
    
    NSString *prefixURL = [photo valueForKeyPath:@"response.venue.bestPhoto.prefix"];
    NSString *sufixURL = [photo valueForKeyPath:@"response.venue.bestPhoto.suffix"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", prefixURL, size, sufixURL];
    
    //CACHE
    NSString *key = urlString;
    
    UIImage *cachedPhoto = [[SAMCache sharedCache] imageForKey:key];
    
    if (cachedPhoto) {
       
        completion(cachedPhoto);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //its safer to create a nsdata before
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}

//THINK THAT THE COMPLETION IS JUST A METHOD PASSED AS AN ARGUMENT THAT BASICALLY IS LIKE THIS IN THIS CASE IT RETURMS A uiimage

//-(UIImage *)completion {
//    
//}

@end
