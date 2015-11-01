//
//  ZCUserTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/31.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCUserTableViewController.h"
// 导入系统信息邮件库
#import <MessageUI/MessageUI.h>
// 导入第三方tableView库
#import <RETableViewManager/RETableViewManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
// 导入自己写的
#import "ZCWeatherModel.h"
#import "ZCAboutViewController.h"

@interface ZCUserTableViewController ()<RETableViewManagerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) RETableViewManager *manager;

@end

#define SectionHeaderHeight 42
#define SectionFooterHeight 0.5

@implementation ZCUserTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用第三方库RETableViewManager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager.style.cellHeight = 36;
    
    // 选中不显示高亮
    self.manager.style.defaultCellSelectionStyle = UITableViewCellSelectionStyleNone;
    
    // 添加Section
    [self addSectionUpdate];
    [self addSectionSetting];
    [self addSectionSuggestion];
    [self addSectionAbout];
}

// 添加第一个section
- (void)addSectionUpdate {
    
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    section.headerTitle = @"检查更新";
    section.headerHeight = SectionHeaderHeight;
    section.footerHeight = SectionFooterHeight;
    
    // 创建检查更新条目
    RETableViewItem *item = [RETableViewItem itemWithTitle:@"检查更新" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
        [SVProgressHUD showWithStatus:@"检查更新中..." maskType:SVProgressHUDMaskTypeGradient];
        
        // 使用dispatch time 延迟，模拟检查更新
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showSuccessWithStatus:@"没有更新"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }];
    [section addItem:item];
}

// 添加第二个section
- (void)addSectionSetting {
    
    // 创建一个组
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    section.headerHeight = SectionHeaderHeight;
    section.footerHeight = SectionFooterHeight;
    section.headerTitle = @"系统设置";
    
    // 创建清理缓存条目
    RETableViewItem *cleanItem = [RETableViewItem itemWithTitle:@"清理缓存" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
       
        [SVProgressHUD showWithStatus:@"清理缓存中..." maskType:SVProgressHUDMaskTypeGradient];
        
        // 清理缓存文件
        [self cleanCache];
        
    }];
    [section addItem:cleanItem];
    
    // 创建天气条目
    NSString *city = @"滁州";
    if (self.weatherModel) {
        ZCWeatherData *weatherData = self.weatherModel.weather_data[0];
        city = [NSString stringWithFormat:@"%@     %@", self.weatherModel.currentCity, weatherData.temperature];
    }
    
    RETableViewItem *weatherItem = [RETableViewItem itemWithTitle:city accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:weatherItem];
    
    // 创建定位按钮
    REBoolItem *locationItem = [REBoolItem itemWithTitle:@"定位" value:NO switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    [section addItem:locationItem];
}

// 清理缓存文件
- (void)cleanCache {
    
    // 设置延迟
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        // 清理缓存
        // 找到cache路径
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // 找出缓存文件个数
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        NSUInteger fileCount = files.count;
        
        // 清理缓存文件
        for (NSString *cache in files) {
            NSError *error;
            NSString *path = [cachePath stringByAppendingPathComponent:cache];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        // 判断缓存文件
        if (fileCount <= 1) {
            [SVProgressHUD showErrorWithStatus:@"暂时没有缓存文件!"];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"清理缓存文件%ld个", fileCount]];
        }
        // 让弹框消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
    
}

// 添加第三个section
- (void)addSectionSuggestion {
    
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    section.headerHeight = SectionHeaderHeight;
    section.footerHeight = SectionFooterHeight;
    section.headerTitle = @"评价反馈";
    
    // 创建评价条目
    RETableViewItem *discussItem = [RETableViewItem itemWithTitle:@"评分与评价" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:discussItem];
    
    // 创建反馈问题条目
    RETableViewItem *suggestionItem = [RETableViewItem itemWithTitle:@"反馈问题" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        // 发送邮件
        [self sendEmail];
    }];
    [section addItem:suggestionItem];
    
}

// 添加第四个section
- (void)addSectionAbout {
    
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    section.headerHeight = SectionHeaderHeight;
    section.footerHeight = 30;
    section.headerTitle = @"关于";
    
    UILabel *versionLabel = [self versionLabel];
    section.footerView = versionLabel;
    
    // 创建开源许可条目
    RETableViewItem *licenceItem = [RETableViewItem itemWithTitle:@"开源许可" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
    }];
    [section addItem:licenceItem];
    
    // 创建关于条目
    RETableViewItem *aboutItem = [RETableViewItem itemWithTitle:@"关于" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        ZCAboutViewController *about = [[ZCAboutViewController alloc] init];
        about.title = @"关于";
        [self.navigationController pushViewController:about animated:YES];
        
    }];
    [section addItem:aboutItem];
    
}

// 抽出显示版本的label
- (UILabel *)versionLabel {
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    versionLabel.text = @"LifeTools iOS Version 1.1";
    versionLabel.font = [UIFont fontWithName:@"Menlo" size:12];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    return versionLabel;
}

// 发送邮件
- (void)sendEmail {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass) {
        if ([mailClass canSendMail]) {
            [self displayComposerSheet];
        }
        else {
            [self launchMailAppOnDevice];
        }
    }
    else {
        [self launchMailAppOnDevice];
    }
    
}

// 可以发送邮件
- (void)displayComposerSheet {
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    // 设置邮件主题
    [mailPicker setSubject:@"意见反馈"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject:@"zcillcoder@gmail.com"];
    [mailPicker setToRecipients:toRecipients];
    
    [mailPicker setMessageBody:@"" isHTML:NO];
    [self presentViewController:mailPicker animated:YES completion:nil];
    
}

// 转到系统邮件
- (void)launchMailAppOnDevice {
    
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *emailPath = [NSString stringWithFormat:@"%@%@", recipients, body];
    emailPath = [emailPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    
}

// 邮件发送完成回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存为草稿";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// alert提示用户邮件的完成回调信息
- (void)alertWithTitle:(NSString *)_title_ msg:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_ message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
