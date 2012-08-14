//
//  Ringtone.m
//  miniNL
//
//  Created by German Villegas on 6/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ringtone.h"

@implementation Ringtone

@synthesize nombre = _nombre;
@synthesize archivoURL = _archivoURL;

-(id)initWithNombre:(NSString *)nombre andArchivoURL:(NSString *)archivoURL{
    
    self = [self init];
    
    self.nombre = nombre;
    self.archivoURL = archivoURL;
    
    return self;
}


-(void)descargarRingtone{
    
    NSError *error;
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSData *ringtoneData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.archivoURL]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imgDir = [ docDir stringByAppendingPathComponent:@"/descargas/ringtones/" ];
    
    if( ![fm fileExistsAtPath:imgDir] ){
        [fm createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", imgDir, self.nombre];
    
    [ringtoneData writeToFile:filePath atomically:YES];
    
}

@end
