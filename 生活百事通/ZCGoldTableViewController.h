//
//  ZCGoldTableViewController.h
//  生活百事通
//
//  Created by 朱立焜 on 15/11/6.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

// 黄金种类
typedef NS_ENUM(NSUInteger, ZCGoldSearchType) {
    
    ZCGoldSearchTypeAuTD = 1,     // 黄金延期
    ZCGoldSearchTypeMAuTD,    // 迷你黄金延期
    ZCGoldSearchTypeAu99,   // 沪金99
    ZCGoldSearchTypePt95,   // 沪铂95
    ZCGoldSearchTypeAu100,  // 沪金100G
    ZCGoldSearchTypeAuTN2,  // 延期双金
    ZCGoldSearchTypeAuTN1,  // 延期单金
    ZCGoldSearchTypeIAu100, // iAu100
    ZCGoldSearchTypeIAu995, // iAu99.5
    ZCGoldSearchTypeIAu999, // iAu99.9
    ZCGoldSearchTypeAu95    // 沪金95
    
};

@interface ZCGoldTableViewController : UITableViewController

@property (nonatomic, assign) ZCGoldSearchType goldSearchType;

@end
