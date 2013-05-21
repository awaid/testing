//
//  VSPopoverViewController.m
//  VSMAPP
//
//  Created by Apple  on 13/03/2013.
//
//

#import "VSPopoverViewController.h"
#import "VSDrawingManager.h"
#import "VSMAPPAppDelegate.h"
#import "DetailViewController.h"
#import "VSUtilities.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSAssetPicker.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "VSCustomImageSymbol.h"
#import "DetailViewController.h"
@interface VSPopoverViewController ()
{
    ALAssetsLibrary *library_;
    UIImagePickerController *pickerController_;
    UIPopoverController *popOver_;
    ELCImagePickerController *controller_;
    MFMailComposeViewController *mailView_;
}
@property (nonatomic,retain) ALAssetsLibrary *library;
@property (nonatomic,retain) UIImagePickerController *pickerController;
@property (nonatomic,retain) UIPopoverController *popOver;
@property (nonatomic,retain) ELCImagePickerController *controller;
@property (nonatomic,retain) MFMailComposeViewController *mailView;
@end

@implementation VSPopoverViewController
@synthesize library=library_;
@synthesize pickerController=pickerController_;
@synthesize popOver=popOver_;
@synthesize controller=controller_;
@synthesize mailView=mailView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(library_ == nil)
            library_=[[ALAssetsLibrary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(recieveNotification)
                                                     name:@"RemoveMailModalView"
                                                   object:nil];
    }
 
    return self;
}
-(void)recieveNotification
{
    [self.mailView dismissViewControllerAnimated:YES completion:nil];
    self.mailView=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [library_ release];
    [pickerController_ release];
    [mailView_ release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
#pragma mark - UIImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   // UIImage *myImage =[VSUtilities imageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] scaledToWidth:512];
    
    
    //Saving the taken Image into the Gallery
    [VSUtilities createVSMAppAlbum:self.library];
    [VSUtilities saveImage:[info objectForKey:UIImagePickerControllerOriginalImage] toAlbum:@"VSMApp" withCompletionBlock:nil withAssetsLibrary:self.library];
    
    VSCustomImageSymbol *symbol=[[VSDrawingManager sharedDrawingManager] createCustomImageSymbol:@"custom-image"];
    symbol.image=[VSUtilities imageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] scaledToWidth:symbol.frame.size.width];//[info objectForKey:UIImagePickerControllerOriginalImage];
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    symbol.center=CGPointMake(appDelegate.detailViewController.view.center.x, appDelegate.detailViewController.view.center.y);
    [appDelegate.detailViewController.detailItem addSubview:symbol];


    //Resetting the Side Panel to its previous state
    [appDelegate.splitViewController toggleMasterView:self];
    
    [self.pickerController.view removeFromSuperview];
    [symbol saveSymbolState];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.pickerController.view removeFromSuperview];
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate.splitViewController toggleMasterView:self];
    
}
#pragma mark - MSMail Delegate Method
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            /*
             Execute your code for email sent event here ...
             */
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Button methods
- (IBAction)takeImageFromCamera:(id)sender {
    
    self.pickerController=nil;
    self.pickerController = [[UIImagePickerController alloc] init];
    [self.pickerController setTitle:@"Take a photo."];
    [self.pickerController setDelegate:self];
    [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    self.pickerController.showsCameraControls = YES;
    
    
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    [appDelegate.splitViewController toggleMasterView:self];

    
    [appDelegate.detailViewController.view addSubview:self.pickerController.view];

}



- (IBAction)sendAsPDF:(id)sender {
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    NSData *data=[VSUtilities createPDFfromUIView:appDelegate.detailViewController.detailItem saveToDocumentsWithFileName:@"vsmap.pdf"];
    
    if(mailView_ == nil)
        mailView_ = [[MFMailComposeViewController alloc] init];
    [self.mailView setSubject:@"VSMApp Drawing"];
    [self.mailView addAttachmentData:data mimeType:@"application/pdf" fileName:@"vsmapp.pdf"];
    [self.mailView setToRecipients:[NSArray array]];
    [self.mailView setMessageBody:@"Check out this drawing!" isHTML:NO];
    [self.mailView setMailComposeDelegate:appDelegate.detailViewController];
    [appDelegate.detailViewController presentViewController:self.mailView animated:YES completion:nil];
    
}


- (IBAction)sendVSMButtonPressed:(id)sender {
    
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    NSString *projectString=[[VSDataManager sharedDataManager] getCurrentProjectDictionary];
    NSData *theData = [projectString dataUsingEncoding:[NSString defaultCStringEncoding]];

    if(mailView_ == nil)
     mailView_ = [[MFMailComposeViewController alloc] init];
    
    [self.mailView setSubject:@"VSMApp Drawing"];
    [self.mailView addAttachmentData:theData mimeType:@"application/vmsapp" fileName:@"file.vsmapp"];
    [self.mailView setToRecipients:[NSArray array]];
    [self.mailView setMessageBody:@"Check out this Drawing!  You'll need a copy of VSMApp to view this file, then tap and hold to open." isHTML:NO];
    [self.mailView setMailComposeDelegate:appDelegate.detailViewController];
    [appDelegate.detailViewController presentViewController:self.mailView animated:YES completion:nil];
}


- (IBAction)saveAsPDFButton:(id)sender {
    VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

    UIImage *image=[VSUtilities imageWithView:appDelegate.detailViewController];
    [VSUtilities createVSMAppAlbum:self.library];
    [VSUtilities saveImage:image toAlbum:@"VSMApp" withCompletionBlock:nil withAssetsLibrary:self.library];
    //[VSUtilities createPDFfromUIView:appDelegate.detailViewController.detailItem saveToDocumentsWithFileName:@"VMSApp.pdf"];

}
- (IBAction)loadImageFromGallery:(id)sender {
    NSLog(@"Image is not set");
  
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
	controller_ = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:self.controller];
	[self.controller setDelegate:self];
    [self presentViewController:self.controller animated:YES completion:nil];

    
    /*
    ELCImagePickerController *controller = [[ELCImagePickerController alloc] init];
    [controller setDelegate:self];
    [self presentViewController:controller animated:YES completion:nil];
    //[controller release];*/
    
}

- (void) didRotate:(NSNotification *)notification

{
    //Maintain the camera in Landscape orientation
    
}

#pragma mark - Picker Delegate Method
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    
    for(NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        VSCustomImageSymbol *symbol=[[VSDrawingManager sharedDrawingManager] createCustomImageSymbol:@"custom-image"];
        
        symbol.image=[VSUtilities imageWithImage:image scaledToWidth:symbol.frame.size.width];
        VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;

        symbol.center=CGPointMake(appDelegate.detailViewController.view.center.x, appDelegate.detailViewController.view.center.y);
        [appDelegate.detailViewController.detailItem addSubview:symbol];
        [symbol saveSymbolState];

        //[symbol release];
		
	}
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}
@end
