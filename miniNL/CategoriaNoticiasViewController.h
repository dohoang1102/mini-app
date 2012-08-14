//
//  CategoriaNoticiasViewController.h
//  Mini Colombia
//
//  Created by German Villegas on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@interface CategoriaNoticiasViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString * categoria;

@property (nonatomic, strong) NSManagedObjectContext * moc;

@property (weak, nonatomic) IBOutlet UILabel *lbCategoria;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(UIButton *)sender;

@end
