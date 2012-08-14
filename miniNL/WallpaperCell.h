//
//  WallpaperCell.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 29/07/12.
//
//

#import <UIKit/UIKit.h>
#import "Wallpaper.h"

@interface WallpaperCell : UITableViewCell

@property (nonatomic, strong) Wallpaper * wallpaper;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet UIImageView * thumbnailImageView;

@property (nonatomic, weak) IBOutlet UIButton * btnDescargar;

@end
