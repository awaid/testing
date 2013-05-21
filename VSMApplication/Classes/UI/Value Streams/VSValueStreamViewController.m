//
//  VSValueStreamViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/13/13.
//
//

#import "VSValueStreamViewController.h"

@interface VSValueStreamViewController ()

@end

@implementation VSValueStreamViewController
@synthesize drawingPadView=drawingPadView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)dealloc {
    [drawingPadView_ release];
    [super dealloc];
}
@end
