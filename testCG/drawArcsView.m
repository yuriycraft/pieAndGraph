//
//  drawArcsView.m
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//
#define kOffset 2.25f
#define kStartAngle 3 * M_PI_2
#define kAngle M_PI

#import "drawArcsView.h"
#import "drawView.h"

@implementation drawArcsView

@synthesize pieRadius, centr, percentArray, rateData, dayData;

- (void)drawRect:(CGRect)rect {

  percentArray = [self percentFromRateArray];
  centr =
      CGPointMake(self.frame.size.width / 2, self.frame.size.height / 1.85f);
  pieRadius = self.frame.size.width / kOffset;

  if ([UIApplication sharedApplication].statusBarOrientation ==
          UIDeviceOrientationPortrait ||
      [UIApplication sharedApplication].statusBarOrientation ==
          UIDeviceOrientationPortraitUpsideDown) {

    double high = [percentArray[0] floatValue];
    double mid = [percentArray[1] floatValue];

    // red
    [self drawPiePartWithCenter:centr
                         radius:pieRadius
                     startAngle:kStartAngle
                       endAngle:kStartAngle +
                                [self radiansFromDegrees:(high * 360) / 100.f]
                          color:[UIColor colorWithRed:255.0f / 255.0f
                                                green:109.0f / 255.0f
                                                 blue:109.0f / 255.0f
                                                alpha:1.0f]];
    // blue
    [self drawPiePartWithCenter:centr
                         radius:pieRadius
                     startAngle:kStartAngle +
                                [self radiansFromDegrees:(high * 360) / 100.f]
                       endAngle:kStartAngle +
                                [self radiansFromDegrees:(high * 360) / 100.f] +
                                [self radiansFromDegrees:(mid * 360) / 100.f]
                          color:[UIColor colorWithRed:39.0f / 255.0f
                                                green:213.0f / 255.0f
                                                 blue:252.0f / 255.0f
                                                alpha:1.0f]];
    // green
    [self drawPiePartWithCenter:centr
                         radius:pieRadius
                     startAngle:kStartAngle +
                                [self radiansFromDegrees:(high * 360) / 100.f] +
                                [self radiansFromDegrees:(mid * 360) / 100.f]
                       endAngle:kStartAngle
                          color:[UIColor colorWithRed:168.0f / 255.0f
                                                green:255.0f / 255.0f
                                                 blue:139.0f / 255.0f
                                                alpha:1.0f]];

    [self drawPiePartWithCenter:centr
                         radius:pieRadius / 1.14
                     startAngle:M_PI
                       endAngle:360
                          color:[UIColor colorWithRed:63.0f / 255.0f
                                                green:68.0f / 255.0f
                                                 blue:75.0f / 255.0f
                                                alpha:1.0f]];

    [self
        drawThreeRectsWithHigh:
            [NSString stringWithFormat:@"%.1f%%", [percentArray[0] floatValue]]
                           mid:[NSString
                                   stringWithFormat:
                                       @"%.1f%%", [percentArray[1] floatValue]]
                           low:[NSString
                                   stringWithFormat:
                                       @"%.1f%%", [percentArray[2] floatValue]]
                        center:centr
                        radius:pieRadius];

    centr.x += pieRadius * 2.0;
  }

  else
    [self isHidden];
}

#pragma mark - draw

- (void)drawThreeRectsWithHigh:(NSString *)high
                           mid:(NSString *)mid
                           low:(NSString *)low
                        center:(CGPoint)center
                        radius:(CGFloat)radius {

  UIFont *font = [UIFont systemFontOfSize:26.0f];
  NSDictionary *attributes = [NSDictionary
      dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                   [UIColor whiteColor],
                                   NSForegroundColorAttributeName, nil];

  UIFont *fontHighMidLow = [UIFont boldSystemFontOfSize:14.0f];
  UIColor *colorHighMidLow =
      [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.46];
  NSDictionary *attributesHighMidLow = [NSDictionary
      dictionaryWithObjectsAndKeys:fontHighMidLow, NSFontAttributeName,
                                   colorHighMidLow,
                                   NSForegroundColorAttributeName, nil];
  NSString *text = @"50.0%";
  CGSize textSize = [text sizeWithAttributes:attributes];
  CGFloat rectYstep = (radius * 2) / 6 + textSize.height / 2;

  [[UIColor colorWithRed:255.0f / 255.0f
                   green:109.0f / 255.0f
                    blue:109.0f / 255.0f
                   alpha:0.34] set];
  CGRect rectHigh = CGRectMake(center.x - (textSize.width + 7.1) / 2,
                               center.y - radius + rectYstep,
                               textSize.width + 7.1, textSize.height);
  UIBezierPath *pathHigh =
      [UIBezierPath bezierPathWithRoundedRect:rectHigh cornerRadius:5.0f];
  [pathHigh fill];
  [high drawAtPoint:CGPointMake(CGRectGetMidX(rectHigh) - textSize.width / 2,
                                CGRectGetMidY(rectHigh) - textSize.height / 2)
      withAttributes:attributes];
  CGSize highSize = [@"HIGH" sizeWithAttributes:attributesHighMidLow];
  [@"HIGH" drawAtPoint:CGPointMake(CGRectGetMidX(rectHigh) - highSize.width / 2,
                                   CGRectGetMidY(rectHigh) -
                                       highSize.height * 2.2)
        withAttributes:attributesHighMidLow];
  [[UIColor colorWithRed:39.0f / 255.0f
                   green:213.0f / 255.0f
                    blue:252.0f / 255.0f
                   alpha:0.34f] set];
  CGRect rectMid = CGRectMake(center.x - (textSize.width + 7.1f) / 2,
                              center.y - radius + rectYstep * 2,
                              textSize.width + 7.1f, textSize.height);
  UIBezierPath *pathMid =
      [UIBezierPath bezierPathWithRoundedRect:rectMid cornerRadius:5.0f];
  [pathMid fill];
  [mid drawAtPoint:CGPointMake(CGRectGetMidX(rectMid) - textSize.width / 2,
                               CGRectGetMidY(rectMid) - textSize.height / 2)
      withAttributes:attributes];
  CGSize midSize = [@"MID" sizeWithAttributes:attributesHighMidLow];
  [@"MID"
         drawAtPoint:CGPointMake(CGRectGetMidX(rectMid) - midSize.width / 2,
                                 CGRectGetMidY(rectMid) - midSize.height * 2.2f)
      withAttributes:attributesHighMidLow];

  [[UIColor colorWithRed:168.0f / 255.0f
                   green:255.0f / 255.0f
                    blue:139.0f / 255.0f
                   alpha:0.34f] set];
  CGRect rectLow = CGRectMake(center.x - (textSize.width + 7.1f) / 2,
                              center.y - radius + rectYstep * 3,
                              textSize.width + 7.1f, textSize.height);
  UIBezierPath *pathLow =
      [UIBezierPath bezierPathWithRoundedRect:rectLow cornerRadius:5.0f];
  [pathLow fill];
  [low drawAtPoint:CGPointMake(CGRectGetMidX(rectLow) - textSize.width / 2,
                               CGRectGetMidY(rectLow) - textSize.height / 2)
      withAttributes:attributes];

  CGSize lowSize = [@"LOW" sizeWithAttributes:attributesHighMidLow];
  [@"LOW"
         drawAtPoint:CGPointMake(CGRectGetMidX(rectLow) - lowSize.width / 2,
                                 CGRectGetMidY(rectLow) - lowSize.height * 2.2f)
      withAttributes:attributesHighMidLow];
}

- (void)drawPiePartWithCenter:(CGPoint)center
                       radius:(CGFloat)radius
                   startAngle:(CGFloat)startAngle
                     endAngle:(CGFloat)endAngle
                        color:(UIColor *)color {

  CGContextRef context = UIGraphicsGetCurrentContext();

  [color set];
  CGContextMoveToPoint(context, center.x, center.y);
  CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
  CGContextAddLineToPoint(context, center.x, center.y);
  CGContextFillPath(context);
}

#pragma mark - helpers

- (NSMutableArray *)percentFromRateArray {

  CGFloat max = [[rateData valueForKeyPath:@"@max.floatValue"] floatValue];
  CGFloat min = [[rateData valueForKeyPath:@"@min.floatValue"] floatValue];
  CGFloat mid = [[rateData valueForKeyPath:@"@avg.floatValue"] floatValue];
  CGFloat high = (max - min) / 3 * 2;
  CGFloat low = (max - min) / 3;
  CGFloat sum = high + mid + low;
  NSMutableArray *resultArray = [NSMutableArray array];
  [resultArray addObject:[NSNumber numberWithFloat:(high * 100 / sum)]];
  [resultArray addObject:[NSNumber numberWithFloat:(mid * 100 / sum)]];
  [resultArray addObject:[NSNumber numberWithFloat:(low * 100 / sum)]];
  return resultArray;
}

- (CGFloat)radiansFromDegrees:(double)degrees {
  double angle = (M_PI / 180.0) * degrees;
  return angle;
}
@end
