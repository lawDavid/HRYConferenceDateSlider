//
//  HRYConferenceDateSlider.h
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRYConferenceDrawView : UIView

@property (nonatomic, assign) UIEdgeInsets inset;

@property (nonatomic, assign) NSInteger totalCount;         //总共时间段 30min一段

@property (nonatomic, assign) CGFloat selectedBegin;        //位置百分比
@property (nonatomic, assign) CGFloat selectedEnd;          //位置百分比

@property (nonatomic, strong) NSArray *disableDurations;    //位置百分比

@end
