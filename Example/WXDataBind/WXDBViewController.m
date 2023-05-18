//
//  WXDBViewController.m
//  WXDataBind
//
//  Created by 192938268@qq.com on 11/24/2021.
//  Copyright (c) 2021 192938268@qq.com. All rights reserved.
//

#import "WXDBViewController.h"
#import "WXDataBind.h"
#import "WXDBViewModel.h"
#import "WXDBButton.h"
#import "WXDBLabel.h"
#import "WXDBTextField.h"
#import "WXDBMemoryUtil.h"
#import <ReactiveObjC.h>

@interface WXDBViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) WXDBTextField *textField;
@property (strong, nonatomic) WXDBLabel *label;
@property (nonatomic, strong) WXDBButton *button;
@property (nonatomic, strong) WXDBViewModel *vm;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) WXDBObserver *dbObserver;
@end

@implementation WXDBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WXDBViewModel *vm = [WXDBViewModel new];
    self.vm = vm;
    
    WXDBTextField *textField = [[WXDBTextField alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    self.textField = textField;
    
    WXDBLabel *label = [[WXDBLabel alloc] initWithFrame:CGRectMake(200, 100, 100, 40)];
    label.text = @"12";
    [self.view addSubview:label];
    self.label = label;
    
    WXDBButton *button = [WXDBButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"abc" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    button.frame = CGRectMake(50, 200, 100, 30);
    [button addTarget:self action:@selector(resetAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    self.button = button;
    
//    WXDataBindUseKVO;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 300, 200, 200)];
    textView.text = @"abc";
    textView.delegate = self;
    [self.view addSubview:textView];
    
    WXDBBind(self.vm, num).db_bind(self.vm, progress).db_bind(self.vm, nsNum);
    
    
    __weak typeof(self) weakSelf = self;
    WXDBBind(self.vm, num).db_bindWithProcess(self.vm, title, ^(NSString * string){
        return YES;
    }, nil, nil).db_bindWithProcess(self.label, text, nil, ^(NSString * string) {
        NSLog(@"change--%@", string);
        return string;
    }, ^(NSString *string){
        __strong typeof(weakSelf) self = weakSelf;
        NSLog(@"after--%@/self.label.text:%@", string, self.label.text);
    });
    
    WXDBBind(self.vm, num).db_bindEvent(self.textField, text, UIControlEventEditingChanged).db_bindNotify(textView, text, UITextViewTextDidChangeNotification);
    
//    WXDBRemoveBind(self.vm, num);
//    WXDBRemoveAllBinds(self.vm);
    
    return;
    
//    RACChannelTo(self.label, text) = self.textField.rac_newTextChannel;
    
    WXDBButton *benchMarkButton = [WXDBButton buttonWithType:(UIButtonTypeCustom)];
    [benchMarkButton setTitle:@"benchMark" forState:(UIControlStateNormal)];
    [benchMarkButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    benchMarkButton.frame = CGRectMake(50, 300, 100, 30);
    [benchMarkButton addTarget:self action:@selector(benchMark) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:benchMarkButton];
    
    self.array = [NSMutableArray new];
//    NSInteger memory = [WXDBMemoryUtil useMemoryForApp];
//    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    self.dbObserver = WXDBBindEvent(self.textField, text, UIControlEventAllEditingEvents);
//    NSLog(@"observer-useTime %f ms", (CFAbsoluteTimeGetCurrent() - startTime)*1000.0);
//    NSLog(@"observer-useMemory %@M", @([WXDBMemoryUtil useMemoryForApp]-memory));
}

- (void)resetAction:(id)sender {
    self.vm.nsNum = [NSNumber numberWithFloat:1.234];
//    self.label.text = @"1.234";
    NSLog(@"num-%@, title-%@, progress-%@, nsNum-%@", @(self.vm.num), self.vm.title, @(self.vm.progress), self.vm.nsNum);
}

- (void)benchMark {
    NSInteger memory = [WXDBMemoryUtil useMemoryForApp];
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    for (int i=0; i<10000; i++) {
        @autoreleasepool {
            WXDBViewModel *vm = [WXDBViewModel new];
            [self.array addObject:vm];
//            RACChannelTo(vm, title) = self.textField.rac_newTextChannel;
//            self.dbObserver.db_bind(vm, title);
//            WXDBBindEvent(self.textField, text, UIControlEventAllEditingEvents).db_bind(vm, title);
        }
    }
    NSLog(@"useTime %f ms", (CFAbsoluteTimeGetCurrent() - startTime)*1000.0);
    NSLog(@"useMemory %@M", @([WXDBMemoryUtil useMemoryForApp]-memory));
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField endEditing:YES];
    NSLog(@"num-%@, title-%@, progress-%@, nsNum-%@", @(self.vm.num), self.vm.title, @(self.vm.progress), self.vm.nsNum);
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    textView.text = [NSString stringWithFormat:@"%@",textView.text];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
