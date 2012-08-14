//
//  VitrinasMenuViewController.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Vitrina.h"

@interface VitrinasMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>



@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UITableView *ciudadesTableView;

- (IBAction)pushVitrinaDetail:(UIButton *)sender;


@end
