//
//  HRYConferenceDateSlider.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "HRYConferenceDateSlider.h"
#import "HRYConferencePointView.h"
#import "HRYConferenceDrawView.h"

@interface HRYConferenceDateSlider ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet HRYConferencePointView *startPoint;
@property (weak, nonatomic) IBOutlet HRYConferencePointView *endPoint;
@property (weak, nonatomic) IBOutlet HRYConferenceDrawView *drawView;

@end

@implementation HRYConferenceDateSlider : UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"HRYConferenceDateSlider" owner:self options:nil];
    [self addSubview:_contentView];
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _endTime = 18;
    _startTime = 8;
    CGFloat totalTime = _endTime - _startTime;
    CGFloat totalCount = totalTime * 2; //半小时一份
    
    
    _selectedBegin = 15;
    _selectedEnd = 17;
    CGFloat beginRatio = (_selectedBegin - _startTime) / totalTime;
    CGFloat endRatio = (_selectedEnd - _startTime) / totalTime;
    
    
    _disableDurations = @[@"9-10", @"11-12"];
    NSMutableArray *disableRadios = [[NSMutableArray alloc] init];
    for (NSString *str in _disableDurations) {
        NSArray *temp = [str componentsSeparatedByString:@"-"];
        NSInteger begin = [temp[0] integerValue];
        NSInteger end = [temp[1] integerValue];
        
        CGFloat beginRatio = (begin - _startTime) / totalTime;
        CGFloat endRatio = (end - _startTime) / totalTime;
        NSString *durationStr = [NSString stringWithFormat:@"%f-%f", beginRatio, endRatio];
        [disableRadios addObject:durationStr];
    }
    
    _drawView.totalCount = totalCount;
    _drawView.selectedBegin = beginRatio;
    _drawView.selectedEnd = endRatio;
    _drawView.disableDurations = disableRadios;
    
    _drawView.inset = UIEdgeInsetsMake(30, 1, 28, 1);
    
    _startPoint.pointDidMoveBlock = ^BOOL(CGFloat centerX) {
        return NO;
    };

}

@end
