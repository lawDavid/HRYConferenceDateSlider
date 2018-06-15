//
//  HRYConferenceDateSlider.h
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRYConferenceDateSlider : UIView

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) NSInteger selectedBegin;
@property (nonatomic, assign) NSInteger selectedEnd;

@property (nonatomic, strong) NSArray *disableDurations;

@end
