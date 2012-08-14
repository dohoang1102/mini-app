//
//  Ringtone.h
//  miniNL
//
//  Created by German Villegas on 6/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Ringtone : NSObject

@property (nonatomic) NSString *nombre;

@property (nonatomic) NSString *archivoURL;


-(id)initWithNombre:(NSString *) nombre andArchivoURL: (NSString *) archivoURL;

-(void)descargarRingtone;

@end
