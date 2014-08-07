//
//  GraphCheckinPopup.m
//  InFlow
//
//  Created by Anton Domashnev on 22.02.13.
//
//

#import <objc/runtime.h>
#import "ADPopupView.h"

typedef enum {
    ptUpLeft,
    ptUpRight,
    ptDownLeft,
    ptDownRight
} EnumPopupType;

#define ALPHA_ANIMATION_DURATION .4f
#define POPUP_CORNER_RADIUS 6.

#define POPUP_MINIMUM_SIZE CGSizeMake(50, 46)
#define POPUP_MAXIMUM_SIZE CGSizeMake(200, 100)

#define POPUP_CONTENT_VIEW_MARGIN 2

#define POPUP_ARROW_EDGE_MARGIN 12
#define POPUP_ARROW_SIZE CGSizeMake(13, 18)



@interface ADPopupViewManager()
    @property (strong,nonatomic) NSMutableSet* popupContainer;
@end

@implementation ADPopupViewManager
@synthesize messageLabelTextColor;
@synthesize messageLabelFont;
@synthesize popupColor=_popupColor;
@synthesize borderWidth;
@synthesize popupArrowEdgeMargin;
@synthesize popupArrowSize;
@synthesize popupCornerRadius;
@synthesize hideOnTap;

+ (ADPopupViewManager *)sharedManager {
    static ADPopupViewManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ADPopupViewManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.popupContainer = [NSMutableSet set];
        self.messageLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f];
        self.messageLabelTextColor = [UIColor whiteColor];
        self.popupColor = [UIColor blackColor];
        self.borderWidth = POPUP_CONTENT_VIEW_MARGIN;
        self.popupCornerRadius = POPUP_CORNER_RADIUS;
        self.popupArrowSize = POPUP_ARROW_SIZE;
        self.popupArrowEdgeMargin = POPUP_ARROW_EDGE_MARGIN;
        self.hideOnTap = YES;
    }
    return self;
}

-(void)hideAll
{
    NSArray* list = [self.popupContainer allObjects];
    for (ADPopupView*item in list) {
        [item hide:YES];
    }
}
@end


/**
 *  ///////////////////////////////////////////////////////////////////////////////////
 */
@interface ADPopupView ()
{
    @private
    NSInteger __hideOnTapIndex;
    SEL bindControlTouched;
}
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) UIControl*bindedControl;
@property (nonatomic, assign) UIView *presenterView;
@property (nonatomic, unsafe_unretained) EnumPopupType type;
@property (nonatomic, unsafe_unretained) CGPoint presentationPoint;
@property (nonatomic, weak) id<ADPopupViewDelegate> delegate;
@end

@implementation ADPopupView

@synthesize messageLabelTextColor;
@synthesize messageLabelFont;
@synthesize message;
@synthesize popupColor=_popupColor;
@synthesize borderWidth=_borderWidth;
@synthesize popupArrowEdgeMargin=_popupArrowEdgeMargin;
@synthesize popupArrowSize=_popupArrowSize;
@synthesize popupCornerRadius=_popupCornerRadius;
@synthesize hideOnTap=_hideOnTap;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.frame = frame;
        [self setup];
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withContentView:(UIView *)contentView {

    if (self = [super initWithFrame:CGRectZero]) {

        self.delegate = theDelegate;
        self.presentationPoint = point;
        self.contentView = contentView;
        [self setup];
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withMessage:(NSString *)theMessage {

    if (self = [super initWithFrame:CGRectZero]) {

        self.message = theMessage;
        self.presentationPoint = point;
        self.delegate = theDelegate;
        [self setup];
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate{
    if (self = [super initWithFrame:CGRectZero]) {
        self.presentationPoint = point;
        self.delegate = theDelegate;
        [self setup];
    }
    return self;
}

- (id)initWithDelegate:(id<ADPopupViewDelegate>)theDelegate withPresenterView:(UIView*)view bindControl:(UIControl*)control
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.presentationPoint = control.center;
        self.delegate = theDelegate;
        self.presenterView = view;
        [self bindToControl:control];
        [self setup];
    }
    return self;
}

- (void)bindToControl:(UIControl*)control{
    if (control) {
        self.bindedControl = control;
        bindControlTouched =@selector(bindControlTouched:) ;
        [self.bindedControl addTarget:self action:bindControlTouched forControlEvents:UIControlEventTouchUpInside];
    }
}

-(IBAction)bindControlTouched:(id)sender
{
    [self showInView:self.presenterView animated:YES];
}

-(void)setup
{
        [[ADPopupViewManager sharedManager].popupContainer addObject:self];
    
        self.borderWidth = -1;
        self.popupCornerRadius = -1;
        self.popupArrowSize = CGSizeZero;
        self.popupArrowEdgeMargin = -1;
        __hideOnTapIndex = -1;
    
        self.messageLabelFont = [ADPopupViewManager sharedManager].messageLabelFont;
        self.messageLabelTextColor = [ADPopupViewManager sharedManager].messageLabelTextColor;
        self.type = ptDownRight;
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

-(CGFloat)borderWidth{
    return _borderWidth!=-1?_borderWidth:[ADPopupViewManager sharedManager].borderWidth;
}
-(CGFloat)popupArrowEdgeMargin{
    return _popupArrowEdgeMargin!=-1?_popupArrowEdgeMargin:[ADPopupViewManager sharedManager].popupArrowEdgeMargin;
}
-(CGFloat)popupCornerRadius{
    return _popupCornerRadius!=-1?_popupCornerRadius:[ADPopupViewManager sharedManager].popupCornerRadius;
}
-(CGSize)popupArrowSize{
 return (CGSizeEqualToSize(_popupArrowSize,CGSizeZero) ? [ADPopupViewManager sharedManager].popupArrowSize: _popupArrowSize);
}
-(BOOL)hideOnTap
{
    if (__hideOnTapIndex == -1) {
       return [ADPopupViewManager sharedManager].hideOnTap;
    }
    else
        return _hideOnTap;
}

-(void)setHideOnTap:(BOOL)value
{
    _hideOnTap = value;
    __hideOnTapIndex = 1;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.message !=nil) {
        [self redrawPopupWithMessage];
        return;
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(ADPopupViewMessageForPopup:)]) {
        self.message = [self.delegate ADPopupViewMessageForPopup:self];
    }
    
    
    if (self.message != nil)
    {
        [self redrawPopupWithMessage];
        return;
    }
    else if (self.contentView==nil && self.delegate && [self.delegate respondsToSelector:@selector(ADPopupViewContentViewForPopup:)]) {
           UIView*vv = [self.delegate ADPopupViewContentViewForPopup:self];
            if (vv!=nil) {
                self.contentView = vv;
                
            }
        }
    if (self.contentView != nil)
    {
        self.frame = [self popupFrameForContentView:self.contentView];
        [self addContentView:self.contentView];
        return;
    }
}

#pragma mark ContentView

- (void)addContentView:(UIView *)view {

    CGPoint contentViewCenter = CGPointMake(self.frame.size.width / 2, 0);
    switch (self.type) {
        case ptDownLeft:
        case ptDownRight:
            contentViewCenter.y = (self.frame.size.height - self.popupArrowSize.height) / 2;
            break;
        case ptUpLeft:
        case ptUpRight:
            contentViewCenter.y = (self.frame.size.height - self.popupArrowSize.height) / 2 + self.popupArrowSize.height;
            break;
        default:
            break;
    }

    view.center = contentViewCenter;
    view.layer.cornerRadius = self.popupCornerRadius/2;

    [self addSubview:view];
    self.opaque = YES;
}

#pragma mark Redraw

- (void)redrawPopupWithMessage {

    [self.messageLabel removeFromSuperview];

    self.messageLabel = [self contentViewForMessage:self.message];

    self.frame = [self popupFrameForContentView:self.messageLabel];

    [self addContentView:self.messageLabel];
}

#pragma mark MessageLabelFont

- (void)setMessageLabelFont:(UIFont *)_messageLabelFont {

    self->messageLabelFont = _messageLabelFont;

    [self redrawPopupWithMessage];
}

#pragma mark Message

- (void)setMessage:(NSString *)_message {

    self->message = _message;

    [self redrawPopupWithMessage];
}

#pragma mark MessageLabelTextColor

- (void)setMessageLabelTextColor:(UIColor *)_messageLabelTextColor {

    self->messageLabelTextColor = _messageLabelTextColor;

    self.messageLabel.textColor = _messageLabelTextColor;
}

#pragma mark - PopupColor

- (UIColor *)popupColor {
    if (!_popupColor) return [ADPopupViewManager sharedManager].popupColor;
    return _popupColor;
}

#pragma mark PopupFrame

- (CGSize)popupSizeForContentView:(UIView *)contentView {
    float height = POPUP_MINIMUM_SIZE.height;
    float newHeight = contentView.frame.size.height + self.popupArrowSize.height + self.borderWidth * 2;

    float width = POPUP_MINIMUM_SIZE.width;
    float newWidth = contentView.frame.size.width + self.borderWidth * 2;

    return CGSizeMake(MAX(width, newWidth), MAX(height, newHeight));
}

- (CGRect)popupFrameForContentView:(UIView *)contentView {

    CGRect newFrame = CGRectZero;
    newFrame.size = [self popupSizeForContentView:contentView];

    float originX = self.presentationPoint.x + self.popupArrowEdgeMargin + self.popupArrowSize.width - newFrame.size.width;
    if (originX < 0) {

        originX = self.presentationPoint.x - self.popupArrowEdgeMargin * 2 + self.popupArrowSize.width / 2;

        self.type = ptDownLeft;
    }

    float originY = self.presentationPoint.y - newFrame.size.height;
    if (originY < 0) {

        originY = self.presentationPoint.y;

        self.type = (self.type == ptDownLeft) ? ptUpLeft : ptUpRight;
    }

    newFrame.origin = CGPointMake(originX, originY);

    return newFrame;
}

#pragma mark CheckinInformationLabel

- (CGSize)sizeForMessage:(NSString *)_message {

    return [_message sizeWithFont:self.messageLabelFont constrainedToSize:POPUP_MAXIMUM_SIZE lineBreakMode:NSLineBreakByWordWrapping];
}

- (UILabel *)contentViewForMessage:(NSString *)_message {

    CGSize labelSize = [self sizeForMessage:_message];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];

    label.backgroundColor = [UIColor clearColor];
    label.text = _message;
    label.numberOfLines = 0;
    label.font = self.messageLabelFont;
    label.textColor = self.messageLabelTextColor;

    return label;
}

#pragma mark Animation

- (void)hide:(BOOL)animated {
    if (!self.superview) {
        return;
    }
    [UIView animateWithDuration:(animated) ? ALPHA_ANIMATION_DURATION : 0.f animations:^{
        self.alpha = 0.f;
    }                completion:^(BOOL finished) {

        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(ADPopupViewDidHide:)]) {
            
            [self.delegate ADPopupViewDidHide:self];
        }
    }];
//    [[ADPopupViewManager sharedManager].popupContainer removeObject:self];
}

-(IBAction)hideAction:(id)sender{
    [self hide:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {

    self.alpha = 0.f;

    [view addSubview:self];

    [UIView animateWithDuration:(animated) ? ALPHA_ANIMATION_DURATION : 0.f animations:^{

        self.alpha = 1.f;
    }];
}

#pragma mark Gesture

- (void)tap:(UITapGestureRecognizer *)recogniser {

    if ([self.delegate respondsToSelector:@selector(ADPopupViewDidTap:)]) {

        [self.delegate ADPopupViewDidTap:self];
    }
    
    if (self.hideOnTap) {
        [self hide:YES];
    }
}




#pragma mark Draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.popupColor set];

    switch (self.type) {
        case ptDownLeft: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];

            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width / 2, self.frame.size.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptDownRight: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];
            
            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width / 2, self.frame.size.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptUpLeft: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, POPUP_ARROW_SIZE.height, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN, POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width / 2, 0)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width, POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptUpRight: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, POPUP_ARROW_SIZE.height, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width, POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width / 2, 0)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN, POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        default:
            break;
    }
}

- (void)dealloc
{
    if (self.bindedControl) {
        [self.bindedControl removeTarget:self action:bindControlTouched forControlEvents:UIControlEventTouchUpInside];
    }
    
        [[ADPopupViewManager sharedManager].popupContainer removeObject:self];
    [self removeFromSuperview];
    self.contentView = nil;
    self.message = nil;
    self.messageLabel = nil;
}
@end
