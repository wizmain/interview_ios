//
//  ImageCache.m
//  mClass
//
//  Created by 김규완 on 10. 12. 6..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

@synthesize imgCache;

static ImageCache* sharedImageCache = nil;

+(ImageCache*)sharedImageCache {
    @synchronized([ImageCache class]){
        if (!sharedImageCache) {
            sharedImageCache = [[self alloc] init];
            return sharedImageCache;
        }
    }
    
    return nil;
}

+(id)alloc {
    @synchronized([ImageCache class]) {
        NSAssert(sharedImageCache == nil, @"Attempted to allocated a second instance of a singleton.");
        sharedImageCache = [super alloc];
        
        return sharedImageCache;
    }
}


- (void)addImage:(NSString *)imageUrl image:(UIImage *)image {
    [imgCache setObject:image forKey:imageUrl];
}

- (NSString *)getImage:(NSString *)imageUrl {
    return [imgCache objectForKey:imageUrl];
}

- (BOOL)isExist:(NSString *)imageUrl {
    if ([imgCache objectForKey:imageUrl] == nil) {
        return false;
    }
    
    return true;
}

@end