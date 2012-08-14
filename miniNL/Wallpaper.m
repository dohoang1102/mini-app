//
//  Wallpaper.m
//  miniNL
//
//  Created by German Villegas on 6/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Wallpaper.h"

@implementation Wallpaper

@synthesize nombre = _nombre;
@synthesize thumbnail = _thumbnail;
@synthesize imagenURL = _imagenURL;
@synthesize thumbnailURL = _thumbnailURL;

-(id) initWithNombre:(NSString *)nombre thumbnailImage:(UIImage *)thumbnail andImageURL:(NSString *)imagenURL{
    
    self = [self init];
    
    self.nombre = nombre;
    self.thumbnail = thumbnail;
    self.imagenURL = imagenURL;

    return self;
}

-(id) initWithNombre:(NSString *)nombre thumbnailImageURL:(NSString *)thumbnailURL andImageURL:(NSString *)imagenURL{
    
    self = [self init];
    
    self.nombre = nombre;
    self.thumbnailURL = thumbnailURL;
    self.imagenURL = imagenURL;
    
    return self;
}

-(void) descargarImagen{
    NSError *error;
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imagenURL]]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgDir = [ docDir stringByAppendingPathComponent:@"/descargas/wallpapers/" ];
    
    if( ![fm fileExistsAtPath:imgDir] ){
        [fm createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpeg", imgDir, self.nombre];
    
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
    [data writeToFile:filePath atomically:YES];
    
}

@end
