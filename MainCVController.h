//
//  MainCVController.h
//  photoCollectionView
//
//  Created by James Rochabrun on 8/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"


@interface MainCVController : UICollectionViewController
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *likedArrayIDS;
@property (nonatomic) NSMutableArray *venueArray;

@end
