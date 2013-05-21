//
//  VSProjectTeamDescriptionCustomCell.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 3/18/13.
//
//

#import <UIKit/UIKit.h>
//Define the protocol for the delegate
@protocol VSProjectTeamDescriptionCustomCell
-(void)keyboardShownFromTextViewInTable;
-(void)keyboardHideFromTextViewInTable;
@end

@interface VSProjectTeamDescriptionCustomCell : UITableViewCell <UITextFieldDelegate>
{
    UITextField *teamMemberName_;
    UITextField *teamMemberFunction_;
    id <VSProjectTeamDescriptionCustomCell> delegate_;
}
@property (retain, nonatomic) IBOutlet UITextField *teamMemberName;
@property (retain, nonatomic) IBOutlet UITextField *teamMemberFunction;
@property (nonatomic, assign) id  <VSProjectTeamDescriptionCustomCell> delegate;

-(void)registerKeyboardChangeNotifications;
@end
