//
//  UIAlertView+Additions.h
//
//  Created by Wess Cope on 6/1/11.
//  Copyright 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock)(void);

@interface UIAlertView (Additions)
@property (nonatomic, retain) NSMutableDictionary *buttonsAndBlocks;
@property (nonatomic, retain) id<UIAlertViewDelegate> flDelegate;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;
- (void)cancelButtonWithTitle:(NSString *)title block:(UIAlertViewBlock)block;
- (void)addButtonWithTitle:(NSString *)title block:(UIAlertViewBlock)block;

@end
