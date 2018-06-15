//
//  HRYHomeProjectView.h
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRYHomeProjectView : UIView

@property (nonatomic, strong) NSArray<NSString*> *images;
@property (nonatomic, copy) void(^tapBlock)(NSInteger);

@end
