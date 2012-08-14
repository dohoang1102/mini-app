//
//  WallpaperCell.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 29/07/12.
//
//

#import "WallpaperCell.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"

@implementation WallpaperCell

@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize wallpaper = _wallpaper;
@synthesize activityIndicator = _activityIndicator;

-(void)setWallpaper:(Wallpaper *)wallpaper{
    _wallpaper = wallpaper;
    
    if (!self.wallpaper) {
        [_activityIndicator startAnimating];
    }
    
    
    
    [ApplicationDelegate.descargasEngine descargarImagenConURL:wallpaper.thumbnailURL onCompletion:^(UIImage * image){
        
        _wallpaper.thumbnail = image;
        
        _thumbnailImageView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:_thumbnailImageView.bounds.size interpolationQuality: kCGInterpolationHigh];
        
        [_activityIndicator stopAnimating];
        
    }onError:^(NSError * error){
        
    }];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
