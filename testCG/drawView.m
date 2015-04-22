//
//  drawView.m
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//
#define kCircleRadius 5
#define kOffset 50
#define kOffsetY 20
#define kGraphTop 30
#define kArrowHeight 50
#define kMinimumCameraScale 1.0

#import "drawView.h"
#import "popoverView.h"

@implementation drawView

@synthesize dayData, rateData, sevenDayData, sevenRateData, popupView,
    graphHeight, graphWidth, stepX, maxGraphHeight, beginScale, zoomScale,
    previousPinchScale, startX, isTapped, rectTapped, oldCentr, oldStartX,
    firstValuesIndexArray, maximumCameraScale, monthNameArray;

- (void)drawRect:(CGRect)rect {
  if (zoomScale < kMinimumCameraScale) {
    zoomScale = kMinimumCameraScale;
  }
  graphHeight = self.bounds.size.height;
  graphWidth = self.bounds.size.width;
  maxGraphHeight = graphHeight - kOffsetY;
  oldStartX =
      ((dayData.count / (graphWidth / stepX)) * graphWidth) - graphWidth;
  if ([UIApplication sharedApplication].statusBarOrientation ==
          UIDeviceOrientationPortrait ||
      [UIApplication sharedApplication].statusBarOrientation ==
          UIDeviceOrientationPortraitUpsideDown) {
    [self drawSevenVerticalLineWithArray:sevenDayData];
    [self drawPortrietGraphWithArray:sevenRateData
                            andColor:[UIColor whiteColor]
                        andLineWidth:4.0f];

    for (UIView *subview in [self subviews]) {
      if ([subview isKindOfClass:[popupView class]]) {
        isTapped = false;
        [self setNeedsDisplay];
        [subview removeFromSuperview];
      }
    }
  } else {
    if (zoomScale > kMinimumCameraScale) {
      [self drawZoomingGraphWithArray:rateData
                             andColor:[UIColor whiteColor]
                         andLineWidth:2.0f
                       andStartPointX:startX
                             andZoomX:zoomScale];

      [self drawVerticalLineWithArrayDay:dayData
                            andArrayRate:rateData
                                andZoomX:zoomScale
                          andStartPointX:startX];
      [self drawVerticalLineWithFirstValuesIndexArray:firstValuesIndexArray
                                             andArray:rateData
                                                zoomX:zoomScale
                                          startPointX:startX
                                       monthNameArray:monthNameArray];
      if (isTapped) {
        [self drawCirclesTappedFillWithRect:rectTapped];
      }
    } else {

      [self drawPortrietGraphWithArray:rateData
                              andColor:[UIColor whiteColor]
                          andLineWidth:2.0f];
      [self drawVerticalLineWithFirstValuesIndexArray:firstValuesIndexArray
                                             andArray:rateData
                                                zoomX:zoomScale
                                          startPointX:startX
                                       monthNameArray:monthNameArray];
    }
  }
}

#pragma mark - Gestures

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

  if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
    beginScale = zoomScale;
    return YES;
  }
  return YES;
}

- (void)handlePanMove:(UIPanGestureRecognizer *)panGesture {

  for (UIView *subview in [self subviews]) {
    if ([subview isKindOfClass:[popupView class]]) {
      isTapped = false;
      [self setNeedsDisplay];
      [subview removeFromSuperview];
    }
  }
  CGPoint translation = [panGesture translationInView:self];
  oldCentr = oldCentr + translation.x / 3;
  startX = oldCentr;
  if (oldCentr > 0.0) {
    oldCentr = 0.0f;
    ;
    startX = oldCentr;
  }
  if (oldCentr < (oldStartX * (-1))) {
    oldCentr = (oldStartX * (-1));
    startX = oldCentr;
  }
  [self setNeedsDisplay];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture {

  for (UIView *subview in [self subviews]) {
    if ([subview isKindOfClass:[popupView class]]) {
      isTapped = false;
      [self setNeedsDisplay];
      [subview removeFromSuperview];
    }
  }

  if (fabs(previousPinchScale - pinchGesture.scale) > 0.01) {
    previousPinchScale = pinchGesture.scale;
    zoomScale = beginScale * pinchGesture.scale;
    maximumCameraScale = 1.5 * firstValuesIndexArray.count;
    if (zoomScale < kMinimumCameraScale)
      zoomScale = kMinimumCameraScale;
    if (zoomScale > maximumCameraScale)
      zoomScale = maximumCameraScale;
  }
  if (startX < (oldStartX * (-1))) {
    if ((zoomScale < maximumCameraScale && zoomScale > 1.0)) {
      startX = oldStartX * (-1);
    }
  }
  [self setNeedsDisplay];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {

  for (UIView *subview in [self subviews]) {
    if ([subview isKindOfClass:[popupView class]]) {
      isTapped = false;
      [self setNeedsDisplay];
      [subview removeFromSuperview];
    }
  }

  CGPoint point = [tapGesture locationInView:self];

  [self tappedCircleWithGesturePoint:point
                            andArray:rateData
                      andStartPointX:startX
                            andZoomX:zoomScale];
}

#pragma mark - Draw Popup

- (void)tappedCircleWithGesturePoint:(CGPoint)point
                            andArray:(NSArray *)array
                      andStartPointX:(CGFloat)startPointX
                            andZoomX:(CGFloat)zoomX {

  if (zoomX == maximumCameraScale) {

    double kStepxRate = zoomX * (graphWidth / rateData.count);
    for (int i = 0; i < array.count; i++) {

      CGFloat x = i * kStepxRate + 20.0f + startPointX;

      CGFloat y = graphHeight - kOffsetY -
                  maxGraphHeight * [rateData[i] doubleValue] / 1200;
      CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius,
                               2 * kCircleRadius, 2 * kCircleRadius);
      if (CGRectContainsPoint(rect, point)) {
        isTapped = true;
        rectTapped = rect;
        [self setNeedsDisplay];
        NSLog(@"Tapped a circle with index %d, value %@", i, rateData[i]);
        popupView.frame = CGRectMake(rect.origin.x - kGraphTop,
                                     rect.origin.y - kGraphTop, 70, 25);
        popupView.label.text =
            [NSString stringWithFormat:@"%@ ₽", rateData[i]];
        [self addSubview:popupView];

        break;
      }
    }
  }
}

#pragma mark - Draw graph

- (void)drawZoomingGraphWithArray:(NSArray *)array
                         andColor:(UIColor *)color
                     andLineWidth:(CGFloat)lineWidth
                   andStartPointX:(CGFloat)startPointX
                         andZoomX:(CGFloat)zoomX {

  stepX = zoomX * (graphWidth / array.count);

  UIBezierPath *bezierPath = [UIBezierPath bezierPath];
  [bezierPath moveToPoint:CGPointMake(startPointX - 5.0, graphHeight)];
  CGPoint p1 =
      CGPointMake(startPointX - 5.0,
                  graphHeight - maxGraphHeight * [array[0] doubleValue] / 1200);
  [bezierPath addLineToPoint:p1];
  bezierPath.lineWidth = lineWidth;
  [color setStroke];
  for (int i = 0; i < array.count; i++) {
    CGFloat x = kOffset - 30 + i * stepX + startPointX;
    CGFloat y =
        graphHeight - kOffsetY - maxGraphHeight * [array[i] doubleValue] / 1200;
    CGPoint p2 = CGPointMake(x, y);
    CGPoint midPoint = midPointForPoints(p1, p2);
    [bezierPath addQuadCurveToPoint:midPoint
                       controlPoint:controlPointForPoints(midPoint, p1)];
    [bezierPath addQuadCurveToPoint:p2
                       controlPoint:controlPointForPoints(midPoint, p2)];

    p1 = p2;
  }
  CGPoint midEndPoint =
      midPointForPoints(p1, CGPointMake(graphWidth, graphHeight - kOffsetY));
  [bezierPath addQuadCurveToPoint:midEndPoint
                     controlPoint:controlPointForPoints(midEndPoint, p1)];
  [bezierPath addQuadCurveToPoint:CGPointMake(graphWidth + 5.0, graphHeight)
                     controlPoint:controlPointForPoints(
                                      midEndPoint, CGPointMake(graphWidth + 5.0,
                                                               graphHeight))];

  [bezierPath stroke];
  [[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2f] setFill];
  [bezierPath fill];
}

- (void)drawSevenVerticalLineWithArray:(NSArray *)arrayDays {

  stepX = graphWidth / arrayDays.count;
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
  NSDictionary *atrributes = [NSDictionary
      dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                   [UIColor whiteColor],
                                   NSForegroundColorAttributeName, nil];
  CGContextSetLineWidth(context, 0.05f);
  CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
  //линии и дни
  for (int i = 0; i < arrayDays.count; i++) {

    NSString *theText = [NSString stringWithFormat:@"%@", arrayDays[i]];
    CGFloat x = i * stepX + 20.0f;
    CGContextMoveToPoint(context, x, kGraphTop - 3);
    CGContextAddLineToPoint(context, x, graphHeight);
    [theText drawAtPoint:CGPointMake(x - 2.5f, kGraphTop - 20)
          withAttributes:atrributes];
  }
  CGContextStrokePath(context);
}

- (void)drawVerticalLineWithArrayDay:(NSArray *)arrayDay
                        andArrayRate:(NSArray *)arrayRate
                            andZoomX:(CGFloat)zoomX
                      andStartPointX:(CGFloat)startPointX {

  if (zoomX >= 1.5) {
    double kStepxRate = zoomX * (graphWidth / arrayDay.count);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRef circlesContext = UIGraphicsGetCurrentContext();
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    NSDictionary *atrributes = [NSDictionary
        dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                     [UIColor whiteColor],
                                     NSForegroundColorAttributeName, nil];

    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    //линии и дни
    for (int i = 0; i < arrayDay.count; i++) {
      CGContextSetLineWidth(context, 0.05f);
      NSString *theText = [NSString stringWithFormat:@"%@", arrayDay[i]];
      CGFloat x = i * kStepxRate + 20.0f + startPointX;
      CGFloat y = graphHeight - kOffsetY -
                  maxGraphHeight * [arrayRate[i] doubleValue] / 1200;
      CGContextMoveToPoint(context, x, graphHeight);
      CGContextAddLineToPoint(context, x, y);
      [theText drawAtPoint:CGPointMake(x + 5.5f, graphHeight - 17.5f)
            withAttributes:atrributes];
      CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius,
                               2 * kCircleRadius, 2 * kCircleRadius);
      CGContextSetLineWidth(context, 0.08f);
      CGContextStrokePath(context);
      if (zoomX == maximumCameraScale) {
        [self circlesWithContext:circlesContext andRect:rect];
      }
    }
  }
}

- (void)circlesWithContext:(CGContextRef)context andRect:(CGRect)rect {

  CGContextSetLineWidth(context, 3.0f);
  CGContextAddEllipseInRect(context, rect);

  CGContextStrokePath(context);
  [self drawCirclesFillWithContext:context andRect:rect];
}
//заливка кружка
- (void)drawCirclesFillWithContext:(CGContextRef)context andRect:(CGRect)rect {

  CGRect rectFill =
      CGRectMake(rect.origin.x + 0.5f, rect.origin.y + 0.5f,
                 2 * kCircleRadius - 1.0f, 2 * kCircleRadius - 1.0f);
  //  CGContextSetLineWidth(context, 1.0f);
  CGContextAddEllipseInRect(context, rectFill);
  CGContextSetFillColorWithColor(context,
                                 [[UIColor colorWithRed:63.0f / 255.0f
                                                  green:68.0f / 255.0f
                                                   blue:75.0f / 255.0f
                                                  alpha:1.0f] CGColor]);
  CGContextFillPath(context);
}

//заливка кружка если tapped

- (void)drawCirclesTappedFillWithRect:(CGRect)rect {

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGRect rectFill = CGRectMake(rect.origin.x, rect.origin.y, 2 * kCircleRadius,
                               2 * kCircleRadius);
  CGContextAddEllipseInRect(context, rectFill);
  CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
  if (isTapped) {
    CGContextFillPath(context);
  } else {
    CGContextRetain(context);
  }
}

- (void)drawPortrietGraphWithArray:(NSArray *)array
                          andColor:(UIColor *)color
                      andLineWidth:(CGFloat)lineWidth {

  stepX = graphWidth / array.count;
  UIBezierPath *bezierPath = [UIBezierPath bezierPath];

  [bezierPath moveToPoint:CGPointMake(-5.0f, graphHeight)];
  CGPoint p1 = CGPointMake(
      -5.0f, graphHeight - maxGraphHeight * [array[0] doubleValue] / 1200);

  [bezierPath addLineToPoint:p1];
  bezierPath.lineWidth = lineWidth;
  [color setStroke];
  for (int i = 0; i < array.count; i++) {
    CGFloat x = kOffset - 30 + i * stepX;
    CGFloat y =
        graphHeight - kOffsetY - maxGraphHeight * [array[i] doubleValue] / 1200;

    CGPoint p2 = CGPointMake(x, y);
    CGPoint midPoint = midPointForPoints(p1, p2);
    [bezierPath addQuadCurveToPoint:midPoint
                       controlPoint:controlPointForPoints(midPoint, p1)];
    [bezierPath addQuadCurveToPoint:p2
                       controlPoint:controlPointForPoints(midPoint, p2)];
    p1 = p2;
  }
  CGPoint midEndPoint =
      midPointForPoints(p1, CGPointMake(graphWidth, graphHeight - kOffsetY));
  [bezierPath addQuadCurveToPoint:midEndPoint
                     controlPoint:controlPointForPoints(midEndPoint, p1)];
  [bezierPath addQuadCurveToPoint:CGPointMake(graphWidth + 5.0, graphHeight)
                     controlPoint:controlPointForPoints(
                                      midEndPoint, CGPointMake(graphWidth + 5.0,
                                                               graphHeight))];
  [bezierPath stroke];
  [[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2f] setFill];
  [bezierPath fill];
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {

  return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {

  CGPoint controlPoint = midPointForPoints(p1, p2);
  CGFloat diffY = fabs(p2.y - controlPoint.y);

  if (p1.y < p2.y)
    controlPoint.y += diffY;
  else if (p1.y > p2.y)
    controlPoint.y -= diffY;

  return controlPoint;
}

- (void)drawVerticalLineWithFirstValuesIndexArray:(NSArray *)firstArray
                                         andArray:(NSArray *)arrayValue
                                            zoomX:(CGFloat)zoomX
                                      startPointX:(CGFloat)startPointX
                                   monthNameArray:(NSArray *)monthArray

{

  double kStepxRate = zoomX * (graphWidth / arrayValue.count);
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
  NSDictionary *atrributes = [NSDictionary
      dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                   [UIColor whiteColor],
                                   NSForegroundColorAttributeName, nil];
  CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
  //линии и дни
  NSInteger k = arrayValue.count;
  for (NSInteger j = firstArray.count - 1; j >= 0; j--) {
    int m = [NSString stringWithFormat:@"%@", firstArray[j]].intValue;
    k = (m - k) * (-1);
    CGContextSetLineWidth(context, 0.05f);
    NSString *theText = [NSString stringWithFormat:@"%@", monthArray[j]];
    CGFloat x = k * kStepxRate + 20.0f + startPointX;
    CGFloat y = graphHeight - kOffsetY -
                maxGraphHeight * [arrayValue[k] doubleValue] / 1200;
    CGContextMoveToPoint(context, x, graphHeight);
    CGContextAddLineToPoint(context, x, y);
    [theText drawAtPoint:CGPointMake(x + 5.5f, graphHeight - 30.0f)
          withAttributes:atrributes];
    CGContextSetLineWidth(context, 0.08f);
    CGContextStrokePath(context);
  }
}
@end
