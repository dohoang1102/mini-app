//
//  RingtoneCell.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 31/07/12.
//
//

#import <UIKit/UIKit.h>
#import "Ringtone.h"

@interface RingtoneCell : UITableViewCell

@property (nonatomic, strong) Ringtone * ringtone;

@property (nonatomic,weak) IBOutlet UIImageView * fondoImageView;

@property (nonatomic, weak) IBOutlet UIButton * btnPlay;

@property (nonatomic, weak) IBOutlet UIButton * btnPause;
@property (weak, nonatomic) IBOutlet UILabel *lbNombre;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadActivityIndicator;

- (IBAction)play:(UIButton *)sender;
- (IBAction)pause:(UIButton *)sender;

@end
