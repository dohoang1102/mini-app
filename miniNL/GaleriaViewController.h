//
//  GaleriaViewController.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface GaleriaViewController : UIViewController<AQGridViewDataSource,AQGridViewDelegate>

@property (nonatomic, retain) IBOutlet AQGridView * gridView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (nonatomic, strong) NSArray * imagenes;

- (IBAction)back:(UIButton *)sender;
@end
