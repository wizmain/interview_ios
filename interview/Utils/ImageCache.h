//
//  ImageCache.h
//  interview
//
//  Created by 김규완 on 13. 3. 19..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *imgCache;

+ (ImageCache*)sharedImageCache;
- (void)addImage:(NSString *)imageUrl image:(UIImage *)image;
- (UIImage *)getImage:(NSString *)imageUrl;
- (BOOL)isExist:(NSString *)imageUrl;

@end
