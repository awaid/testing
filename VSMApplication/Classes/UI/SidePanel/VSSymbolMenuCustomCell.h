//
//  VSSymbolMenuCustomCell.h
//  VSMAPP
//
//  Created by Apple  on 15/03/2013.
//
//

#import <UIKit/UIKit.h>
@class VSSymbols;
#import "OBDragDrop.h"
@interface VSSymbolMenuCustomCell : UITableViewCell<OBOvumSource, OBDropZone>
{
    UIButton *buttonLeftSymbol_;
    UIButton *buttonRightSymbol_;
    VSSymbols *symbols_;
}

@property (retain, nonatomic) VSSymbols *symbols;
@property (retain, nonatomic) IBOutlet UIButton *buttonLeftSymbol;
@property (retain, nonatomic) IBOutlet UIButton *buttonRightSymbol;
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightLabel;

-(void) setCellSymbolsWithFirstSymbol:(NSDictionary*) symbol1 andSecondSymbol:(NSDictionary*) symbol2;

-(void) setGestureMethodsForButtons;

@end
