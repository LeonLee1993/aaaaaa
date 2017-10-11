//
//  HDCalendarViewController.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDCalendarViewController.h"

@interface HDCalendarViewController ()
@property (weak, nonatomic) IBOutlet PSYDatepicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HDCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
