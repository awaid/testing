//
//  VSTimePickerPopUpViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/5/13.
//
//

#import "VSTimePickerPopUpViewController.h"

@interface VSTimePickerPopUpViewController ()

@end

@implementation VSTimePickerPopUpViewController
@synthesize pickerView=pickerView_;
@synthesize hoursArray=hoursArray_;
@synthesize secsArray=secsArray_;
@synthesize minsArray=minsArray_;
@synthesize delegate=delegate_;
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
    
    if(hoursArray_ == nil)
    hoursArray_ = [[NSMutableArray alloc] init];
    
    if(minsArray_ == nil)
    minsArray_ = [[NSMutableArray alloc] init];
    
    if(secsArray_ == nil)
    secsArray_ = [[NSMutableArray alloc] init];
    
    NSString *value;
    
    for(int i=0; i<61; i++)
    {
        value = [NSString stringWithFormat:@"%d", i];
        
        
        //Create array with 0-12 hours
        if (i < 13)
        {
            [hoursArray_ addObject:value];
        }
        
        //create arrays with 0-60 secs/mins
        [minsArray_ addObject:value];
        [secsArray_ addObject:value];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View Delegate Methods
//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    if (component==0)
    {
        return [self.hoursArray count];
    }
    else if (component==1)
    {
        return [self.minsArray count];
    }
    else
    {
        return [self.secsArray count];
    }
    
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component)
    {
        case 0:
            return [hoursArray_ objectAtIndex:row];
            break;
        case 1:
            return [minsArray_ objectAtIndex:row];
            break;
        case 2:
            return [secsArray_ objectAtIndex:row];
            break;
    }
    return nil;
}

-(IBAction)calculateTimeFromPicker
{
    
    NSString *hoursStr = [NSString stringWithFormat:@"%@",[self.hoursArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    
    NSString *minsStr = [NSString stringWithFormat:@"%@",[self.minsArray objectAtIndex:[self.pickerView selectedRowInComponent:1]]];
    
    NSString *secsStr = [NSString stringWithFormat:@"%@",[self.secsArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
    int hoursInt = [hoursStr intValue];
    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
    
    float interval = secsInt + (minsInt*60) + (hoursInt*3600);
    
    NSLog(@"hours: %d ... mins: %d .... sec: %d .... interval: %f", hoursInt, minsInt, secsInt, interval);
    
    //NSString *totalTimeStr = [NSString stringWithFormat:@"%f",interval];
    
    [delegate_ removeFromSuperView:self];
    
}
@end
