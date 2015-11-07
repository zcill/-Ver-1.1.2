//
//  ZCSearchTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/7.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCSearchTableViewController.h"

@interface ZCSearchTableViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchResult;

@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZCSearchTableViewController

- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        
        _dataSource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bus_Cities" ofType:@"plist"]];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResult = [[NSMutableArray alloc] init];
    
    [self initTableView];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.displayController.searchResultsDelegate = self;
    self.displayController.searchResultsDataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    if (tableView == self.tableView) {
        
        cell.textLabel.text = dict[@"name"];
        cell.detailTextLabel.text = dict[@"cityid"];
        
    } else {
        
        NSDictionary *dict = self.searchResult[indexPath.row];
        
        cell.textLabel.text = dict[@"name"];
        cell.detailTextLabel.text = dict[@"cityid"];
        
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        
        return self.dataSource.count;
        
    }
    else {
        
        [self.searchResult removeAllObjects];
        
        for (NSDictionary *dict in self.dataSource) {
            
            NSRange range = [dict[@"name"] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound) {
                [self.searchResult addObject:dict];
            }
        }
        
        return self.searchResult.count;
        
    }
    return 0;
}

@end
