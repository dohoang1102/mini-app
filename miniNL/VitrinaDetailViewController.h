//
//  VitrinaDetailViewController.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Vitrina.h"

@interface VitrinaDetailViewController : UIViewController

@property (strong, nonatomic) Vitrina * vitrina;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;
@property (weak, nonatomic) IBOutlet UILabel *lbCiudad;
@property (weak, nonatomic) IBOutlet UILabel * lbInfoVitrina;
@property (retain, nonatomic) IBOutlet UIImageView * empleadoImageView;

@property (retain, nonatomic) IBOutlet UILabel * lbInfoEmpleado;

@property (weak, nonatomic) IBOutlet UIImageView *vitrinaImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)back:(UIButton *)sender;
@end
