//
//  VSUtilities.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"
typedef void(^SaveImageCompletion)(NSError* error);


@interface VSUtilities : NSObject

+(void)resizeSubViewsInSuperView:(UIView*)superView;
+(void)fadeOutDetailView:(UIView*)detailView;

+(NSNumber*) createAndGetSymbolTag;
+(void) getSymbolTag;
+(UIView*)addGreyBackgroundViewToWindow;
+(void)removeGreyTransparentViewFromWindow;
+(void)addAndAnimateGreyBackground:(UIView*)greyBackground withView:(UIView*)view;
+(BOOL) checkFileInDirectory:(NSString *)path removeYesOrNo: (BOOL)isRemove;
+(NSString*) getContentsOfFile:(NSString*)fileName;
+(CGFloat)pointPairDegrees:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint;
+(NSNumber*)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2;
+(CGPoint)centerCoordinateBetweenPoint:(CGPoint)point1 andPoint2:(CGPoint)point2;
+(NSNumber *)findingShortestDistanceBetween:(NSArray*)arrayWithFoursPoints;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(NSMutableDictionary *)deepMutableCopyDictionary:(NSDictionary *)dictObject;
+(NSMutableData*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
+(void)createVSMAppAlbum:(ALAssetsLibrary*)library;
+(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withAssetsLibrary:(ALAssetsLibrary*)library;
+(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withAssetsLibrary:(ALAssetsLibrary*)library;
+ (UIImage *) imageWithView:(DetailViewController *)view;
+(BOOL) isProjectNameValid:(NSString*) projectName;
+(NSString*)saveUIImage:(UIImage*)image;
+(UIImage*)getImageForString:(NSString*)string;
+(NSString*) removeSpacesFromProjectNameIfExists:(NSString*)projectName;
+(NSString*) removeDashesFromProjectNameIfExists:(NSString*)projectName;
+(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str;

@end
