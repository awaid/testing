// FILE MANAGER CONSTANTS

#define kLocalAppStateFileName @"appState"
#define kLocalMetaDataFileName @"metadata"
#define kLocalNonAutoTemplate @"template_non"
#define kLocalAutoTemplate @"template_auto"

#define kMaterialKey @"mat"
#define kProcessKey @"ps"
#define kCustomKey @"ck"
#define kExtendedKey @"ext"
#define kInfoKey @"info"
#define kGeneralKey @"gen"
#define kTimeLine @"timeLine"
#define kColorFileName @"colorFinalName"
#define kCustomImage @"customImage"

#define kType @"type"

#define kNVeHeadSecs @"kNVeHeadSecs"
#define kNVHeadMin @"kNVHeadMin"
#define kNVHeadHours @"kNVHeadHours"
#define kVHeadSecs @"kVHeadSecs"
#define kVHeadMins @"kVHeadMins"
#define kVHeadHours @"kVHeadHours"
#define kFrame @"kFrame"
#define kTailSecs @"kTailSecs"
#define kTailMins @"kTailMins"
#define kTailHours @"kTailHours"
#define kNVMinAdded @"kNVMinAdded"
#define kNVSecsAdded @"kNVSecsAdded"
#define kNVHoursAdded @"kNVHoursAdded"
#define kVMinAdded @"kVMinAdded"
#define kVSecsAdded @"kVSecsAdded"
#define kVHoursAdded @"kVHoursAdded"

#define kAppStateKey @"VSMAPP"

#define kIsAutoProject @"isAutomation"
#define kIsSupplierAdded @"isSupplierAdded"
#define kIsCustomerAdded @"isCustomerAdded"
#define kIsProductionControlAdded @"isProductionControlAdded"
#define kIsTimeLineHeadAdded @"isTimeLineHeadAdded"
#define kIsProductionControlAdded @"isProductionControlAdded"
#define kIsCustomer @"customer"
#define kIsSupplier @"supplier"
#define kIsFirstProduction @"firstprod"

#define kProcessBoxReferenceForCustomer @"PCR"
#define kProcessBoxReferenceForSupplier @"PSR"

#define kSupplierSymRef @"SSR"
#define kCustomerSymRef @"CSR"
#define kDataBoxImageColorFileName @"dataBoxColor"


#define kIsTemplate @"isTemplate"
#define kLastTag @"lastTag"
#define kSymbols @"symbols"

#define kName @"name"
#define kSymbolTag @"symbolTag"
#define kTailPresentBool @"isTailPresent"
#define kDataBox @"db"

#define kTextField1 @"t1"
#define kTextField2 @"t2"
#define kIncomingArrows @"in"
#define kOutgoingArrows @"out"
#define kTimeLineLabelHours @"hoursLabelText"
#define kTimeLineLabelSecs @"secsLabelText"
#define kTimeLineLabelMins @"minsLabelText"
#define kisNonValueBool @"nonValueBool"
#define kisValueBool @"valueBool"

#define kDataBoxDataLabel @"dl"
#define kDataBoxSecsLabel @"sl"
#define kDataBoxHrsLabel @"hl"
#define kDataBoxMinLabel @"ml"
#define kDataBoxNoField @"nl"

#define kTagArrow @"tagArrow"
#define kTagMaterialArrow @"tagMatArrow"

#define kWidthOfProcessSymbol 100
#define kHeightOfProcessSymbol 100
#define kOffsetProcessInitialSymbolPositionY 100

#define kIsProcessSymbolSelected     @"isProcessSymbolSelected"
#define kIsMaterialSymbolSelected    @"isMaterialSymbolSelected"
#define kIsInformationSymbolSelected @"isInformationSymbolSelected"
#define kIsGeneralSymbolSelected     @"isGeneralSymbolSelected"
#define kIsExtendedSymbolSelected    @"isExtendedSymbolSelected"

#define kSymbolAnimationInterval     0.5
#define kSubMenuSymbolHeight         400
#define kSymbolContainerlHeight      120
#define kOffsetSymbolsViewOriginY    45
#define kOffsetSymbolsViewOriginX    -9
#define kOffsetHeadersButtonOriginX  9
#define kOffsetSymbolsViewFrameWidth 240

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)







#define DataManager [VSDataManager sharedDataManager]