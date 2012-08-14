//
//  DescargasEngine.m
//  Mini Colombia
//
//  Created by Juan José Villegas on 29/07/12.
//
//

#import "DescargasEngine.h"
#import "Wallpaper.h"

@interface DescargasEngine ()

@end

@implementation DescargasEngine


-(MKNetworkOperation *) descargarImagenConURL:(NSString *)url onCompletion:(ImageResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *op = [self operationWithURLString:url params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
       
        UIImage * image = [completedOperation responseImage];
        
        completionBlock(image);
        
    }onError:^(NSError *error){
        errorBlock(error);
        
        NSLog(@"EL ERROR FUE ACA ");
            
        [self emptyCache];
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(MKNetworkOperation *) descargarWallpapersConURL:(NSString *)url onCompletion:(ArrayDescargasResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
    
        
        NSMutableArray *resp = [[NSMutableArray alloc] init];
        
        NSArray *wallpapersArray = [[completedOperation responseJSON] valueForKey:@"wallpapers"];
        
        
        
        for (NSDictionary *wallpaper in wallpapersArray){
            

            NSString *nombre = [wallpaper valueForKey:@"nombre"];
            NSString *imagenURL = [wallpaper valueForKey:@"imagenURL"];
            

            
            NSString * thumbnailURL = [wallpaper valueForKey:@"thumbnailURL"];

            
            [resp addObject:[[Wallpaper alloc] initWithNombre:nombre thumbnailImageURL:thumbnailURL andImageURL:imagenURL]];
            
        }
        
        NSInteger numWallpapers = [[[completedOperation responseJSON] valueForKey:@"num_wallpapers"] integerValue];
        
        completionBlock(resp, numWallpapers);


    }onError:^(NSError *error){
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(MKNetworkOperation *) descargarRingtonesConURL:(NSString *) url
                                    onCompletion:(ArrayDescargasResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation * op = [self operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
       
        NSMutableArray * resp = [[NSMutableArray alloc] init];
        
        NSArray * ringtonesArray = [[completedOperation responseJSON] valueForKey:@"ringtones"];
        
        for (NSDictionary *ringtone in ringtonesArray) {
            NSString * nombre = [ringtone valueForKey:@"nombre"];
            
            NSString * ringtoneURL = [ringtone valueForKey:@"archivoURL"];
            
            [resp addObject:[[Ringtone alloc] initWithNombre:nombre andArchivoURL:ringtoneURL]];
        }
        
        completionBlock(resp,0);
        
    }onError:^(NSError * error){
        
    }];
    
    [self enqueueOperation:op];
    
    return op;
    
}

-(MKNetworkOperation * ) descargarRingtoneConURL:(NSString *)url
                                        fileName:(NSString * ) name
                                    onCompletion:(MKNKResponseBlock)completionBlock
                                         onError:(MKNKErrorBlock)errorBlock{
    MKNetworkOperation *op = [self operationWithURLString:url];
    
    [op onCompletion:^(MKNetworkOperation * completedOperation){
        
        NSError *error;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSData *ringtoneData = [completedOperation responseData];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *imgDir = [ docDir stringByAppendingPathComponent:@"/descargas/ringtones/" ];
        
        if( ![fm fileExistsAtPath:imgDir] ){
            [fm createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", imgDir, name];
        
        [ringtoneData writeToFile:filePath atomically:YES];
        
        completionBlock(op);
        
    }onError:^(NSError * error){
        
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

-(NSString *) cacheDirectoryName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"DescargasCache"];
    return cacheDirectoryName;
}

@end
