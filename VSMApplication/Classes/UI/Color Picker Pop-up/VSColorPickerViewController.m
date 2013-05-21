//
//  VSColorPickerViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/30/13.
//
//

#import "VSColorPickerViewController.h"
#import "VSUIManager.h"
@interface VSColorPickerViewController ()

@end

@implementation VSColorPickerViewController

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

#pragma mark - Color Button Methods
//Dark Blue
- (IBAction)button1:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:1];
}
//Green
- (IBAction)button2:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:2];

}
//Light Blue
- (IBAction)button3:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:3];

}
//Light Blue-a
- (IBAction)button4:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:4];

}
//Light Green
- (IBAction)button5:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:5];

}
//Light orange
- (IBAction)button6:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:6];

}
//Light Purple
- (IBAction)button7:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:7];

}
//Light Yello
- (IBAction)button8:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:8];

}
- (IBAction)button9:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:9];

}
- (IBAction)button10:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:10];

}
- (IBAction)button11:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:11];

}
- (IBAction)button12:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:12];

}
- (IBAction)button13:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:13];

}
- (IBAction)button14:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:14];

}
- (IBAction)button15:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:15];

}
- (IBAction)button16:(id)sender {
    [[VSUIManager sharedUIManager] closeColorPickerPopOverWithIndex:16];

}

@end
