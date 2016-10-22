//
//  CommonUIConstants.h
//  ooApp
//
//  Created by James Rochabrun on 7/31/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

// Convenience Macros
#define UIColorRGB(rgbValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0 \
blue:(255&rgbValue)/255.0 alpha:1.0]

#define UIColorRGBA(rgbValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0f \
blue:(255&rgbValue)/255.0f \
alpha:(rgbValue >> 24)/255.0f]

#define UIColorRGBOverlay(rgbValue, alphaValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0f \
blue:(255&rgbValue)/255.0f \
alpha:alphaValue]
#define IS_IPHONE4  ( [UIScreen  mainScreen].bounds.size.height <= 480)


static NSUInteger kColorOffBlack = 0xFF272727;
static const NSUInteger kColorElements1 = 0xFF272727;
static const NSUInteger kColorElements2 = 0xFFe0e0e0;
static const NSUInteger kColorElements3 = 0xff8D99AE;

static const NSUInteger kColorGrayLight = 0xFFB2B2B2;
static const NSUInteger kColorGrayMiddle = 0xFF53585F;
static const NSUInteger kColorWhite = 0xFFFFFFFF;
static const NSUInteger kColorBlack = 0xFF000000;
static const NSUInteger kColorClear = 0x00000000;
static const NSUInteger kColorNavyBlue = 0xFF000080;
static const NSUInteger kColorYellow = 0xFFF9FF00;
static const NSUInteger kColorMarkerFaded = 0x701874CD;
static const NSUInteger kColorConnectOverlayCell = 0xFF032E06;
static NSUInteger kColorOffWhite = 0xFFE5E5E5;
static const NSUInteger kColorOverlay10 = 0xE6000000;
static const NSUInteger kColorOverlay20 = 0xCC000000;
static const NSUInteger kColorOverlay25 = 0xC0000000;
static const NSUInteger kColorOverlay30 = 0xB3000000;
static const NSUInteger kColorOverlay35 = 0xA6000000;
static const NSUInteger kColorOverlay40 = 0x99000000;
static const NSUInteger kColorOverlay50 = 0x7F000000;
static const NSUInteger kColorYellowFlat = 0xf1c40f;
static const NSUInteger kColorRedFlat = 0xe74c3c;

// Geometry and metrics

static CGFloat kGeomHeightStatusBar = 20.0;
static CGFloat kGeomWidthBigButton = 210.0;
static CGFloat kGeomHeightBigbutton = 44.0;
static CGFloat kGeomBottomPadding = 100.0;
static CGFloat kGeomMarginSmall = 10.0;
static CGFloat kGeomMarginMedium = 20.0;
static CGFloat kGeomHeightToolBar = 70.0;
static CGFloat kGeomMarginBig = 40.0;
static CGFloat kGeomHeaderHeightInSection = 40.0;
static CGFloat kGeomWidthToolBarButton = 85.0;
static CGFloat kGeomTopViewHeight = 75.0;
static CGFloat kGeomDismmissButton = 44.0;
static CGFloat kGeomMarginDismissButton = 26.0;
static CGFloat kGeomHeightTextField = 35.0;
static CGFloat kGeomSpaceEdge = 4.0;
static CGFloat kGeomMinSpace = 1.0;
static CGFloat kGeomMinimunInterItemSpacing = 5.0;
static CGFloat kGeomSpaceCellPadding = 3.0;
static CGFloat kGeomContactButton = 45.0;
static CGFloat kGeomHeightTextView = 130.0;
static CGFloat kGeomHeightTableViewCell = 70.0;
static CGFloat kGeomHeightHeaderView = 50.0;
static CGFloat kGeomHeightLabelInCell = 20.0;
static CGFloat KVelocityOfAutomaticTransition = 2.25;



extern NSString *const kcontactNumber;
extern NSString *const kcontactEmail;
extern NSString *const kemailSubject;
extern NSString *const kcompanyDescription;
extern NSString *const khalfDayCategoryID;
extern NSString *const kfullDayCategoryID;
extern NSString *const knauticalOvernightCategoryId;
extern NSString *const kbedAndBoatCategoryID;

extern NSString *const kKeyBookingModeNoDate;
extern NSString *const kKeyBookingModeInventory;
extern NSString *const kKeyBookingModeDateEnquiry;
extern NSString *const kKeyPhonePrompt;



