//
//  ImagenGridViewCell.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 6/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "ImagenGaleria.h"

@interface ImagenGridViewCell : AQGridViewCell

@property (nonatomic, strong) ImagenGaleria *imagenGaleria;

@property(nonatomic, retain) UIImageView * imageView;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end
