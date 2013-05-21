//
//  VSDataPickerPopUpViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import "VSDataPickerPopUpViewController.h"
#import "VSDataPickerPopUpViewController.h"
#define PICKER_MIN 0
#define PICKER_MAX 10

@interface VSDataPickerPopUpViewController ()
{
}
@end

@implementation VSDataPickerPopUpViewController
@synthesize dataPicker=dataPicker_;
@synthesize delegate=delegate_;
@synthesize stringArray=stringArray_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(stringArray_ == nil)
            stringArray_=[[NSMutableArray alloc] initWithObjects:@"CT: Cycle Time",@"C/O: Change Over Time",@"LT: Lead Time",@"Effective Machine Cycle Time",@"Scrap Rate",@"Defect Rate",@"Uptime",@"Time Available",@"Shifts",@"Operators",@"Batch Size",@"Others", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dataPicker_ release];
    [stringArray_ release];
    [super dealloc];
}
#pragma mark - Data Picker Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [stringArray_ count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", [stringArray_ objectAtIndex:(row+PICKER_MIN)]];
}

#pragma mark - Button Methods
- (IBAction)selectTextButtonPressed:(id)sender {
    
    [self.delegate removeFromSuperView:self];
}

@end
