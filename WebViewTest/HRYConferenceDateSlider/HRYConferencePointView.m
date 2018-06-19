//
//  HRYConferencePointView.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "HRYConferencePointView.h"

@interface HRYConferencePointView ()

@property (nonatomic, assign) CGPoint originLocation;
@property (nonatomic, assign) CGPoint lastLocataion;

@end

@implementation HRYConferencePointView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {    
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        _originLocation = self.center;
        _lastLocataion = self.center;
    }
    else if (pan.state == UIGestureRecognizerStateCancelled) {
        _originLocation = _lastLocataion;
        self.center = _lastLocataion;
        // moving block
        !_pointDidMoveBlock ? : _pointDidMoveBlock(self.ratio);
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        // end block
        if (_pointDidEndMoveBlock) {
            if (_pointDidEndMoveBlock(self.ratio)) {
                _lastLocataion = self.center;
                // moving block
                !_pointDidMoveBlock ? : _pointDidMoveBlock(self.ratio);
            }
            else {
                _originLocation = _lastLocataion;
                self.center = _lastLocataion;
                // moving block
                !_pointDidMoveBlock ? : _pointDidMoveBlock(self.ratio);
            }
        }
    }
    else {
        CGPoint translation = [pan translationInView:self.superview];
        if (_originLocation.x + translation.x > 0 && _originLocation.x + translation.x < self.superview.bounds.size.width) {
            self.center = CGPointMake(_originLocation.x + translation.x, _originLocation.y);
            // moving block
            !_pointDidMoveBlock ? : _pointDidMoveBlock(self.ratio);
        }
    }
}

- (void)setRatio:(CGFloat)ratio {
    CGFloat centerX = ratio * self.superview.bounds.size.width;
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)ratio {
    CGFloat ratio = self.center.x / self.superview.bounds.size.width;
    return ratio;
}

@end
