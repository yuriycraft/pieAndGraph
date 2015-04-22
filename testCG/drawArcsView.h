//
//  drawArcsView.h
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawArcsView : UIView
@property(assign, nonatomic) CGFloat pieRadius;
@property(assign, nonatomic) CGPoint centr;
@property(strong, nonatomic) NSArray *percentArray;
@property(strong, nonatomic) NSArray *dayData;
@property(strong, nonatomic) NSArray *rateData;
@end
