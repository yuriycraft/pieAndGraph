//
//  popoverView.m
//  testCG
//
//  Created by apple on 30.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//
#define kArrowHeight 4

#import "popoverView.h"

@implementation popoverView
@synthesize label;

- (instancetype)init {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor clearColor];

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    label.font = [UIFont boldSystemFontOfSize:15.0f];

    label.textColor = [UIColor colorWithRed:63.0f / 255.0f
                                      green:68.0f / 255.0f
                                       blue:75.0f / 255.0f
                                      alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;

    [self addSubview:label];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();

  UIBezierPath *fillPath = [UIBezierPath bezierPath];

  [[UIColor whiteColor] set];

  CGRect rectAnnotation = CGRectMake(0, 0, self.bounds.size.width,
                                     self.bounds.size.height - kArrowHeight);
  UIBezierPath *pathAnnotation =
      [UIBezierPath bezierPathWithRoundedRect:rectAnnotation cornerRadius:5.0f];

  [fillPath moveToPoint:CGPointMake(self.bounds.size.width / 2 -
                                        (kArrowHeight + 2 / 2),
                                    self.bounds.size.height - kArrowHeight)];
  [fillPath addLineToPoint:CGPointMake(self.bounds.size.width / 2,
                                       self.bounds.size.height)];
  [fillPath addLineToPoint:CGPointMake(self.bounds.size.width / 2 +
                                           (kArrowHeight + 2 / 2),
                                       self.bounds.size.height - kArrowHeight)];
  CGContextAddPath(context, fillPath.CGPath);
  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  [pathAnnotation fill];
  CGContextFillPath(context);
}

@end
