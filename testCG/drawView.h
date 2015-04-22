//
//  drawView.h
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class popoverView;

@interface drawView : UIView
@property(strong, nonatomic) NSArray *dayData;
@property(strong, nonatomic) NSArray *rateData;
@property(strong, nonatomic) NSMutableArray *sevenDayData;
@property(strong, nonatomic) NSMutableArray *sevenRateData;
@property(strong, nonatomic) NSArray *firstValuesIndexArray;
@property(strong, nonatomic) NSArray *monthNameArray;
@property(strong, nonatomic) popoverView *popupView;
@property(assign, nonatomic) CGFloat beginScale;
@property(assign, nonatomic) CGFloat zoomScale;
@property(assign, nonatomic) CGFloat graphHeight;
@property(assign, nonatomic) CGFloat graphWidth;
@property(assign, nonatomic) CGFloat stepX;
@property(assign, nonatomic) CGFloat maxGraphHeight;
@property(assign, nonatomic) CGFloat previousPinchScale;
@property(assign, nonatomic) CGFloat startX;
@property(assign, nonatomic) CGFloat oldCentr;
@property(assign, nonatomic) CGFloat oldStartX;
@property(assign, nonatomic) CGFloat maximumCameraScale;
@property(assign, nonatomic) BOOL isTapped;
@property(assign, nonatomic) CGRect rectTapped;

- (void)handlePanMove:(UIPanGestureRecognizer *)panGesture;
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture;
- (void)handleTap:(UITapGestureRecognizer *)tapGesture;
@end
