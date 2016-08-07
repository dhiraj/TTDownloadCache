//
//  BasicUtilities.m
//  picTrove
//
//  Created by Dhiraj Gupta on 26/08/14.
//  Copyright (c) 2014 Traversient inc. All rights reserved.
//

#import "BUtil.h"
#import "TranslatedStrings.h"
#include <sys/sysctl.h>

//#define USE_TEST_COLORS 1

@implementation BUtil
+ (BOOL) isValidArray: ( id ) object
{
    return [self.class isValidArray:object allowingZeroCount:NO];
}

+ (BOOL) isValidDictionary:( id ) object
{
    return [self.class isValidDictionary:object allowingZeroCount:NO];
}
+ (BOOL) isValidArray: ( id ) object allowingZeroCount:(BOOL)allowZeroCount
{
    if (object != nil && ![[NSNull null] isEqual:object])
    {
        if ([object isKindOfClass:[NSArray class]])
        {
            if (allowZeroCount) {
                return YES;
            }
            if ([object count] > 0)
            {
                return YES;
            }
        }
    }
    //    DLog(@"INVALID ARRAY: %@", arr);
    return NO;
}

+ (BOOL) isValidDictionary:( id ) object  allowingZeroCount:(BOOL)allowZeroCount
{
    if ( object != nil && ![[NSNull null] isEqual:object])
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            if (allowZeroCount) {
                return YES;
            }
            if ( [object count] > 0 )
            {
                return YES;
            }
        }
    }
    //    DLog(@"INVALID DICTIONARY: %@", dict);
    return NO;
}
+ (BOOL) isValidString: ( id ) valueObject
{
    if ( valueObject != nil && [NSNull null] != valueObject
        && [valueObject isKindOfClass:[NSString class]]
        && [valueObject length] > 0
        )
    {
        return YES;
    }
    //    DLog(@"INVALID STRING:%@", valueObject);
    return NO;
}

+ ( BOOL ) isValidNumber:( id ) object
{
    if ( object != nil &&
        [NSNull null] != object &&
        [object isKindOfClass:[NSNumber class]] )
    {
        return YES;
    }
    
    return NO;
}
+ (BOOL) isValidDataObject:(id)object{
    if (object != nil && [NSNull null] != object && [object isKindOfClass:[NSData class]]) {
        return [object length] > 0;
    }
    return NO;
}
+ (CGFloat) targetHeightToFitSize:(CGSize)size inWidth:(CGFloat)targetWidth{
    CGFloat imageScale = size.width / size.height;
    CGFloat thumbHeight = floorf(targetWidth / imageScale);
    //    DLog(@"ThumbHeight:%f, ThumbScale: %f, ImageScale: %f, Thumb:%@ Image:%@",thumbHeight,imageScale,(result.dimensions.width / result.dimensions.height),NSStringFromCGSize(result.thumbnailDimensions),NSStringFromCGSize(result.dimensions));
    return thumbHeight;
}
+ (CGFloat) targetWidthToFitSize:(CGSize)size inHeight:(CGFloat)targetHeight{
    CGFloat imageScale = size.width / size.height;
    CGFloat thumbWidth = floorf(targetHeight * imageScale);
    //    DLog(@"ThumbHeight:%f, ThumbScale: %f, ImageScale: %f, Thumb:%@ Image:%@",thumbHeight,imageScale,(result.dimensions.width / result.dimensions.height),NSStringFromCGSize(result.thumbnailDimensions),NSStringFromCGSize(result.dimensions));
    return thumbWidth;
}
+ (CGFloat) halfOf:(CGFloat)half{
    return floorf(half* 0.5f);
}
+ (CGFloat) oneThirdOf:(CGFloat)full{
    return floorf(full* 0.33333333f);
}
+ (CGFloat) twoThirdsOf:(CGFloat)full{
    return floorf(full* 0.66666666f);
}
+ (CGFloat) oneFourthOf:(CGFloat)full{
    return floorf(full* 0.25f);
}
+ (CGFloat) oneFifthOf:(CGFloat)full{
    return floorf(full* 0.20f);
}
+(NSString *) appVersionNumber {
    
    NSString * versionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ;
    return versionNumber ;
    
}
+(NSString *) deviceModelString{
    size_t size;
    char *model;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *hwString = @(model);
    free(model);
    return [NSString stringWithFormat:@"%@/%@",hwString,[[UIDevice currentDevice] systemVersion]];
}

+(NSString *) getBuildNumber {
    
    NSString * buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ;
    return buildVersion ;
}
+ (UINavigationController *)navigationControllerWithRoot:(UIViewController *)controller{
    return [[UINavigationController alloc] initWithRootViewController:controller];
}
+ (UILabel *) uiLabelWithText:(NSString *)string addToView:(UIView *)parent{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = string;
    label.textColor = [UIColor colorWithWhite:0.1 alpha:1.0f];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [parent addSubview:label];
#ifdef USE_TEST_COLORS
    int color = arc4random_uniform(3);
    switch (color) {
        case 0:
            label.backgroundColor = COLOR_TEST_RED;
            break;
        case 1:
            label.backgroundColor = COLOR_TEST_BLUE;
            break;
        case 2:
            label.backgroundColor = COLOR_TEST_GREEN;
            break;
            
        default:
            break;
    }
#endif
    return label;
}
+ (UITextField *) uiTextFieldWithPlaceholder:(NSString *)string addToView:(UIView *)parent withDelegate:(nullable id<UITextFieldDelegate>)delegate changeHandler:(SEL)handler onTarget:(id)target{
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.borderStyle = UITextBorderStyleNone;
    field.background = [[UIImage imageNamed:@"bg_bottom_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 0) resizingMode:UIImageResizingModeStretch];
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.placeholder = string;
    field.delegate = delegate;
    if (handler && target) {
        [field addTarget:target action:handler forControlEvents:UIControlEventEditingChanged];
    }
    [parent addSubview:field];
    return field;
}
+ (void) applySelectableBackgroundTo:(UITextField *)txtf{
    txtf.background = [[UIImage imageNamed:@"bg_selectable_bottom_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 29) resizingMode:UIImageResizingModeStretch];
}
+ (UIImageView *) uiBGViewWithImageName:(NSString *)string addToView:(UIView *)parent{
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:string]];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [parent addSubview:iv];
    return iv;
}
+ (void) showOkAlertWithTitle:(NSString *)title message:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:S_Okay otherButtonTitles:nil] show];
}
+ (void) presentSheetWithItems:(NSArray <NSString *> *)items fromViewController:(UIViewController *)fromVC title:(NSString *) title message:(NSString *)message handler:(void (^ __nullable)(NSString * chosen))handler{
    UIAlertController * sheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString * item in items) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            handler(item);
        }];
        [sheet addAction:action];
    }
    UIAlertAction * action = [UIAlertAction actionWithTitle:S_Cancel style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:action];
    [fromVC presentViewController:sheet animated:YES completion:nil];
}
+ (nonnull UIButton *) uiButtonWithTitle:(nonnull NSString *)title addToView:(nullable UIView *)parent onClick:(nonnull SEL)selector target:(nonnull id)responder{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:responder action:selector forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:button];
    return button;
}
+ (void) makeBigLabel:(nonnull UILabel *)label{
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:36.0f];
}
+ (void) makeBigTextField:(UITextField *)textfield{
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.font = [UIFont boldSystemFontOfSize:36.0f];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (BOOL) string:(NSString *)stringA isSameAs:(NSString *)stringB{
    return [stringA compare:stringB options:NSCaseInsensitiveSearch] == NSOrderedSame;
}
+ (BOOL) urlRequest:(NSURLRequest *)request1 hasSameURLAs:(NSURLRequest *)request2{
    return [request1.URL.absoluteString compare:request2.URL.absoluteString options:NSCaseInsensitiveSearch] == NSOrderedSame;
}
@end
