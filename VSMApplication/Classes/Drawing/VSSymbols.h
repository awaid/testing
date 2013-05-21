//
//  VSSymbols.h
//  VSMAPP
//
//  Created by Apple  on 21/03/2013.
//
//

#import <Foundation/Foundation.h>

@interface VSSymbols : UIImageView<UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSNumber *ID_;
    NSString *tagSymbol_;
    NSString *name_;
    NSNumber *x_;
    NSNumber *y_;
    NSNumber *width_;
    NSNumber *height_;
    CGFloat  lastScale_;
	CGFloat  lastRotation_;
	CGFloat  firstTouchLocationX_;
	CGFloat  firstTouchLocationY_;
    
    id sender_;
    BOOL isShowingSymbolDeleteAlert_;
    BOOL isFirstTouchOnSymbol_;
    CGPoint leftNewSymbolPositionPoint_;
    CGPoint topNewSymbolPositionPoint_;
    CGPoint bottomNewSymbolPositionPoint_;
    CGPoint rightNewSymbolPositionPoint_;
    NSMutableArray *outgoingArrows_;
    NSMutableArray *incomingArrows_;
    BOOL isDataBoxIndependant_;

    BOOL isRemoved_;
    BOOL shouldBeRemoved_;
    
    NSNumber *connectedToProcessSymbolID_;
    NSNumber *connectedFromProcessSymbolID_;
    NSString *imageColor_;
    NSString *genericName_;
    BOOL isRotating_;
    CGPoint m_locationBegan;
    float m_currentAngle;
    NSString *dataBoxImageColorFileName_;


}

@property (nonatomic,retain) NSNumber* connectedToProcessSymbolID;
@property (nonatomic,retain) NSNumber* connectedFromProcessSymbolID;
@property (nonatomic, retain) NSNumber *ID;
@property (nonatomic, readwrite) CGFloat lastScale;
@property (nonatomic, readwrite) CGFloat lastRotation;
@property (nonatomic, readwrite) CGFloat firstTouchLocationX;
@property (nonatomic, readwrite) CGFloat firstTouchLocationY;
@property (nonatomic, retain) NSString *tagSymbol;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *x;
@property (nonatomic, retain) NSNumber *y;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, readwrite) CGPoint leftNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint topNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint bottomNewSymbolPositionPoint;
@property (nonatomic, readwrite) CGPoint rightNewSymbolPositionPoint;
@property (nonatomic, retain) id sender;
@property (nonatomic,readwrite) BOOL isDataBoxIndependant;
@property (nonatomic,readwrite) BOOL isRemoved;
@property (nonatomic,readwrite) BOOL shouldBeRemoved;
@property (nonatomic,retain) NSString *genericName;
@property (nonatomic,readwrite) BOOL isRotating;
@property (nonatomic,retain) NSString *dataBoxImageColorFileName;




@property (nonatomic, readwrite) BOOL isShowingSymbolDeleteAlert;
@property (nonatomic, readwrite) BOOL isFirstTouchOnSymbol;
@property (nonatomic, retain) NSMutableArray *outgoingArrows;
@property (nonatomic, retain) NSMutableArray *incomingArrows;
@property (nonatomic, retain) NSString *imageColorFileName;

- (id) initWithName:(NSString*) name withTag:(NSString*)tag;
-(void) scaleSymbol: (id) sender;
-(void) moveSymbol:  (id) sender;
-(void) rotateSymbol:(id) sender;
-(void) longPress:(id) sender;
-(void) tapSymbol:(id) sender;
-(void) resizeSymbol:(id) sender;
-(void) settingInitialParameters:(NSString*)name andWithTag:(NSString*)tag;
-(void) removeCompleteSymbol;
-(void) saveSymbolState;

-(void) addGesturesMethods;

-(void) alertForWrongSymbolPosition;


-(NSMutableDictionary*) getAppStateDictionary:(NSMutableDictionary*) dict;

-(void) adjustViewsOnSymbolFirstDragAndDrop;

@end
