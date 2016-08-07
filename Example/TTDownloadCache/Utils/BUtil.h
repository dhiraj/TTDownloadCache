//
//  BasicUtilities.h
//  picTrove
//
//  Created by Dhiraj Gupta on 26/08/14.
//  Copyright (c) 2014 Traversient inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUtil : NSObject

#define GAP_4X 32.0f
#define GAP_3X 24.0f
#define GAP_2X 16.0f
#define GAP 8.0f
#define GAP_HALF 4.0f
#define GAP_QUARTER 2.0f

#define COLOR_TEST_RED [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.3f]
#define COLOR_TEST_GREEN [UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.3f]
#define COLOR_TEST_BLUE [UIColor colorWithRed:0 green:0 blue:1.0f alpha:0.3f]

#define COLOR_DIVIDER [UIColor colorWithHex:@"454545"]

+(BOOL) isValidString:(nullable id)valueObject;
+ (BOOL) isValidArray:(nullable NSArray *)arr;
+(BOOL) isValidDictionary:(nullable NSDictionary *)dict;
+ ( BOOL ) isValidNumber:(nullable  id ) object;
+ (BOOL) isValidArray: (nullable  id ) object allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDictionary:(nullable  id ) object  allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDataObject:(nullable id)object;
+ (CGFloat) targetHeightToFitSize:(CGSize)size inWidth:(CGFloat)targetWidth;
+ (CGFloat) targetWidthToFitSize:(CGSize)size inHeight:(CGFloat)targetHeight;
+ (CGFloat) halfOf:(CGFloat)half;
+ (CGFloat) oneThirdOf:(CGFloat)full;
+ (CGFloat) twoThirdsOf:(CGFloat)full;
+ (CGFloat) oneFourthOf:(CGFloat)full;
+ (CGFloat) oneFifthOf:(CGFloat)full;
+(nonnull NSString *) appVersionNumber;
+(nonnull NSString *) deviceModelString;
+(nonnull NSString *) getBuildNumber;
+ (nonnull UINavigationController *)navigationControllerWithRoot:(nonnull UIViewController *)controller;
+ (void) showOkAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (void) presentSheetWithItems:(nonnull NSArray <NSString *> *)items fromViewController:(nonnull UIViewController *)fromVC title:(nullable NSString *) title message:(nullable NSString *)message handler:(void (^ __nullable)(NSString * _Nonnull chosen))handler;
+ (nonnull UILabel *) uiLabelWithText:(nullable NSString *)string addToView:(nullable UIView *)parent;
+ (nonnull UITextField *) uiTextFieldWithPlaceholder:(nullable NSString *)string addToView:(nullable UIView *)parent withDelegate:(nullable id<UITextFieldDelegate>)delegate changeHandler:(nullable SEL)handler onTarget:(nullable id)target;
+ (void) applySelectableBackgroundTo:(nonnull UITextField *)txtf;
+ (nonnull UIImageView *) uiBGViewWithImageName:(nonnull NSString *)string addToView:(nullable UIView *)parent;
+ (nonnull UIButton *) uiButtonWithTitle:(nonnull NSString *)title addToView:(nullable UIView *)parent onClick:(nonnull SEL)selector target:(nonnull id)responder;
+ (nonnull UIImage *)imageWithColor:(nonnull UIColor *)color;
+ (void) makeBigTextField:(nonnull UITextField *)textfield;
+ (void) makeBigLabel:(nonnull UILabel *)label;
+ (BOOL) string:(nonnull NSString *)stringA isSameAs:(nonnull NSString *)stringB;
+ (BOOL) urlRequest:(nonnull NSURLRequest *)request1 hasSameURLAs:(nonnull NSURLRequest *)request2;
@end
