//
//  ZCSearchTableViewController.h
//  生活百事通
//
//  Created by 朱立焜 on 15/11/7.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)(NSString *name, NSString *cityid);

@interface ZCSearchTableViewController : UIViewController

@property (nonatomic, copy) completeBlock returnStringBlock;

- (void)returnString:(completeBlock)block;

@end
