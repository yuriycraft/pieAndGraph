//
//  parser.m
//  testCG
//
//  Created by apple on 12.04.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import "parser.h"

@implementation parser
+ (NSArray *)parseTxt {
  NSString *path =
      [[NSBundle mainBundle] pathForResource:@"test-data" ofType:@"txt"];
  NSError *error;
  NSString *stringFromFileAtPath =
      [[NSString alloc] initWithContentsOfFile:path
                                      encoding:NSUTF8StringEncoding
                                         error:&error];
  NSArray *nameMonth = [NSArray
      arrayWithObjects:@"2015", @"Январь", @"Февраль", @"Март",
                       @"Апрель", @"Май", @"Июнь", @"Июль",
                       @"Август", @"Сентябрь", @"Октябрь",
                       @"Ноябрь", @"Декабрь", nil];

  NSMutableArray *arrayMutMonth = [NSMutableArray array];

  NSArray *arrayMonth =
      [stringFromFileAtPath componentsSeparatedByString:@"\n\n\n"];
  for (int i = 0; i < arrayMonth.count; i++) {
    [arrayMutMonth
        addObject:[arrayMonth[i] stringByReplacingOccurrencesOfString:@"---"
                                                           withString:@"0.0"]];
  }
  NSMutableArray *monthArray = [NSMutableArray array];
  NSMutableArray *ar = [NSMutableArray array];
  NSMutableArray *ar1 = [NSMutableArray array];
  NSMutableArray *ar2 = [NSMutableArray array];
  NSMutableArray *firstValuesIndexArray = [NSMutableArray array];
  NSMutableArray *arrayDay = [NSMutableArray array];
  NSMutableArray *arrayValue = [NSMutableArray array];
  NSArray *arrayReturn = [NSArray array];

  for (int i = 0; i < arrayMutMonth.count; i++) {
    [ar addObject:[arrayMutMonth[i] componentsSeparatedByString:@"\n\n"]];
  }
  for (int i = 0; i < ar.count; i++) {
    for (int j = 0; j < nameMonth.count; j++) {
      if ([ar[i][0] isEqualToString:nameMonth[j]]) { //нашли месяц в массиве
          [monthArray addObject:nameMonth[j]];
         
        [ar1 addObject:[ar[i][1] componentsSeparatedByString:@"\n"]];

        for (int n = 0; n < [ar1[i] count]; n++) {
          [ar2 addObject:[ar1[i][n] componentsSeparatedByString:@" - "]];
        }
      }
    }
  }
  for (int k = 0; k < ar2.count; k++) {
    [arrayDay addObject:[ar2[k] firstObject]];
    [arrayValue addObject:[ar2[k] lastObject]];
  }
  for (int p = 0; p < [ar1 count]; p++) {
    [firstValuesIndexArray
        addObject:[NSNumber numberWithUnsignedInteger:[ar1[p] count]]];
  }
  arrayReturn = [NSArray
      arrayWithObjects:arrayDay, arrayValue, firstValuesIndexArray, monthArray, nil];
  return arrayReturn;
}

#pragma mark - DataToSevenDays

+ (NSArray *)extractDataToSevenDays:(NSArray *)dayArray andRateArray:rateArray {

  NSMutableArray *arraySevenDay = [NSMutableArray array];
  NSMutableArray *arraySevenRate = [NSMutableArray array];
  NSArray *returnArray = [NSArray array];
  NSInteger k = dayArray.count - 7;
  if (k < 0) {
    k = 0;
  }
  for (NSInteger i = k; i < dayArray.count; i++) {
    [arraySevenDay addObject:dayArray[i]];
    [arraySevenRate addObject:rateArray[i]];
  }
  returnArray = [NSArray arrayWithObjects:arraySevenDay, arraySevenRate, nil];
  return returnArray;
}
@end
