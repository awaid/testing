//
//  VSProjectTeamDescriptionCustomCell.m
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/18/13.
//
//

#import "VSProjectTeamDescriptionCustomCell.h"

@implementation VSProjectTeamDescriptionCustomCell
@synthesize delegate=delegate_;
@synthesize teamMemberFunction=teamMemberFunction_;
@synthesize teamMemberName=teamMemberName_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self registerKeyboardChangeNotifications];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [teamMemberName_ release];
    [teamMemberFunction_ release];
    [super dealloc];
}
#pragma mark -
#pragma mark - Delegate Methods
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if(self.teamMemberFunction.isFirstResponder || self.teamMemberName.isFirstResponder)
//        [self.delegate keyboardShownFromTextViewInTable];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(self.teamMemberFunction.isFirstResponder || self.teamMemberName.isFirstResponder)
//        [self.delegate keyboardHideFromTextViewInTable];
//}

#pragma mark - 
#pragma mark - custom methods
-(void)registerKeyboardChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{

    if(self.teamMemberFunction.isFirstResponder || self.teamMemberName.isFirstResponder)
    [self.delegate keyboardShownFromTextViewInTable];
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(self.teamMemberFunction.isFirstResponder || self.teamMemberName.isFirstResponder)
    [self.delegate keyboardHideFromTextViewInTable];
}
@end
