//
//  NSString+Additional.h
//  
//
//  Created by archer on 15/4/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

/**
 * Returns the MD5 value of the string
 */
- (NSString*)md5;

- (NSString *)encodingURL;

@end
