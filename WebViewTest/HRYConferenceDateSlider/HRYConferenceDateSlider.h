//
//  HRYConferenceDateSlider.h
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRYConferenceDateSlider : UIView

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *selectedBegin;
@property (nonatomic, copy) NSString *selectedEnd;

@property (nonatomic, strong) NSArray *disableDurations;

@property (nonatomic, strong) NSArray<NSString*> *titles;

- (void)setView;

@end
