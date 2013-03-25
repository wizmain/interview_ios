//
//  Utils.m
//  mClass
//
//  Created by 김규완 on 10. 12. 6..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "JSON.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SettingProperties.h"

@implementation Utils

+ (NSString *)dataFilePath:(NSString *)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:filename];
}

+ (void)saveLoginProperties:(LoginProperties *)loginProperties
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:loginProperties forKey:kLoginPropertiesKey];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath:kLoginPropertiesFilename] atomically:YES];
	[loginProperties release];
	[archiver release];
	[data release];
}

+ (LoginProperties *)loginProperties
{
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath:kLoginPropertiesFilename]];
	LoginProperties *loginProperties = nil;
	if (data == nil) {
		
	} else {
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		loginProperties = [unarchiver decodeObjectForKey:kLoginPropertiesKey];
		[unarchiver finishDecoding];
		
		[unarchiver release];
		[data release];	
	}

	return loginProperties;
}

+ (void)saveSettingProperties:(SettingProperties *)settingProperties
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:settingProperties forKey:kSettingPropertiesKey];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath:kSettingPropertiesFilename] atomically:YES];
	[settingProperties release];
	[archiver release];
	[data release];
}

+ (SettingProperties *)settingProperties
{
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath:kSettingPropertiesFilename]];
	SettingProperties *settingProperties = nil;
	if (data == nil) {
		
	} else {
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		settingProperties = [unarchiver decodeObjectForKey:kSettingPropertiesKey];
		[unarchiver finishDecoding];
		
		[unarchiver release];
		[data release];	
	}
	
	return settingProperties;
}

+ (NSString *)convertDateString:(NSNumber *)dateNumber formatString:(NSString *)format {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    long long time = [dateNumber longLongValue];
    time = time / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];

    return [dateFormat stringFromDate:date];
}


+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)cookieValue:(NSString *)cookieName {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if(cookieJar != nil){
        for (cookie in [cookieJar cookies]) {
            NSLog(@"Cookie name : %@ : value : %@", cookieName, cookie.value);
            if([cookie.name isEqualToString:cookieName]){
                return cookie.value;
            }
        }
    }
    return nil;
}

+ (bool)isNullString:(NSString *)checkString {
    if( checkString == (id)[NSNull null] || checkString.length == 0 ){
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isNumbericString:(NSString *)s {
    
    NSUInteger len = [s length];
    NSUInteger i;
    BOOL status = NO;
    
    for(i=0; i < len; i++)
    {
        unichar singlechar = [s characterAtIndex: i];
        if ( (singlechar == ' ') && (!status) )
        {
            continue;
        }
        if ( ( singlechar == '+' ||
              singlechar == '-' ) && (!status) ) { status=YES; continue; }
        if ( ( singlechar >= '0' ) &&
            ( singlechar <= '9' ) )
        {
            status = YES;
        } else {
            return NO;
        }
    }
    return (i == len) && status;
    
}

+ (BOOL) isNetworkReachable
{
	struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkFlagsReachable){
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isCellNetwork{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
	
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
	
    SCNetworkReachabilityFlags flag;
    SCNetworkReachabilityGetFlags(target, &flag);
	
    if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        return YES;
    }else {
        return NO;
    }
}

+ (NSString *)convertTimeFromSeconds:(int)secs {
    
    // Return variable.
    NSString *result = @"";
    
    // Int variables for calculation.
    //int secs = [seconds intValue];
    int tempHour    = 0;
    int tempMinute  = 0;
    int tempSecond  = 0;
    
    NSString *hour      = @"";
    NSString *minute    = @"";
    NSString *second    = @"";
    
    // Convert the seconds to hours, minutes and seconds.
    tempHour    = secs / 3600;
    tempMinute  = secs / 60 - tempHour * 60;
    tempSecond  = secs - (tempHour * 3600 + tempMinute * 60);
    
    hour    = [[NSNumber numberWithInt:tempHour] stringValue];
    minute  = [[NSNumber numberWithInt:tempMinute] stringValue];
    second  = [[NSNumber numberWithInt:tempSecond] stringValue];
    
    // Make time look like 00:00:00 and not 0:0:0
    if (tempHour < 10) {
        hour = [@"0" stringByAppendingString:hour];
    }
    
    if (tempMinute < 10) {
        minute = [@"0" stringByAppendingString:minute];
    }
    
    if (tempSecond < 10) {
        second = [@"0" stringByAppendingString:second];
    }
    
    if (tempHour == 0) {
        
        NSLog(@"Result of Time Conversion: %@:%@", minute, second);
        result = [NSString stringWithFormat:@"%@:%@", minute, second];
        
    } else {
        
        NSLog(@"Result of Time Conversion: %@:%@:%@", hour, minute, second);
        result = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, second];
        
    }
    
    return result;
    
}

+ (NSNumber *)fileSize:(NSString *)fileUrl {
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager]
                                attributesOfItemAtPath:fileUrl error:&error];
    
    if (!error) {
        return [attributes objectForKey:NSFileSize];
    } else {
        return nil;
    }
}


@end
