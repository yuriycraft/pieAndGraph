//
//  ViewController.m
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import "ViewController.h"
#import "drawView.h"
#import "drawArcsView.h"
#import "popoverView.h"
#import "parser.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize drawingView, drawingArcsView;
- (void)viewDidLoad {
  drawingView.backgroundColor = [UIColor colorWithRed:63.0f / 255.0f
                                                green:68.0f / 255.0f
                                                 blue:75.0f / 255.0f
                                                alpha:1.0f];
  drawingArcsView.backgroundColor = [UIColor colorWithRed:63.0f / 255.0f
                                                    green:68.0f / 255.0f
                                                     blue:75.0f / 255.0f
                                                    alpha:1.0f];
  drawingView.previousPinchScale = -1;
  [self initArray];
  [self initGestureRecognizers];
  drawingView.popupView = [[popoverView alloc] init];
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent
               animated:YES];
  [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {

  [drawingView setNeedsDisplay];
  [super viewDidLayoutSubviews];
}

- (void)initGestureRecognizers {

  UITapGestureRecognizer *handleTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:drawingView
                                              action:@selector(handleTap:)];
  [drawingView addGestureRecognizer:handleTapRecognizer];
  UIPinchGestureRecognizer *handlePinchRecognizer =
      [[UIPinchGestureRecognizer alloc] initWithTarget:drawingView
                                                action:@selector(handlePinch:)];

  [drawingView addGestureRecognizer:handlePinchRecognizer];

  UIPanGestureRecognizer *handlePanRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:drawingView
                                              action:@selector(handlePanMove:)];
  [handlePanRecognizer setMinimumNumberOfTouches:1];
  [handlePanRecognizer setMaximumNumberOfTouches:1];
  [drawingView addGestureRecognizer:handlePanRecognizer];
}

- (void)initArray {

  NSArray *arrayDay = [parser parseTxt][0];
  NSArray *arrayValue = [parser parseTxt][1];
  drawingView.firstValuesIndexArray = [parser parseTxt][2];
  drawingView.monthNameArray = [parser parseTxt][3];
  drawingView.dayData = arrayDay;
  drawingView.rateData = arrayValue;
  drawingView.sevenDayData =
      [parser extractDataToSevenDays:arrayDay andRateArray:arrayValue]
          .firstObject;
  drawingView.sevenRateData =
      [parser extractDataToSevenDays:arrayDay andRateArray:arrayValue]
          .lastObject;
  drawingArcsView.dayData = arrayDay;
  drawingArcsView.rateData = arrayValue;
}
@end
