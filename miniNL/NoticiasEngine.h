//
//  NoticiasEngine.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 27/07/12.
//
//

#import "MKNetworkEngine.h"

@interface NoticiasEngine : MKNetworkEngine

typedef void (^HTMLResponseBlock)(NSString* webPage);
typedef void (^ArrayResponseBlock)(NSArray* array);

-(MKNetworkOperation *) noticiaWithURL:(NSString *)path
                          onCompletion:(HTMLResponseBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation *) downloadFromURL: (NSString *) url;

-(MKNetworkOperation * ) darNoticiasPorCategoria:(NSString *) categoria
                          inManagedObjectContext:(NSManagedObjectContext *) context
                                    onCompletion:(ArrayResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock;

@end
