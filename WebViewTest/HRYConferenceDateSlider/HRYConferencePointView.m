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
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        if (_pointDidMoveBlock) {
            if (_pointDidMoveBlock(self.center.x)) {
                _lastLocataion = self.center;
            }
            else {
                _originLocation = _lastLocataion;
                self.center = _lastLocataion;
            }
        }
    }
    else {
        CGPoint translation = [pan translationInView:self.superview];
        if (_originLocation.x + translation.x > 0 && _originLocation.x + translation.x < self.superview.bounds.size.width) {
            self.center = CGPointMake(_originLocation.x + translation.x, _originLocation.y);
        }
    }
}

@end
