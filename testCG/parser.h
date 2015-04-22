//
//  parser.h
//  testCG
//
//  Created by apple on 12.04.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface parser : NSObject
+ (NSArray *)parseTxt;
+ (NSArray *)extractDataToSevenDays:(NSArray *)dayArray andRateArray:rateArray;
@end
