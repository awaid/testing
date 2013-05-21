//
//  VSMAPPHomeScreenViewController.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/12/13.
//
//

#import "VSHomeScreenViewController.h"
#import "VSProjectTeamDescriptionCustomCell.h"
@interface VSHomeScreenViewController ()

@end

@implementation VSHomeScreenViewController
@synthesize projectTableView=projectTableView_;
@synthesize projectTextField=projectTextField_;
@synthesize valueStreamDescriptionTextView=valueStreamDescriptionTextView_;

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
    [self.projectTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.projectTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.valueStreamDescriptionTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.projectTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.projectTableView.separatorColor = [UIColor clearColor];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self registerKeyboardChangeNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [valueStreamDescriptionTextView_ release];
    [projectTableView_ release];
    [projectTextField_ release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    VSProjectTeamDescriptionCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VSProjectTeamDescriptionCustomCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate=self;
        [cell registerKeyboardChangeNotifications];
    }
    
    // Configure the cell.
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    return cell;
}
#pragma mark - Custom Methods
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(self.valueStreamDescriptionTextView.isFirstResponder)
    [UIView animateWithDuration:0.25 animations:^{self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-350, self.view.frame.size.width, self.view.frame.size.height);}];

    if(self.projectTableView.isFirstResponder)
    {
        NSLog(@"here in table View");
    }

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
 
    if(self.valueStreamDescriptionTextView.isFirstResponder)
    [UIView animateWithDuration:0.25 animations:^{self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+350, self.view.frame.size.width, self.view.frame.size.height);}];
    
}
-(void)keyboardShownFromTextViewInTable
{
    [UIView animateWithDuration:0.25 animations:^{self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-80, self.view.frame.size.width, self.view.frame.size.height);}];
}

-(void)keyboardHideFromTextViewInTable
{
    [UIView animateWithDuration:0.25 animations:^{self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.frame.size.height);}];
}
@end
