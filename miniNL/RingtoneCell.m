//
//  RingtoneCell.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 31/07/12.
//
//

#import "RingtoneCell.h"
#import <AVFoundation/AVFoundation.h>

@interface RingtoneCell ()
@property (nonatomic) AVPlayer * player;
@property (nonatomic) AVPlayerItem * playerItem;
@property (nonatomic) id timeObserver;
@end

@implementation RingtoneCell
@synthesize slider = _slider;
@synthesize loadActivityIndicator = _loadActivityIndicator;
@synthesize lbNombre, btnPause, btnPlay;
@synthesize player = _player;
@synthesize timeObserver = _timeObserver;
@synthesize ringtone = _ringtone;
@synthesize playerItem = _playerItem;


-(void)setRingtone:(Ringtone *)ringtone{

    _ringtone = ringtone;
    
//    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:ringtone.archivoURL]];
//    
////    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:ringtone.archivoURL]];
//    
//    [_loadActivityIndicator startAnimating];
//    btnPlay.enabled = NO;
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:_player.currentItem];
    
    
    
    UIImage *stretchLeftImage = [[UIImage imageNamed:@"gray-track.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    
    UIImage *stretchRightImage = [[UIImage imageNamed:@"white-track.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    
    UIImage *thumbImage= [UIImage imageNamed:@"cuadradito-gris.png"];
    

    if (thumbImage == nil) {
        NSLog(@"Es el ejemplo de una imagen %f", [thumbImage size].height);
    }
    
    
    // Setup the FX slider
    
    [_slider setMinimumTrackImage:stretchLeftImage forState:UIControlStateNormal];
    
    [_slider setMaximumTrackImage:stretchRightImage forState:UIControlStateNormal];
    
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    _slider.userInteractionEnabled = NO;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerItemStatusReadyToPlay) {
            
        }else if (_player.status == AVPlayerStatusReadyToPlay) {
//            [_loadActivityIndicator stopAnimating];
//            btnPlay.enabled = YES;
//            [_player play];
            // something went wrong. player.error should contain some information
        }
        else if (_player.status == AVPlayerStatusFailed) {
            // something went wrong. player.error should contain some information
        }
    }
    else if (object == _player.currentItem && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerItemStatusReadyToPlay) {
            [self initSliderTimer];
            [_loadActivityIndicator stopAnimating];
            btnPlay.enabled = YES;
            [_player play];
        }else if (_player.status == AVPlayerStatusReadyToPlay) {
            [self initSliderTimer];
            // something went wrong. player.error should contain some information
        }
        else if (_player.status == AVPlayerStatusFailed) {
            // something went wrong. player.error should contain some information
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_player seekToTime:kCMTimeZero];
}

-(void)dealloc{
    
    [_player removeObserver:self forKeyPath:@"status"];
}

-(void)initSliderTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration]; 
    
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([_slider bounds]);
        interval = 0.5f * duration / width;
    }
    
    /* Update the scrubber during normal playback. */
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                          queue:NULL /* If you pass NULL, the main queue is used. */
                                                     usingBlock:^(CMTime time)
                     {
                         [self syncSlider];
                     }];
    
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *thePlayerItem = [_player currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        
        return([thePlayerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

- (void)syncSlider
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        _slider.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [_slider minimumValue];
        float maxValue = [_slider maximumValue];
        double time = CMTimeGetSeconds([_player currentTime]);
        [_slider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) prepareForReuse{
    [super prepareForReuse];
    
}

- (IBAction)play:(UIButton *)sender {
    
    if (_player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [_player play];
    }
    else{
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:_ringtone.archivoURL]];
        [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
        [_player.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        [_loadActivityIndicator startAnimating];
        btnPlay.enabled = NO;
    }

//    [_player play];
//    [self initSliderTimer];
}

- (IBAction)pause:(UIButton *)sender {
    [_player pause];
}


@end
