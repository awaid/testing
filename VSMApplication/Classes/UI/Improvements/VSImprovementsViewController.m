//
//  VSImprovementsViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/13/13.
//
//

#import "VSImprovementsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VSImprovementsViewController ()
{
    UIPopoverController *cellDetailTextPopover_;
    UIViewController *popOverController_;
    UITextView *popOverTextView_;
    UIAlertView *improvementsalertView_;
    UITextView *alertTextView_;
    NSMutableArray *tableViewData_;
}
@property (nonatomic, retain) UIPopoverController *cellDetailTextPopover;
@property (nonatomic, retain) UIViewController *popOverController;
@property (nonatomic, retain) UITextView *popOverTextView;
@property (nonatomic, retain) UIAlertView *improvementsalertView;
@property (nonatomic, retain) UITextView *alertTextView;
@property (nonatomic, retain) NSMutableArray *tableViewData;
@end

@implementation VSImprovementsViewController
@synthesize improvmentsTableView=improvmentsTableView_;
@synthesize cellDetailTextPopover=cellDetailTextPopover_;
@synthesize popOverController=popOverController_;
@synthesize popOverTextView=popOverTextView_;
@synthesize improvementsalertView=improvementsalertView_;
@synthesize alertTextView=alertTextView_;
@synthesize tableViewData=tableViewData_;

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
    //just added for testing purpose,since we have no data for table right now
    if(tableViewData_ == nil)
        tableViewData_=[[NSMutableArray alloc] init];
    [tableViewData_ addObject:@"Test text"];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [improvmentsTableView_ release];
    [cellDetailTextPopover_ release];
    [popOverTextView_ release];
    [popOverController_ release];
    [improvementsalertView_ release];
    [alertTextView_ release];
    
    [super dealloc];
}

#pragma mark - Button Methods
//The following functions adds Row to the table on pressing the Add Button
- (IBAction)addRowToTable:(id)sender {

  
    //displaying the alert View
    if(improvementsalertView_ == nil)
    improvementsalertView_ = [[UIAlertView alloc]initWithTitle:@"Add Improvements Step" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];


 
    //Adding a text input to the aler view
    [improvementsalertView_ setAlertViewStyle:UIAlertViewStylePlainTextInput];

    //Showing and the alert View
    [improvementsalertView_ show];


}

#pragma mark - Alert View Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        
        //Adding the String to the Table Data Array
        [tableViewData_ addObject:username.text];
        [improvmentsTableView_ reloadData];
    }
}

#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableViewData_ count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewStylePlain reuseIdentifier:CellIdentifier] autorelease] ;
    }
    
  
    [[cell textLabel] setText:[tableViewData_ objectAtIndex:indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(popOverController_ == nil)
        popOverController_=[[UIViewController alloc] init];
        
    if(cellDetailTextPopover_ == Nil)
        cellDetailTextPopover_=[[UIPopoverController alloc] initWithContentViewController:popOverController_];
    
    if(popOverTextView_ == nil)
        popOverTextView_=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200,100)];
    
    //setting the size of the Pop-up view
    [self.cellDetailTextPopover setPopoverContentSize:CGSizeMake(200, 100)];
    
    //so that the text cannot be edited in the pop-over's Text View
    [popOverTextView_ setEditable:NO];
    [popOverController_.view addSubview:popOverTextView_];
    
    //setting the text of pop-over's text view from the selected cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    popOverTextView_.text=cell.textLabel.text;
    
    //displaying the Pop Over
    [self.cellDetailTextPopover presentPopoverFromRect:cell.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    //deseleting the selected row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
