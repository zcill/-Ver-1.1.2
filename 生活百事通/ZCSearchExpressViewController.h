//
//  ZCSearchExpressViewController.h
//  生活百事通
//
//  Created by 朱立焜 on 15/11/8.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSearchExpressViewController : UIViewController

typedef void (^completeBlock)(NSString *name, NSString *type);

@property (nonatomic, copy) completeBlock returnStringBlock;

- (void)returnString:(completeBlock)block;

@end
