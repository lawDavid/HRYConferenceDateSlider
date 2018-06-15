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
    }
    else if (pan.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateCancelled");
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else {
        CGPoint translation = [pan translationInView:self.superview];
        self.center = CGPointMake(_originLocation.x + translation.x, _originLocation.y);
    }
}

@end
