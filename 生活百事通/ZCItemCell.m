//
//  ZCItemCell.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCItemCell.h"
#import "ZCHeader.h"
#import "ZCItemModel.h"

@interface ZCItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZCItemCell

- (void)awakeFromNib {
    
    self.iconImage.layer.cornerRadius = 8;
    self.iconImage.clipsToBounds = YES;
    self.backgroundColor = RGBA(231, 231, 231, 1);
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setItem:(ZCItemModel *)item {
    _item = item;
    self.iconImage.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.title;
}


@end


