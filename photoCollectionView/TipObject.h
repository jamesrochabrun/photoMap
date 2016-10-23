//
//  TipObject.h
//  photoCollectionView
//
//  Created by James Rochabrun on 10/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipObject : NSObject
+ (TipObject *)tipFromString:(NSString *)text;
+ (NSString *)formatTips:(NSArray *)tips;
@property (nonatomic) NSString *text;

@end
