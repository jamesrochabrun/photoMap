//
//  DetailViewController.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/19/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VenueObject;

@interface DetailViewController : UIViewController
@property (nonatomic) NSDictionary *photoDict;
@property (nonatomic) NSString *tipString;
@property (nonatomic) VenueObject *venue;

@end
