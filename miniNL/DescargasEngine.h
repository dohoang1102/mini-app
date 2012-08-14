//
//  DescargasEngine.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 29/07/12.
//
//

#import "MKNetworkEngine.h"
#import "Ringtone.h"

@interface DescargasEngine : MKNetworkEngine

typedef void (^ImageResponseBlock)(UIImage * imagen);

typedef void (^ArrayDescargasResponseBlock)(NSArray * array, NSInteger numWallpapers);

typedef void (^DataRingtoneResponseBlock) (NSData * ringtone);

-(MKNetworkOperation *) descargarImagenConURL:(NSString *) url
                                 onCompletion:(ImageResponseBlock) completionBlock
                                      onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) descargarWallpapersConURL:(NSString *) url
                                     onCompletion:(ArrayDescargasResponseBlock) completionBlock
                                          onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) descargarRingtonesConURL:(NSString *) url
                                    onCompletion:(ArrayDescargasResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) descargarRingtoneConURL:(NSString *)url
                                       fileName:(NSString *) name
                                   onCompletion:(MKNKResponseBlock)completionBlock
                                        onError:(MKNKErrorBlock)errorBlock;

@end
