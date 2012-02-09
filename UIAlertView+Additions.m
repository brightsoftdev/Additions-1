//
//  UIAlertView+Additions.m
//
//  Created by Wess Cope on 6/1/11.
//  Copyright 2012. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+WCAlertView.h"

@implementation UIAlertView (Additions)
static char BB_KEY;
@dynamic buttonsAndBlocks;
static char FL_DELEGATE_KEY;
@dynamic flDelegate;

- (void)setButtonsAndBlocks:(NSMutableDictionary *)buttonsAndBlocks
{
    objc_setAssociatedObject(self, &BB_KEY, buttonsAndBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)buttonsAndBlocks
{
    return (NSMutableDictionary *)objc_getAssociatedObject(self, &BB_KEY);
}

- (void)setFlDelegate:(id<UIAlertViewDelegate>)flDelegate
{
    objc_setAssociatedObject(self, &FL_DELEGATE_KEY, flDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIAlertViewDelegate>)flDelegate
{
    return (id<UIAlertViewDelegate>)objc_getAssociatedObject(self, &FL_DELEGATE_KEY);
}

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [self.flDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    UIAlertViewBlock block = [[self buttonsAndBlocks] objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    block();
}

#pragma mark - Delegate Methods
- (void)alertViewCancel:(UIAlertView *)alertView
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(alertViewCancel:)])
        [self.flDelegate alertViewCancel:alertView];
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
        [self.flDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
        [self.flDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(willPresentAlertView:)])
        [self.flDelegate willPresentAlertView:alertView];
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if(self.flDelegate AND [self.flDelegate respondsToSelector:@selector(didPresentAlertView:)])
        [self.flDelegate didPresentAlertView:alertView];
}

#pragma mark - Public Methods
- (void)setupAdditions
{
    if([self buttonsAndBlocks] == NULL)
    {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        [self setButtonsAndBlocks:tmp];
    }

    if([self flDelegate] == NULL)
    {
        [self setFlDelegate:self.delegate];
        [self setDelegate:self];
    }
}

- (NSInteger)__addButtonWithTitle:(NSString *)title block:(UIAlertViewBlock)block
{
    [self setupAdditions];
    
    NSInteger idx = [self addButtonWithTitle:title];
    NSNumber *index = [NSNumber numberWithInteger:idx];
    [[self buttonsAndBlocks] setObject:block forKey:index];
    
    return idx;
}

- (void)cancelButtonWithTitle:(NSString *)title block:(UIAlertViewBlock)block
{
    self.cancelButtonIndex = [self __addButtonWithTitle:title block:block];
}

- (void)addButtonWithTitle:(NSString *)title block:(UIAlertViewBlock)block
{
    [self __addButtonWithTitle:title block:block];
}


@end
