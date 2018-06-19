//
//  HRYConferenceDateViewController.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/19.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "HRYConferenceDateViewController.h"
#import "HRYConferenceDateSlider.h"

@interface HRYConferenceDateViewController ()
@property (weak, nonatomic) IBOutlet HRYConferenceDateSlider *sliderView;

@end

@implementation HRYConferenceDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_sliderView setView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
}

@end
