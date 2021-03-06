//
//  HRYConferencePointView.h
//  WebViewTest
//
//  Created by DavidLaw on 2018/6/15.
//  Copyright © 2018年 DavidLaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRYConferencePointView : UIImageView

@property (nonatomic, copy) BOOL(^pointDidEndMoveBlock)(CGFloat ratio);
@property (nonatomic, copy) void(^pointDidMoveBlock)(CGFloat ratio);

@property (nonatomic, assign) CGFloat ratio;

@end
