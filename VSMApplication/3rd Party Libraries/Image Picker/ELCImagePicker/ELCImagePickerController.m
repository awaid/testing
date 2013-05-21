//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"

@implementation ELCImagePickerController

@synthesize delegate;

-(void)cancelImagePicker {
	if([delegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

-(void)selectedAssets:(NSArray*)_assets {

	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	//for(ALAsset *asset in _assets) {

    if([_assets count] > 0)
	{	NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[[_assets objectAtIndex:0] valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[[[_assets objectAtIndex:0] defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
		[workingDictionary setObject:[[[_assets objectAtIndex:0] valueForProperty:ALAssetPropertyURLs] valueForKey:[[[[_assets objectAtIndex:0] valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
		
		[returnArray addObject:workingDictionary];
		
		[workingDictionary release];	
	//}
	}
    [self popToRootViewControllerAnimated:NO];
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
    
	if([delegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[delegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {    
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    NSLog(@"deallocing ELCImagePickerController");
    [super dealloc];
}

@end
