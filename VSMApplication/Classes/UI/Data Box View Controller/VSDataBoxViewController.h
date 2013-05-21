//
//  VSDataBoxViewController.h
//  VSMAPP
//
//  Created by Shuja Ahmed on 4/1/13.
//
//

#import <UIKit/UIKit.h>
#import "VSDataBoxCustomCell.h"
#import "VSDataRowViewController.h"
@class VSProcessSymbol;
@interface VSDataBoxViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,VSDataBoxViewDelegate,UIScrollViewDelegate>
{
    UITableView *tableView_;
    UIScrollView *scrollView_;
    UIView *viewForRows_;
    NSMutableArray *incomingArrows_;
    NSMutableArray *outgoingArrows_;
    BOOL isFristTouchSymbol_;
    NSNumber *ID_;
    NSString *tagSymbol_;
    UIButton *addButton_;
    NSString* dataBoxImageColorName_;
}
@property (retain, nonatomic) IBOutlet UIView *viewForRows;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *incomingArrows;
@property (retain, nonatomic) NSMutableArray *outgoingArrows;
@property (nonatomic, readwrite) CGPoint leftNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint topNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint bottomNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint rightNewSymbolPositionPoint;
@property (nonatomic, readwrite) BOOL isFristTouchSymbol;
@property (nonatomic, retain) NSNumber *ID;
@property (nonatomic, retain) NSString *tagSymbol;
@property (nonatomic, retain) NSString* dataBoxImageColorName;
-(void)addMoveAndScaleGestures;

-(NSMutableArray*) getDataboxArray;
-(void) populateDataBoxes:(NSMutableArray*) arrayDataBoxes;
- (void)saveDataBox;
-(void)setColorOfDataBox;
-(void)setColorOnDataBox:(VSProcessSymbol*)processSymbol;
@end
