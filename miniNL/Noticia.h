//
//  Noticia.h
//  Mini Colombia
//
//  Created by Juan José Villegas on 26/07/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Noticia : NSManagedObject

@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSString * fecha;
@property (nonatomic, retain) NSString * pagina;
@property (nonatomic, retain) NSString * resumen;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * paginaURL;

@end
