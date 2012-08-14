//
//  TestDriveViewController.h
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"

@interface TestDriveViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString * carro;

@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UITextField *txtNombre;

@property (weak, nonatomic) IBOutlet UITextField *txtApellido;

@property (weak, nonatomic) IBOutlet UITextField *txtMail;

@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;

@property (weak, nonatomic) IBOutlet UITextField *txtCiudad;

@property (weak, nonatomic) IBOutlet UITextField *txtCarro;

@property (weak, nonatomic) IBOutlet UIImageView *fondoImageView;


- (IBAction)backgroundTouched:(id)sender;

- (IBAction)enviar:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;

@end
