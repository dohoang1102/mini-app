//
//  RingtoneViewController.h
//  miniNL
//
//  Created by German Villegas on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RingtoneViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *ringtones;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



- (IBAction)back:(UIButton *)sender;
//- (IBAction)play:(UIButton *)sender;
//- (IBAction)pause:(UIButton *)sender;
- (IBAction)descargar:(UIButton *)sender;

@end
