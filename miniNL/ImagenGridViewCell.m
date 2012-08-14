//
//  ImagenGridViewCell.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import "ImagenGridViewCell.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"

@implementation ImagenGridViewCell

@synthesize imageView = _imageView;
@synthesize imagenGaleria = _imagenGaleria;
@synthesize activityIndicator = _activityIndicator;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    
    if ( self == nil )
        return ( nil );
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    
    [self.contentView addSubview:self.activityIndicator];
    
    [self.contentView addSubview: _imageView];
    
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    
    return self;
}

-(void) setImagenGaleria:(ImagenGaleria *)imagenGaleria{
    
    _imagenGaleria = imagenGaleria;
    
    [_activityIndicator startAnimating];
    
    [ApplicationDelegate.comunidadEngine descargarImagenConURL:_imagenGaleria.thumbnailURL onCompletion:^(UIImage * img){
        
        _imagenGaleria.thumbnail = [UIImage imageWithData:UIImageJPEGRepresentation(img, 1.0f)];
        
        _imageView.image = [_imagenGaleria.thumbnail resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:_imageView.frame.size interpolationQuality: kCGInterpolationHigh];
        
        _imageView.autoresizesSubviews = NO;
//        _imageView.bounds.size = _imagenGaleria.thumbnail.size;
        
        [_activityIndicator stopAnimating];
        
    }onError:^(NSError * error){
        
    }];
    
}

@end
