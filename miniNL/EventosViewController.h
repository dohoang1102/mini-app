//
//  EventosViewController.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import <UIKit/UIKit.h>

@interface EventosViewController : UIViewController

@property (nonatomic, strong) NSArray * eventos;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento1;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento2;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento3;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento4;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento5;

@property (weak, nonatomic) IBOutlet UIButton *btnEvento6;

@property (nonatomic, strong) IBOutlet UIButton * btnEvento7;

@property (nonatomic, strong) IBOutlet UIButton * btnEvento8;

- (IBAction)back:(UIButton *)sender;

@end
