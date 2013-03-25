//
//  NSNumber+NSNumber_Helpers.m
//  interview
//
//  Created by 김규완 on 13. 3. 14..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "NSNumber+NSNumber_Helpers.h"

@implementation NSNumber (NSNumber_Helpers)

+ (NSString *)displayFileFormat:(NSNumber *)size {
    
    double convertedValue = [size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"Byte",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];

}

@end
