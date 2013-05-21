//
//  VSMapPopulationManager.m
//  VSMAPP
//
//  Created by Apple  on 16/04/2013.
//
//

#import "VSMapPopulationManager.h"
#import "VSMapPopulation.h"
#import "VSDataManager.h"
@interface VSMapPopulationManager()
{
    VSMapPopulation *mapPopulation_;
    UITextField *textField_;
    NSDictionary* tempDict_;
    
}

@property(nonatomic, retain) VSMapPopulation *mapPopulation;
@property(nonatomic, retain) NSDictionary* tempDict;
@property(nonatomic, retain) UITextField *textField;
@property(nonatomic, retain) NSString *projectName;
@end
@implementation VSMapPopulationManager
@synthesize mapPopulation = mapPopulation_;
@synthesize textField=textField_;
@synthesize tempDict=tempDict_;

static VSMapPopulationManager *_populationManager_;

+ (VSMapPopulationManager *)sharedPopulationManager
{
    if(!_populationManager_)
    {
        _populationManager_ = [[VSMapPopulationManager alloc] init] ;
        
    }
    
    return _populationManager_;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        mapPopulation_ = [[VSMapPopulation alloc] init];
        tempDict_ = [[NSDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.mapPopulation = nil;
    [super dealloc];
}

-(void) openProjectWithName:(NSString*)name
{
    [self.mapPopulation openProjectWithName:name];
}
-(void)openProjectWithDictionary:(NSDictionary*)dictionary
{
    self.tempDict=dictionary;
    [self popAlertViewForProjectName];
}

-(VSSymbols*)getSymbolViewForTag:(NSString*)tag
{
    return [self.mapPopulation getSymbolViewWithTag:tag];
}

#pragma mark - Text View Delegate Methods

-(void)popAlertViewForProjectName
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enter Project Name" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    if(textField_ == nil)
    {
        textField_ = [[UITextField alloc] init];
    }
    
    [self.textField setBackgroundColor:[UIColor whiteColor]];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.frame = CGRectMake(15, 75, 255, 30);
    self.textField.font = [UIFont fontWithName:@"ArialMT" size:20];
    //textField.textAlignment = UITextAlignmentCenter;
    self.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [self.textField becomeFirstResponder];
    [alert addSubview:self.textField];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //
    self.projectName = self.textField.text;
    if(buttonIndex == 1)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
            
        if([DataManager isProjectNameExists:self.textField.text])
        {
            self.textField.text = @"";
            self.textField.placeholder = @"Project Name Exists";
            [self popAlertViewForProjectName];
        }
            
        else if([self.textField.text isEqualToString:@""])
        {
            self.textField.text = @"";
            self.textField.placeholder = @"Project Name Empty";
            [self popAlertViewForProjectName];
        }
            
        else if([VSUtilities isProjectNameValid:self.textField.text] == NO)
        {
             self.textField.text = @"";
             self.textField.placeholder = @"Invalid Name";
             [self popAlertViewForProjectName];
                    
        }
            
        else if ([[self.textField.text stringByTrimmingCharactersInSet: set] length] == 0)
        {
                self.textField.text = @"";
                self.textField.placeholder = @"Invalid Name";
                 [self popAlertViewForProjectName];
        }

        else
        {
        [DataManager setVSMDictionary:self.tempDict withName:self.projectName];
                   [self.mapPopulation openProjectWithName:self.projectName];
                   self.tempDict = nil;
            //self.projectName = nil;
                 }
            
        }
}

-(NSString*) getColorForCustomerArrow:(BOOL) isCustomer andForTag:(NSString*)tag
{
    return [self.mapPopulation getColorForCustomerArrow:isCustomer andForTag:tag];
}
@end
