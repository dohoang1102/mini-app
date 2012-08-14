//
//  WallpapersViewController.h
//  miniNL
//
//  Created by German Villegas on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NUM_WALLPAPERS 5

@interface WallpapersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *wallpapers;
@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)verMas:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;

- (IBAction)descargar:(UIButton *)sender;

@end
