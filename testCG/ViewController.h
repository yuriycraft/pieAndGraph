//
//  ViewController.h
//  testCG
//
//  Created by apple on 16.03.15.
//  Copyright (c) 2015 YuriyCraft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class drawView;
@class drawArcsView;

@interface ViewController : UIViewController
@property(weak, nonatomic) IBOutlet drawView *drawingView;
@property(weak, nonatomic) IBOutlet drawArcsView *drawingArcsView;

@end
