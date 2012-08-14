//
//  ImagenDetailViewController.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 7/08/12.
//
//

#import "ImagenDetailViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"

@interface ImagenDetailViewController ()

@end

@implementation ImagenDetailViewController

@synthesize imageView = _imageView;
@synthesize lbTotal = _lbTotal;
@synthesize lbActual = _lbActual;
@synthesize imagenGaleria = _imagenGaleria;
@synthesize total = _total;
@synthesize actual = _actual;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (!_imageView.image) {
        [DejalWhiteActivityView activityViewForView:self.view withLabel:@"Descargando Imagen..."];
    }
    [ApplicationDelegate.comunidadEngine descargarImagenConURL:_imagenGaleria.imagenURL onCompletion:^(UIImage * imagen){
        
        UIImage * imgJpeg = [[UIImage imageWithData:UIImageJPEGRepresentation(imagen, 1.0f)] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:_imageView.bounds.size interpolationQuality: kCGInterpolationHigh];
        
        _imageView.image = imgJpeg;
                
        CGRect bounds;
        
        bounds.origin = CGPointZero;
        
        bounds.size = imgJpeg.size;
        
        _imageView.bounds = bounds;
        
        [DejalWhiteActivityView removeView];
        
    } onError:^(NSError *error){
        NSLog(@"Hubo un error bajando la imagen ");
    }];
    
    
    
    _lbTotal.text = _total.stringValue;
    _lbActual.text = _actual.stringValue;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_actual.unsignedIntValue < 9) {
        _lbActual.center = CGPointMake(_lbActual.center.x + 13.0f, _lbActual.center.y);
    }
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setLbTotal:nil];
    [self setLbActual:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)back:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)decargar:(UIButton *)sender {
    
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Felicitaciones"
                                                    message:@"El wallpaper a sido guardado en la galeria de imágenes."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}




- (IBAction)mail:(UIButton *)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        //        [mailer setSubject:@"Solicitud de Test Drive"];
        //        [mailer setToRecipients:[NSArray arrayWithObject:@"jjr2040@hotmail.com"]];
        
        //        NSString *body = [NSString stringWithFormat:@"A continuación encuentra los datos del solicitante:\n-nombre: %@\n-apellido: %@\n-mail: %@\n-telefono: %@\n-ciudad: %@\n-carro: %@\n",nombre, apellido, mail, telefono, ciudad, carro];
        
        [mailer addAttachmentData:UIImageJPEGRepresentation(_imageView.image, 1.0) mimeType:@"image/jpeg" fileName:_imagenGaleria.nombre];
        
        //        [mailer setMessageBody:body isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"Su dispositivo no soporta el envío de emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
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

- (IBAction)facebook:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/MINI"]];
}

- (IBAction)twitter:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/MINI"]];
}

- (IBAction)like:(UIButton *)sender {
    
}

- (IBAction)share:(UIButton *)sender {
}
@end
