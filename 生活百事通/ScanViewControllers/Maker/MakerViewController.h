//
//  MakerViewController.h
//  Scanner
//
//  Created by Jakey on 15/8/21.
//  Copyright © 2015年 Jakey. All rights reserved.
//

#import "BaseViewController.h"

@interface MakerViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIImageView *qrcode;

- (IBAction)makerTouched:(id)sender;
@end
