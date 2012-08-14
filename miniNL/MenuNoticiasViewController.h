//
//  MenuNoticiasViewController.h
//  Mini Colombia
//
//  Created by German Villegas on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@interface MenuNoticiasViewController : CoreDataViewController

@property (nonatomic,strong) UIManagedDocument *noticiasDB;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@end
