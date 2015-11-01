//
//  ZCAllToolsCollectionViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/31.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCAllToolsCollectionViewController.h"
#import "ZCAllToolsControllerHeader.h"

@interface ZCAllToolsCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation ZCAllToolsCollectionViewController

- (NSMutableArray *)sections {
    if (_sections == nil) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self registerCells];
    
    self.collectionView.backgroundColor = RGBA(231, 231, 231, 1);
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    // 添加分组
    [self addSectionInlife];
    [self addSectionOutDoor];
    [self addSectionEducation];
    [self addSectionTicket];
    
}

// 注册cells
- (void)registerCells {
    
    // 注册单个按钮cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZCItemCell" bundle:nil] forCellWithReuseIdentifier:@"ZCItemCell"];
    
    // 注册headerCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZCHeaderViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZCHeaderViewCell"];
    
}

#pragma mark - 添加Section

- (void)addSectionInlife {
    
    // 添加ItemSection
    ZCSectionModel *section = [ZCSectionModel defaultSection];
    section.headerTitle = @"生活常用";
    
    // 添加item
    ZCItemModel *expressItem = [ZCItemModel itemWithTitle:@"快递查询" icon:@"express" destVcClass:[ZCRootViewController class]];
    ZCItemModel *TVItem = [ZCItemModel itemWithTitle:@"电视节目" icon:@"tv" destVcClass:[ZCRootViewController class]];
    ZCItemModel *areacodeItem = [ZCItemModel itemWithTitle:@"区号查询" icon:@"areacode" destVcClass:[ZCRootViewController class]];
    ZCItemModel *zipcodeItem = [ZCItemModel itemWithTitle:@"邮编查询" icon:@"zipcode" destVcClass:[ZCRootViewController class]];
    
    [section.items addObjectsFromArray:@[expressItem, TVItem, areacodeItem, zipcodeItem]];
    [self.sections addObject:section];
    
}

- (void)addSectionOutDoor {
    
    ZCSectionModel *section = [ZCSectionModel defaultSection];
    section.headerTitle = @"出行必备";
    
    // 添加ItemSection
    ZCItemModel *trainItem = [ZCItemModel itemWithTitle:@"火车查询" icon:@"train" destVcClass:[ZCRootViewController class]];
    
    // 添加Item
    ZCItemModel *oilItem = [ZCItemModel itemWithTitle:@"今日油价" icon:@"oil" destVcClass:[ZCRootViewController class]];
    
    [section.items addObjectsFromArray:@[trainItem, oilItem]];
    [self.sections addObject:section];
}

- (void)addSectionEducation {
    
    // 添加ItemSection
    ZCSectionModel *section = [ZCSectionModel defaultSection];
    section.headerTitle = @"知识技能";
    
    // 添加item
    ZCItemModel *wikiItem = [ZCItemModel itemWithTitle:@"百度百科" icon:@"wiki" destVcClass:[ZCRootViewController class]];
    ZCItemModel *translateItem = [ZCItemModel itemWithTitle:@"翻译" icon:@"translate" destVcClass:[ZCRootViewController class]];
    ZCItemModel *historyItem = [ZCItemModel itemWithTitle:@"历史上的今天" icon:@"todayhistory" destVcClass:[ZCRootViewController class]];
    ZCItemModel *newsItem = [ZCItemModel itemWithTitle:@"新闻" icon:@"news" destVcClass:[ZCRootViewController class]];
    
    [section.items addObjectsFromArray:@[wikiItem, translateItem, historyItem, newsItem]];
    [self.sections addObject:section];
    
}

- (void)addSectionTicket {
    
    // 添加ItemSection
    ZCSectionModel *section = [ZCSectionModel defaultSection];
    section.headerTitle = @"投资理财";
    
    // 添加item
    ZCItemModel *ticketItem = [ZCItemModel itemWithTitle:@"彩票开奖" icon:@"ticket" destVcClass:[ZCRootViewController class]];
    ZCItemModel *goldItem = [ZCItemModel itemWithTitle:@"黄金价格" icon:@"gold" destVcClass:[ZCRootViewController class]];
    ZCItemModel *silverItem = [ZCItemModel itemWithTitle:@"白银价格" icon:@"silver" destVcClass:[ZCRootViewController class]];
    
    [section.items addObjectsFromArray:@[ticketItem, goldItem, silverItem]];
    [self.sections addObject:section];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZCSectionModel *sectionModel = self.sections[section];
    return sectionModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获得cell
    ZCItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCItemCell" forIndexPath:indexPath];
    // 传递模型
    ZCSectionModel *sectionModel = self.sections[indexPath.section];
    cell.item = sectionModel.items[indexPath.row];
    
    return cell;
}

// cell相关header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // 如果是collectionView的HeaderView
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZCSectionModel *sectionModel = self.sections[indexPath.section];
        
        static NSString *headerViewReuseID = @"ZCHeaderViewCell";
        ZCHeaderViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewReuseID forIndexPath:indexPath];
        
        cell.backgroundColor = FlatGreenDark;
        
        cell.titleLabel.text = sectionModel.headerTitle;
        
        return cell;
    }
    return nil;
}

#pragma mark <UICollectionViewDelegate>

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCSectionModel *section = self.sections[indexPath.section];
    ZCItemModel *item = section.items[indexPath.row];
    
    // 运行block
    if (item.selectionHandler) {
        item.selectionHandler();
    }
    
    if (item.destVcClass) {
        UIViewController *viewController = [[item.destVcClass alloc] init];
        viewController.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

@end
