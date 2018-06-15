//
//  ViewController.m
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/14.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import "ViewController.h"
#import "HRYHomeProjectView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet HRYHomeProjectView *projectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _projectView.images = @[@"placeholder1", @"placeholder2", @"placeholder3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
