//
//  TestDriveViewController.m
//  miniNL
//
//  Created by German Villegas on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestDriveViewController.h"
#define kOFFSET_FOR_KEYBOARD 110.0


@interface TestDriveViewController ()

@end

@implementation TestDriveViewController

#pragma mark - Properties

@synthesize carro = _carro;

@synthesize lbTitulo = _lbTitulo;
@synthesize txtNombre = _txtNombre;
@synthesize txtApellido = _txtApellido;
@synthesize txtMail = _txtMail;
@synthesize txtTelefono = _txtTelefono;
@synthesize txtCiudad = _txtCiudad;
@synthesize txtCarro = _txtCarro;
@synthesize fondoImageView = _fondoImageView;

#pragma mark - View Management

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txtCarro.text = _carro;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTxtNombre:nil];
    [self setTxtApellido:nil];
    [self setTxtMail:nil];
    [self setTxtTelefono:nil];
    [self setTxtCiudad:nil];
    [self setTxtCarro:nil];
    [self setLbTitulo:nil];
    [self setFondoImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)backgroundTouched:(id)sender {
    [_txtNombre resignFirstResponder];
    [_txtApellido resignFirstResponder];
    [_txtMail resignFirstResponder];
    [_txtTelefono resignFirstResponder];
    [_txtCiudad resignFirstResponder];
    [_txtCarro resignFirstResponder];
}

- (IBAction)enviar:(UIButton *)sender {
    
    NSString *nombre = self.txtNombre.text;
    NSString *apellido = self.txtApellido.text;
    NSString *mail = self.txtMail.text;
    NSString *telefono = self.txtTelefono.text;
    NSString *ciudad = self.txtCiudad.text;
    NSString *carro = self.txtCarro.text;
    
    if ([nombre length] != 0 && [apellido length] != 0 && [mail length] != 0 && [telefono length] != 0 && [ciudad length] != 0 && [carro length] != 0 ) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            
            mailer.mailComposeDelegate = self;
            
            [mailer setSubject:@"Solicitud de Test Drive"];
            [mailer setToRecipients:[NSArray arrayWithObject:@"jjr2040@hotmail.com"]];
            
            NSString *body = [NSString stringWithFormat:@"A continuación encuentra los datos del solicitante:\n-nombre: %@\n-apellido: %@\n-mail: %@\n-telefono: %@\n-ciudad: %@\n-carro: %@\n",nombre, apellido, mail, telefono, ciudad, carro];
            
            [mailer setMessageBody:body isHTML:NO];
            [self presentModalViewController:mailer animated:YES];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"Su dispositivo no soporta el envío de emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"Tiene que llenar todos los campos del formulario." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (IBAction)back:(UIButton *)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            self.fondoImageView.image = [UIImage imageNamed:@"imagen_solicitud.jpg"];
            [self.txtApellido removeFromSuperview];
            [self.txtCarro removeFromSuperview];
            [self.txtCiudad removeFromSuperview];
            [self.txtMail removeFromSuperview];
            [self.txtNombre removeFromSuperview];
            [self.txtTelefono removeFromSuperview];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Keyboard Management

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//    return YES;
//}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
//    if ([sender isEqual:mailTf])
//    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
//    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.lbTitulo.font = [UIFont fontWithName:@"MINIType v2 Regular" size:18];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
