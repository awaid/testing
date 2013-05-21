//
//  VSExistingProjectViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/25/13.
//
//

#import "VSExistingProjectViewController.h"
#import "VSDataManager.h"
#import "VSMapPopulationManager.h"
#import "VSProjectDataModel.h"
#import "VSMAPPAppDelegate.h"

@interface VSExistingProjectViewController ()
{
    NSMutableArray *arrayProjectNames_;
}

@property(nonatomic, retain) NSMutableArray *arrayProjectNames;
@end

@implementation VSExistingProjectViewController
@synthesize delegate=delegate_;
@synthesize arrayProjectNames = arrayProjectNames_;
@synthesize tableView=tableView_;

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

-(void) viewWillAppear:(BOOL)animated
{
    self.arrayProjectNames = [DataManager getProjectNamesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Button Methods
- (IBAction)editButtonPressed:(id)sender {
    
    if(!self.tableView.editing)
    {
        [self.tableView setEditing:YES animated:YES];
    }
    
    else
    {
        [self.tableView setEditing:NO];
        
    }
}

- (IBAction)crossButtonPressed:(id)sender {
    [delegate_ closeExistingProjectsButton];
}
- (IBAction)newProjectButtonPressed:(id)sender {
    [delegate_ closeExistingProjectsAndOpenNewProject];
}

#pragma mark -
#pragma mark Table view data source-
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath{
    NSString *mover = [self.arrayProjectNames objectAtIndex:[fromIndexPath row]];
    [self.arrayProjectNames removeObjectAtIndex:[fromIndexPath row]];
    [self.arrayProjectNames insertObject:mover atIndex:[toIndexPath row]];
    
}
-(BOOL)tableView: (UITableView *)tableView canMoveRowAtIndexPath: (NSIndexPath *)indexPath {
return YES;
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if([[VSDataManager sharedDataManager] deleteProjectWithName:[self.arrayProjectNames objectAtIndex:[indexPath row]]] ==  YES)
        {
    
        
            [self.arrayProjectNames removeObjectAtIndex:[indexPath row]];

        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        //If the project being deleted is already opened
//        if([[DataManager getCurrentProjectName] isEqualToString:[self.arrayProjectNames objectAtIndex:[indexPath row]]])
//        {
//            //VSMAPPAppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
//            //appDelegate.detailViewController.detailItem=nil;
//            //appDelegate.detailViewController.scrollView=nil;
//
//        }

            //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{

    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    float count;
    switch (section) {
        case 0:
            count = [self.arrayProjectNames count];
            return count;
            break;

        default:
            return 0;
            break;
            
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return self.containerViewForSymbolTableview.frame.size.width;
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:normal reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [VSUtilities removeDashesFromProjectNameIfExists:[self.arrayProjectNames objectAtIndex:indexPath.row]];
    

    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    
    return cell;
}



#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.arrayProjectNames objectAtIndex:indexPath.row];
    
    [self.view removeFromSuperview];
    
    [[VSMapPopulationManager sharedPopulationManager] openProjectWithName:name];
    
    
    
    
}

- (void)dealloc
{
    self.arrayProjectNames = nil;
    [tableView_ release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
