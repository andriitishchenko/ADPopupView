//
//  ViewController.m
//  ADPopupView
//
//  Created by Anton Domashnev on 26.02.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "ViewController.h"
#import "ADPopupView.h"

@interface ViewController ()<ADPopupViewDelegate>

@property (nonatomic, strong) ADPopupView *visiblePopup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ADPopupViewManager sharedManager].borderWidth = 2;
    
    ADPopupView*pv = [[ADPopupView alloc] initWithDelegate:self withPresenterView:self.view bindControl:self.buttonBinded ];

    pv.popupColor = [UIColor blueColor] ;
    pv.tag = 290;
    

//    [pv bindToControl:self.buttonBinded];
//    pv = nil;

}
- (IBAction)buttonBinded_click:(id)sender {
    NSLog(@"main binded click");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TestPopupContentView

+ (float)randFloatBetween:(float)low and:(float)high {

    float diff = high - low;
    return (((float)rand() / RAND_MAX) * diff) + low;
}

- (CGSize)randomContentViewSize {

    float minWidth = 50;
    float maxWidth = 200;

    float minHeight = 30;
    float maxHeight = 100;

    return CGSizeMake([ViewController randFloatBetween:minWidth and:maxWidth], [ViewController randFloatBetween:minHeight and:maxHeight]);
}


-(NSString*)ADPopupViewMessageForPopup:(ADPopupView *)popup
{
    NSLog(@"ADPopupViewMessageForPopup popup.tag = %ld",(long)popup.tag);
    if (popup.tag == 100) {
        return @"Unigue string for popup #100";
    }
    return nil;
}

- (UIView *)ADPopupViewContentViewForPopup:(ADPopupView *)popup{
    NSLog(@"ADPopupViewContentViewForPopup popup.tag = %ld",(long)popup.tag);
    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.size = [self randomContentViewSize];
    UIView *contentView = [[UIView alloc] initWithFrame:contentViewFrame];
    contentView.backgroundColor = [UIColor redColor];
    return contentView;
}

- (UIView *)contentView {

    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.size = [self randomContentViewSize];

    UIView *contentView = [[UIView alloc] initWithFrame:contentViewFrame];

    contentView.backgroundColor = [UIColor redColor];
    return contentView;
}

- (void)presentPopupAtPointWithContentViewAtPoint:(CGPoint)point {

    //[self.visiblePopup hide: YES];

//    if (arc4random_uniform(2)) {
//
//        self.visiblePopup = [[ADPopupView alloc] initAtPoint:point delegate:self withMessage:@"ADPopupView is very useful view to show some text or whatever UIView content"];
//        self.visiblePopup.popupColor = [UIColor darkGrayColor];
//
//        [self.visiblePopup showInView:self.view animated:YES];
//    }
//    else {
//
//        self.visiblePopup = [[ADPopupView alloc] initAtPoint:point delegate:self withContentView:[self contentView]];
    
    

//    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//
//    [self presentPopupAtPointWithContentViewAtPoint:touchPoint];
//}


//Constructor 1
- (IBAction)buttonTop_click:(id)sender {
    UIButton*btn = (UIButton*)sender;
    ADPopupView*pv = [[ADPopupView alloc] initAtPoint:btn.center delegate:self withMessage:@"ADPopupView is very useful view to show some text or whatever UIView content"];
    pv.popupColor = [UIColor darkGrayColor];
    [pv showInView:self.view animated:YES];
}

////Constructor 2
- (IBAction)buttonCenter_click:(id)sender {
    UIButton*btn = (UIButton*)sender;
    ADPopupView*pv = [[ADPopupView alloc] initAtPoint:btn.center delegate:self withContentView:[self contentView]];
    pv.hideOnTap = NO;
    [pv showInView:self.view animated:YES];
}

//Constructor 3 Custom view
- (IBAction)buttonBottom1_click:(id)sender {
    UIButton*btn = (UIButton*)sender;
    ADPopupView*pv = [[ADPopupView alloc] initAtPoint:btn.center delegate:self];
    pv.popupColor = [UIColor blueColor] ;
    pv.tag = 290;
    [pv showInView:self.view animated:YES];
}

//Constructor 4 Custom text
- (IBAction)buttonBottom2_click:(id)sender {
    UIButton*btn = (UIButton*)sender;
    ADPopupView*pv = [[ADPopupView alloc] initAtPoint:btn.center delegate:self];
    pv.tag = 100;
    [pv showInView:self.view animated:YES];
}

- (IBAction)buttonHideAll_click:(id)sender {
    [[ADPopupViewManager sharedManager] hideAll];
}


@end
