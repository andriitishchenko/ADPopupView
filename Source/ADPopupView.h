//
//  GraphCheckinPopup.h
//  InFlow
//
//  Created by Anton Domashnev on 22.02.13.
//
//

#import <UIKit/UIKit.h>

@class ADPopupView;
@protocol ADPopupViewDelegate;
@protocol ADPopupViewInterface;


@interface ADPopupViewManager: NSObject<ADPopupViewInterface>
+ (ADPopupViewManager *)sharedManager;
@end

@interface ADPopupView : UIView<ADPopupViewInterface>

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withMessage:(NSString *)theMessage;
- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withContentView:(UIView *)contentView;
- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate;

- (void)hide:(BOOL)animated;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
/*
 self close action
 */
-(IBAction)hideAction:(id)sender;


/*
 Popup message
*/
@property (nonatomic, strong) NSString *message;
@end


//================================================
@protocol ADPopupViewInterface<NSObject>

/*
 Popup message font
 */
@property (nonatomic, strong) UIFont *messageLabelFont;

/*
 Popup message color
 */
@property (nonatomic, strong) UIColor *messageLabelTextColor;

/*
 Background color
 */
@property (nonatomic, strong) UIColor *popupColor;

/*
 Border width
 */
@property (nonatomic) CGFloat borderWidth;

/*
 Arrow size
 */
@property (nonatomic) CGSize popupArrowSize;

/*
 Arrow margin
 */
@property (nonatomic) CGFloat popupArrowEdgeMargin;

/*
 Corner radius
 */
@property (nonatomic) CGFloat popupCornerRadius;

@end


//================================================
@protocol ADPopupViewDelegate<NSObject>
@optional
- (void)ADPopupViewDidTap:(ADPopupView *)popup;
- (UIView *)ADPopupViewContentViewForPopup:(ADPopupView *)popup;
- (NSString *)ADPopupViewMessageForPopup:(ADPopupView *)popup;
@end