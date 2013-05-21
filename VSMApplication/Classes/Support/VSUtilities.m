//
//  VSUtilities.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/13/13.
//
//


#import "VSUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "Toast+UIView.h"
#import "Base64.h"
#define ALBUM_NAME @"VSM-Drawings"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

@implementation VSUtilities


//The following function resizes subview in Detail view controller when the side panel hides or display onto the screen.
+(void)resizeSubViewsInSuperView:(UIView *)superView
{
    for(UIView *view in [superView subviews])
    {
        if(view.tag == 1 || view.tag == 2 )
        {
            [UIView animateWithDuration:0.25 animations:^{view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, superView.frame.size.width, superView.frame.size.height);}];
        }
    }

}

//Following gives the Fade-out effect to the Detail View onto the right side of the view.
+(void)fadeOutDetailView:(UIView *)detailView
{
    [UIView animateWithDuration:0.5
                     animations:^{detailView.alpha = 0.0;}
                     completion:^(BOOL finished){ [detailView release]; }];
}

#pragma mark Symbol Tag Calculation

+(NSNumber*) createAndGetSymbolTag
{
    NSMutableArray *symbolTags;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"symbolTags"] == nil)
    {
        symbolTags = [[NSMutableArray alloc] init];
        [symbolTags addObject:[NSNumber numberWithInt:0]];
        [[NSUserDefaults standardUserDefaults] setObject:symbolTags forKey:@"symbolTags"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [symbolTags release];
        
        return 0;
    }
    
    else
    {
        symbolTags = [[NSUserDefaults standardUserDefaults] objectForKey:@"symbolTags"];
        NSNumber *tag = [symbolTags lastObject];
        
        long long longTag = [tag longLongValue];
        longTag = longTag + 1;

        
        NSMutableArray *mutableArraySymbolTags = [NSMutableArray arrayWithArray:symbolTags];
        
        [mutableArraySymbolTags addObject:[NSNumber numberWithLongLong:longTag]];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArraySymbolTags forKey:@"symbolTags"];
        
        return [NSNumber numberWithLongLong:longTag];

    }
    
        
    
}

+(void) getSymbolTag
{
    
}

//the following methods add animation procedure through which View is added to the Main Window
+(void)addAndAnimateGreyBackground:(UIView*)greyBackground withView:(UIView*)view;
{
    //Rotating the Project View for Main Window
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    view.transform= CGAffineTransformRotate(rotationTransform,DEGREES_TO_RADIANS(-90));
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]objectAtIndex:0];

    [UIView animateWithDuration:0.2
                     animations:^
     {
         
         view.center=CGPointMake(frontWindow.center.x, frontWindow.center.y);
         greyBackground.alpha=1.0;
         
     }
     
                     completion:^(BOOL finished)
     {
         greyBackground.alpha=0.5;
         view.alpha=1.0;
     }];
}

//following method adds a Grtey Transparent Background View to the Window
+(UIView*)addGreyBackgroundViewToWindow
{
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows]
                             objectAtIndex:0];
    
      UIView* greyTransparentView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, frontWindow.frame.size.width, frontWindow.frame.size.height)] autorelease];
    
    greyTransparentView.backgroundColor=[UIColor grayColor];
    greyTransparentView.alpha=0.0;
    //tag added so that it can be removed later
    greyTransparentView.tag=10;
    [frontWindow addSubview:greyTransparentView];
    
    return greyTransparentView;
}
//Following methods removed the Grey Transparent View from the Window
+(void)removeGreyTransparentViewFromWindow
{
    for(UIView *view in [[[[UIApplication sharedApplication] windows] lastObject] subviews])
    {
        if(view.tag == 10)
        {
            [view removeFromSuperview];
            break;
        }
    }
    
}



+(BOOL) checkFileInDirectory:(NSString *)path removeYesOrNo: (BOOL)isRemove  {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
	BOOL success =[fileManager fileExistsAtPath:path];
	
	if (isRemove ==YES) {
		[fileManager removeItemAtPath:path error:nil];
        return YES;
	}
	else
		return success;
	
}

+(NSString*) getContentsOfFile:(NSString*)fileName {
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	fileName = [documentsDir stringByAppendingPathComponent:fileName] ;
    NSString *fileState = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    return fileState;
}
//following functions finds the angle between starting and given ending point
+(CGFloat)pointPairDegrees:(CGPoint)firstPoint endingPoint:(CGPoint)secondPoint
{
    float dx = firstPoint.x - secondPoint.x;
    float dy = firstPoint.y - secondPoint.y;
    float angle = atan2(dy, dx);
    return angle;
}
+(NSNumber*)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    
    return [NSNumber numberWithFloat:roundf(distance)];
}

+(CGPoint)centerCoordinateBetweenPoint:(CGPoint)point1 andPoint2:(CGPoint)point2
{
    float xCenter=(point1.x+point2.x)/2;
    float yCenter=(point1.y+point2.y)/2;
    
    return CGPointMake(xCenter, yCenter);
}

//following function returns the shortest amongts 4 given values
+(NSNumber *)findingShortestDistanceBetween:(NSArray*)arrayWithFoursPoints
{
    int minValue=[[arrayWithFoursPoints objectAtIndex:0] integerValue];
    int arrayCount=[arrayWithFoursPoints count];
    for(int i=1;i<arrayCount;i++)
    {
        if(minValue > [[arrayWithFoursPoints objectAtIndex:i] integerValue])
        {
            minValue=[[arrayWithFoursPoints objectAtIndex:i] integerValue];
        }
    }
    
    return [NSNumber numberWithFloat:minValue];
}

//Scaling Image based on the width
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

+(NSMutableDictionary *)deepMutableCopyDictionary:(NSDictionary *)dictObject
{
    // Create Dictionary Mutbale Dictionary From Dictinoary
    NSMutableDictionary* mainDictionary = [NSMutableDictionary dictionaryWithDictionary:dictObject];
    NSArray* allKeys = [mainDictionary allKeys];
    for(int i = 0; i < allKeys.count; i++)
    {
        id object = [dictObject objectForKey:[allKeys objectAtIndex:i]];
        // if object is of Dictionary Type
        if( [object isKindOfClass:[NSDictionary class ]] )
        {
            NSMutableDictionary* muatbleDictionary =   [self deepMutableCopyDictionary:object];
            [mainDictionary setObject:muatbleDictionary forKey:[allKeys objectAtIndex:i ]];
        }
        // if object if of Array Type
        else  if ([object isKindOfClass:[NSArray class ]])
        {
            NSMutableArray* mutableArray = [self deepMutableArray:object];
            [mainDictionary setObject:mutableArray forKey:[allKeys objectAtIndex:i]];
        }
        
        
    }
    return mainDictionary;
}

+(NSMutableArray*)deepMutableArray:(NSArray *)arrayObjects
{
    // Create Mutable Array From Array
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:arrayObjects];
    for (int i = 0 ; i < arrayObjects.count; i++) {
        id arrayObj = [arrayObjects objectAtIndex:i];
        // if object is of Dictionary Type
        if([arrayObj isKindOfClass:[NSDictionary class]])
        {
            // Call the DeepMutableCopy Method For Dictionary Type Object
            NSMutableDictionary* mutableDictionary =  [self deepMutableCopyDictionary:arrayObj];
            [mutableArray replaceObjectAtIndex:i withObject:mutableDictionary];
        }
        // if object if of Array Type
        else if ([arrayObj isKindOfClass:[NSArray class]])
        {
            NSMutableArray* subMutbaleArrayObject = [self deepMutableArray:arrayObj];
            [mutableArray replaceObjectAtIndex:i withObject:subMutbaleArrayObject];
            
        }
    }
    return mutableArray;
}

//The following function saves the given UIView into a PDF File
+(NSMutableData*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    /*
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    */
    // instructs the mutable data object to write its context to a file on disk
    //[pdfData writeToFile:documentDirectoryFilename atomically:YES];
    //NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return pdfData;
}

//The following method saves the Drawing pad as a UIImage into iOS Gallery
#pragma mark - Save Image Methods
+(void)createVSMAppAlbum:(ALAssetsLibrary*)library
{
    [library addAssetsGroupAlbumWithName:ALBUM_NAME
                                  resultBlock:^(ALAssetsGroup *group) {
                                      NSLog(@"added album:%@", ALBUM_NAME);
                                  }
                                 failureBlock:^(NSError *error) {
                                     NSLog(@"error adding album");
                                 }];
}

+(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withAssetsLibrary:(ALAssetsLibrary*)library
{
    //write the image data to the assets library (camera roll)
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                               completionBlock:^(NSURL* assetURL, NSError* error) {
                                   
                                   //error handling
                                   if (error!=nil) {
                                       completionBlock(error);
                                       return;
                                   }
                                   
                                   //add the asset to the custom photo album
                                   [VSUtilities addAssetURL: assetURL
                                             toAlbum:albumName
                                 withCompletionBlock:completionBlock withAssetsLibrary:library];
                                   
                               }];
    
}

+(NSString*)saveUIImage:(UIImage*)image
{

    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageString =[imageData base64EncodedString];
    return imageString;
}

+(UIImage*)getImageForString:(NSString*)string
{

    NSData *imageData=[string base64DecodedData];
    UIImage *image=[[[UIImage alloc] initWithData:imageData] autorelease];
    return image;
}
+(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock withAssetsLibrary:(ALAssetsLibrary*)library
{
    __block BOOL albumWasFound = NO;
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    
    //search all photo albums in the library
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    
                                    //compare the names of the albums
if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                                        
                                        //target album is found
                                        albumWasFound = YES;
                                        
                                        //get a hold of the photo's asset instance
    [library assetForURL: assetURL
                                                      resultBlock:^(ALAsset *asset) {
                                                          
                                                          //add photo to the target album
                                                          [group addAsset: asset];
                                            [appDelegate.detailViewController.view makeToast:@"Diagram has been saved!"];
                                                          
                                                          //run the completion block
                                                          // [self.navigationController popToRootViewControllerAnimated:YES];//completionBlock(nil);
                                                          
                                                      } failureBlock: completionBlock];
                                        
                                        //album was found, bail out of the method
                                        return;
                                    }
                                    
                                    if (group==nil && albumWasFound==NO) {
                                        //photo albums are over, target album does not exist, thus create it
                                        
                                        __weak ALAssetsLibrary* weakSelf = library;
                                        //[self createITAGitAlbum];
                                        //create new assets album
                                        [library addAssetsGroupAlbumWithName:albumName
                                                                      resultBlock:^(ALAssetsGroup *group) {
                                                                          
                                                                          //get the photo's instance
                                                                          [weakSelf assetForURL: assetURL
                                                                                    resultBlock:^(ALAsset *asset) {
                                                                                        
                                                                                        //add photo to the newly created album
                                                                                        [group addAsset: asset];
                                            [appDelegate.detailViewController.view makeToast:@"Diagram has been saved!"];

                                                                                        //call the completion block
                                                                                        // [self.view hideToastActivity];
                                                                                        // [self.navigationController popToRootViewControllerAnimated:YES];//completionBlock(nil);
                                                                                        
                                                                                    } failureBlock: completionBlock];
                                                                          
                                                                      } failureBlock: completionBlock];
                                        
                                        //should be the last iteration anyway, but just in case
                                        return;
                                    }
                                    
                                } failureBlock: completionBlock];
    
}

+ (UIImage *) imageWithView:(DetailViewController *)view
{
    UIView *tmpView=(UIView*)view.detailItem;
    UIGraphicsBeginImageContext(CGSizeMake(tmpView.frame.size.width,view.view.frame.size.height-45));
    
    [tmpView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    return viewImage;
}

+(NSString*) removeSpacesFromProjectNameIfExists:(NSString*)projectName
{
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    projectName = [[projectName componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @"-"];
    return projectName;
     
}

+(NSString*) removeDashesFromProjectNameIfExists:(NSString*)projectName
{
    NSCharacterSet *removeCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    projectName = [[projectName componentsSeparatedByCharactersInSet: removeCharSet] componentsJoinedByString: @" "];
    return projectName;
    
}

+(BOOL) isProjectNameValid:(NSString*) projectName
{
    projectName = [[self class] removeSpacesFromProjectNameIfExists:projectName];
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-"];
    
    s = [s invertedSet];
    
    NSRange r = [projectName rangeOfCharacterFromSet:s];
    
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    
    else
    {

        return YES;
    }
   
}

+(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}
@end
