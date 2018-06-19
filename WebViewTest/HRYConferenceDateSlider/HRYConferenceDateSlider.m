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

#import "Masonry.h"

@interface HRYConferenceDateSlider ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet HRYConferencePointView *startPoint;
@property (weak, nonatomic) IBOutlet HRYConferencePointView *endPoint;
@property (weak, nonatomic) IBOutlet HRYConferenceDrawView *drawView;

@property (weak, nonatomic) IBOutlet UIView *startPopView;
@property (weak, nonatomic) IBOutlet UILabel *startPopViewLabel;

@property (weak, nonatomic) IBOutlet UIView *endPopView;
@property (weak, nonatomic) IBOutlet UILabel *endPopViewLabel;

@property (nonatomic, assign) CGFloat startTimeFloat;
@property (nonatomic, assign) CGFloat endTimeFloat;
@property (nonatomic, assign) CGFloat totalTimeFloat;
@property (nonatomic, strong) NSArray *timeArray;

@property (nonatomic, assign) CGFloat selectedBeginFloat;
@property (nonatomic, assign) CGFloat selectedEndFloat;


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
}

- (void)setView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // start end
    _endTime = @"18:00";
    _startTime = @"8:00";
    _startTimeFloat = [self translateToTimeFloat:_startTime];
    _endTimeFloat = [self translateToTimeFloat:_endTime];
    _totalTimeFloat = _endTimeFloat - _startTimeFloat;
    CGFloat totalCount = _totalTimeFloat * 2; //半小时一份
    
    _timeArray = [self timeArrayWithStartTime:_startTimeFloat endTime:_endTimeFloat andInterval:0.5];

    // disable
    _disableDurations = @[@"9:00-10:00", @"11:00-12:00"];
    NSMutableArray *disableRadios = [[NSMutableArray alloc] init];
    for (NSString *str in _disableDurations) {
        NSArray *temp = [str componentsSeparatedByString:@"-"];
        CGFloat begin = [self translateToTimeFloat:temp[0]];
        CGFloat end = [self translateToTimeFloat:temp[1]];
        
        CGFloat beginRatio = (begin - _startTimeFloat) / _totalTimeFloat;
        CGFloat endRatio = (end - _startTimeFloat) / _totalTimeFloat;
        NSString *durationStr = [NSString stringWithFormat:@"%f-%f", beginRatio, endRatio];
        [disableRadios addObject:durationStr];
    }
    
    // drawView
    _drawView.scaleCount = totalCount / 4;  // 两小时一刻度
    _drawView.disableDurations = disableRadios;
    _drawView.inset = UIEdgeInsetsMake(0, 1, 30, 1);
    
    // selected point
    __weak typeof(self) weakSelf = self;
    _startPoint.pointDidMoveBlock = ^void(CGFloat ratio) {
        [self selectedPointDidMoveToRatio:ratio isStartPoint:YES];

    };
    _startPoint.pointDidEndMoveBlock = ^BOOL(CGFloat ratio) {
        weakSelf.drawView.selectedBegin = weakSelf.startPoint.ratio;
        CGFloat selected = [weakSelf ratioTranslateToTime:ratio];
        return [weakSelf handlePointMovement:selected];
    };
    
    _endPoint.pointDidMoveBlock = ^void(CGFloat ratio) {
        [self selectedPointDidMoveToRatio:ratio isStartPoint:NO];
    };
    _endPoint.pointDidEndMoveBlock = ^BOOL(CGFloat ratio) {
        weakSelf.drawView.selectedEnd = weakSelf.endPoint.ratio;
        CGFloat selected = [weakSelf ratioTranslateToTime:ratio];
        return [weakSelf handlePointMovement:selected];
    };
    
    //selectedTime
    _selectedBegin = @"15:00";
    _selectedEnd = @"17:00";
    _selectedBeginFloat = [self translateToTimeFloat:_selectedBegin];
    _selectedEndFloat = [self translateToTimeFloat:_selectedEnd];
    CGFloat beginRatio = [self timeTranslateToRatio:_selectedBeginFloat];
    CGFloat endRatio = [self timeTranslateToRatio:_selectedEndFloat];
    
    _startPoint.ratio = beginRatio;
    _endPoint.ratio = endRatio;
    [self selectedPointDidMoveToRatio:beginRatio isStartPoint:YES];
    [self selectedPointDidMoveToRatio:endRatio isStartPoint:NO];
    
    // x axle title
    _titles = @[@"8:00", @"10:00", @"12:00", @"14:00", @"16:00", @"18:00"];
    UIFont *font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    UIColor *titleColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
    CGSize size = CGSizeMake(38, 20);

    CGFloat unitWidth = _drawView.bounds.size.width / _drawView.scaleCount;
    [_titles enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = weakSelf.drawView.frame.origin.x + idx * unitWidth - size.width / 2;
        CGFloat y = weakSelf.frame.size.height - size.height;
        CGRect rect = CGRectMake(x, y, size.width, size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.font = font;
        label.textColor = titleColor;
        label.text = title;
        [self addSubview:label];
    }];
    
}

- (void)selectedPointDidMoveToRatio:(CGFloat)ratio isStartPoint:(BOOL)isStartPoint {
    if (isStartPoint) {
        _drawView.selectedBegin = ratio;
        // popView
        CGFloat x = ratio * _drawView.bounds.size.width + _drawView.frame.origin.x;
        _startPopView.center = CGPointMake(x, _startPopView.center.y);
        [_contentView bringSubviewToFront:_startPopView];
        // popLabel
        CGFloat selectedTime = _totalTimeFloat * ratio + _startTimeFloat;
        CGFloat regulateTime = [self regulateTimeFloat:selectedTime];
        _startPopViewLabel.text= [self translateToTimeStr:regulateTime];
    }
    else {
        _drawView.selectedEnd = ratio;
        // popView
        CGFloat x = ratio * _drawView.bounds.size.width + _drawView.frame.origin.x;
        _endPopView.center = CGPointMake(x, _startPopView.center.y);
        [_contentView bringSubviewToFront:_endPopView];
        // popLabel
        CGFloat selectedTime = _totalTimeFloat * ratio + _startTimeFloat;
        CGFloat regulateTime = [self regulateTimeFloat:selectedTime];
        _endPopViewLabel.text= [self translateToTimeStr:regulateTime];
    }
}

- (BOOL)handlePointMovement:(CGFloat)selectedTime {
    if (_startPoint.ratio > _endPoint.ratio) {
        return NO;
    }
    for (NSString *str in _disableDurations) {
        NSArray *temp = [str componentsSeparatedByString:@"-"];
        CGFloat begin = [self translateToTimeFloat:temp[0]];
        CGFloat end = [self translateToTimeFloat:temp[1]];
        if (selectedTime > begin && selectedTime < end) {
            return NO;
        }
    }
    return YES;
}

// 规则化TimeFloat 只显示整数点 或 x.5
- (CGFloat)regulateTimeFloat:(CGFloat)timeFloat {
    CGFloat regulateTime;
    NSInteger i = (NSInteger)timeFloat;
    CGFloat remain = timeFloat - i;
    if (remain < 0.25) {
        regulateTime = i;
    }
    else if (remain >= 0.25 && remain < 0.75) {
        regulateTime = i + 0.5;
    }
    else {
        regulateTime = i + 1;
    }
    return regulateTime;
}

// 根据起始pointView 的time 返回对应的ratio
- (CGFloat)timeTranslateToRatio:(CGFloat)timeFloat {
    return (timeFloat - _startTimeFloat) / _totalTimeFloat;
}

// 根据起始pointView 的ratio 返回对应的时间
- (CGFloat)ratioTranslateToTime:(CGFloat)ratio {
    return  ratio * (_endTimeFloat - _startTimeFloat) + _startTimeFloat;
}

// 将HH:mm的时间格式 转化为 小数
- (CGFloat)translateToTimeFloat:(NSString *)timeStr {
    NSArray *temp = [timeStr componentsSeparatedByString:@":"];
    CGFloat hours = [temp[0] floatValue];
    CGFloat minute = [temp[1] floatValue] / 60.0;
    return hours + minute;
}

// 将小数时间转为HH:mm的形式（只支持0.5转30）
- (NSString *)translateToTimeStr:(CGFloat)timeFloat {
    NSInteger i = (NSInteger)timeFloat;
    if (timeFloat - i > 0) {
        return [NSString stringWithFormat:@"%ld:30", (long)i];
    }
    else {
        return [NSString stringWithFormat:@"%ld:00", (long)i];
    }
}

- (NSArray *)timeArrayWithStartTime:(CGFloat)startTimeFloat endTime:(CGFloat)endTimeFloat andInterval:(CGFloat)intervalFloat{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGFloat totalDuration = endTimeFloat - startTimeFloat;
    NSInteger count = totalDuration / intervalFloat;
    for (int i = 0; i <= count; i++) {
        [array addObject:[NSNumber numberWithFloat:startTimeFloat + i * intervalFloat]];
    }
    return array;
}

@end
