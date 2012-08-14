//
//  Wallpaper.h
//  miniNL
//
//  Created by German Villegas on 6/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wallpaper : NSObject

@property (nonatomic) NSString *nombre;

@property (nonatomic) UIImage *thumbnail;

@property (nonatomic) NSString *imagenURL;

@property (nonatomic) NSString * thumbnailURL;


-(void) descargarImagen;

-(id) initWithNombre:(NSString *) nombre thumbnailImage:(UIImage *) thumbnail andImageURL:(NSString *) imagenURL;

-(id) initWithNombre:(NSString *) nombre thumbnailImageURL:(NSString *) thumbnailURL andImageURL:(NSString *) imagenURL;

@end
