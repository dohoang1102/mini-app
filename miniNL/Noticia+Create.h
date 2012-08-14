//
//  Noticia+Create.h
//  Mini Colombia
//
//  Created by German Villegas on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Noticia.h"

@interface Noticia (Create)

+(void)setTimestamp:(NSString *) timestamp;

+(NSString *)getTimestamp;

+(Noticia *)noticiaWithInfo:(NSDictionary *) noticiaInfo 
     inManagedObjectContext:(NSManagedObjectContext *)context 
                saveContext:(BOOL) save;

+(Noticia *)updateNoticiaWithInfo:(NSDictionary *) noticiaInfo 
     inManagedObjectContext:(NSManagedObjectContext *)context;

-(UIImage *) thumbnailImage;

@end
