//
//  HRYConferenceDateSlider.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "HRYConferenceDrawView.h"

@interface HRYConferenceDrawView ()

@end

@implementation HRYConferenceDrawView : UIView

- (void)drawRect:(CGRect)rect {
    
    CGFloat lineWidth = 2;
    UIColor *lineColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    CGFloat availableWidth = self.bounds.size.width - _inset.right - _inset.left;
    
    // x axle
    UIBezierPath *linePatch = [[UIBezierPath alloc] init];
    CGFloat startPointX = _inset.left;
    CGFloat endPointX = self.bounds.size.width - _inset.right;
    CGFloat lineY = self.bounds.size.height - _inset.bottom;
    [linePatch moveToPoint:CGPointMake(startPointX, lineY)];
    [linePatch addLineToPoint:CGPointMake(endPointX, lineY)];
    [linePatch setLineWidth:lineWidth];
    [lineColor setStroke];
    [linePatch stroke];
    
    CGFloat unitWidth = availableWidth / _scaleCount;     //一段的长度

    // x axle scale & x axle title
    UIBezierPath *scalePath = [[UIBezierPath alloc] init];
    for (NSInteger idx = 0; idx <= _scaleCount; idx ++) {
        CGPoint startPoint = CGPointMake(startPointX + idx * unitWidth, lineY);
        CGPoint endPoint = CGPointMake(startPointX + idx * unitWidth, lineY - 8);
        [scalePath moveToPoint:startPoint];
        [scalePath addLineToPoint:endPoint];
    }
    [scalePath setLineWidth:lineWidth];
    [lineColor setStroke];
    [scalePath stroke];

    // selected line
    UIBezierPath *selectedPatch = [[UIBezierPath alloc] init];
    CGFloat selectedStartPointX = startPointX + availableWidth * _selectedBegin;
    CGFloat selectedEndPointX = startPointX + availableWidth * _selectedEnd;
    [selectedPatch moveToPoint:CGPointMake(selectedStartPointX, lineY)];
    [selectedPatch addLineToPoint:CGPointMake(selectedEndPointX, lineY)];
    [selectedPatch setLineWidth:4];
    UIColor *selectedColor = [UIColor colorWithRed:244/255.0 green:102/255.0 blue:92/255.0 alpha:1];
    [selectedColor setStroke];
    [selectedPatch stroke];
    
    // disable line
    UIBezierPath *disablePatch = [[UIBezierPath alloc] init];
    for (NSString *str in _disableDurations) {
        NSArray *temp = [str componentsSeparatedByString:@"-"];
        CGFloat beginRatio = [temp[0] floatValue];
        CGFloat endRatio = [temp[1] floatValue];
        
        CGFloat disableStartPointX = startPointX + availableWidth * beginRatio;
        CGFloat disableEndPointX = startPointX + availableWidth * endRatio;
        [disablePatch moveToPoint:CGPointMake(disableStartPointX, lineY - 4)];
        [disablePatch addLineToPoint:CGPointMake(disableEndPointX, lineY - 4)];
    }
    [disablePatch setLineWidth:8];
    UIColor *disableColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [disableColor setStroke];
    [disablePatch stroke];
}

- (void)setSelectedBegin:(CGFloat)selectedBegin {
    _selectedBegin = selectedBegin;
    [self setNeedsDisplay];
}

- (void)setSelectedEnd:(CGFloat)selectedEnd {
    _selectedEnd = selectedEnd;
    [self setNeedsDisplay];
}

@end
