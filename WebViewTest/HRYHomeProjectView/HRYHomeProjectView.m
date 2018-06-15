//
//  HRYHomeProjectView.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "HRYHomeProjectView.h"
#import "Masonry.h"

@interface HRYHomeProjectView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *behindImageView;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) NSInteger frontImageIndex;
@property (nonatomic, assign) NSInteger behindImageIndex;

@end

@implementation HRYHomeProjectView : UIView

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
    self.clipsToBounds = YES;
    
    [[NSBundle mainBundle] loadNibNamed:@"HRYHomeProjectView" owner:self options:nil];
    [self addSubview:_contentView];
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // imageView cornerRadius
    _frontImageView.layer.cornerRadius = 4;
    _frontImageView.layer.masksToBounds = YES;
    _middleImageView.layer.cornerRadius = 4;
    _middleImageView.layer.masksToBounds = YES;
    _behindImageView.layer.cornerRadius = 4;
    _behindImageView.layer.maskedCorners = YES;
}

- (void)setImages:(NSArray *)images {
    _frontImageIndex = 0;
    _behindImageIndex = 2;
    _images = images;
    
    // only support images's count lager than 3
    if (images.count < 3) {
        return;
    }
    [_frontImageView setImage:[UIImage imageNamed:images[0]]];
    [_middleImageView setImage:[UIImage imageNamed:images[1]]];
    [_behindImageView setImage:[UIImage imageNamed:images[2]]];
}

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)recognizer {
    if (self.animating) {
        return;
    }
    
    CGPoint center = _frontImageView.center;
    CGRect frontFrame = _frontImageView.frame;
    CGRect middleFrame = _middleImageView.frame;
    CGRect behindFrame = _behindImageView.frame;
    [UIView animateWithDuration:0.25 animations:^{
        if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            self.frontImageView.transform = CGAffineTransformMakeRotation(-60 * M_PI * 0.25/180);
            self.frontImageView.center = CGPointMake(- self.frame.size.width, self.frame.size.height/2.0);
        }
        else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
            self.frontImageView.transform = CGAffineTransformMakeRotation(60 * M_PI * 0.25/180);
            self.frontImageView.center = CGPointMake(self.frame.size.width * 2, self.frame.size.height/2.0);
        }
        self.middleImageView.frame = frontFrame;
        self.middleImageView.alpha = 1;
        self.behindImageView.frame = middleFrame;
        self.behindImageView.alpha = 0.7;
    } completion:^(BOOL finished) {
        self.animating = NO;
        
        self.frontImageView.transform = CGAffineTransformIdentity;
        self.frontImageView.center = center;
        
        self.middleImageView.frame = middleFrame;
        self.middleImageView.alpha = 0.7;
        self.behindImageView.frame = behindFrame;
        self.behindImageView.alpha = 0.4;
        
        self.behindImageIndex ++ ;
        if (self.behindImageIndex >= self.images.count) {
            self.behindImageIndex = 0;
        }
        self.frontImageIndex ++ ;
        if (self.frontImageIndex >- self.images.count) {
            self.frontImageIndex = 0;
        }
        
        [self.frontImageView setImage:self.middleImageView.image];
        [self.middleImageView setImage:self.behindImageView.image];
        [self.behindImageView setImage:[UIImage imageNamed:self.images[self.behindImageIndex]]];
    }];
}

- (IBAction)tapAction:(id)sender {
    !_tapBlock ? : _tapBlock(_frontImageIndex);
}

@end
