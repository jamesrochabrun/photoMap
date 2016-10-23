//
//  TipObject.m
//  photoCollectionView
//
//  Created by James Rochabrun on 10/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "TipObject.h"
#import "Common.h"

@implementation TipObject


+ (TipObject *)tipFromString:(NSString *)text {
    TipObject *tip = [TipObject new];
    tip.text = parseStringOrNullFromServer(text);
    return tip;
}

+ (NSString *)formatTips:(NSArray *)tips {
    
    NSMutableString *tipString = [[NSMutableString alloc] initWithString:@"Tips:\n\n"];
    
    for (TipObject *tip in tips) {
        [tipString appendString:[NSString stringWithFormat:@"*%@\n\n", tip.text]];
    }
    return (NSString *)tipString;
}


@end
