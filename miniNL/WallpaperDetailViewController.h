//
//  WallpaperDetailViewController.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 30/07/12.
//
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import "Wallpaper.h"

@interface WallpaperDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Wallpaper *wallpaper;

@property (nonatomic) NSNumber *total;

@property (nonatomic) NSNumber *actual;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbActual;


- (IBAction)back:(UIButton *)sender;


- (IBAction)decargar:(UIButton *)sender;

- (IBAction)mail:(UIButton *)sender;

- (IBAction)facebook:(UIButton *)sender;

- (IBAction)twitter:(UIButton *)sender;

- (IBAction)like:(UIButton *)sender;

- (IBAction)share:(UIButton *)sender;


@end
