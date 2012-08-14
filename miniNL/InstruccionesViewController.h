//
//  InstruccionesViewController.h
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstruccionesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

- (IBAction)closeModal:(UIButton *)sender;

@end
