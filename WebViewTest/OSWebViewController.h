//
//  OSWebViewController.h
//  so
//
//  Created by DavidLaw on 2017/9/23.
//  Copyright © 2017年 几何. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSWebViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;      //default UIStatusBarStyleDefault

@end

