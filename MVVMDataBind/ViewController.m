//
//  ViewController.m
//  mvvmTest
//
//  Created by zk on 2021/9/2.
//

#import "ViewController.h"
#import "ViewModel.h"
#import "TestView.h"
#import "DataBind.h"
#import "WXDBObserver.h"
#import "WXDBButton.h"
#import "WXDBLabel.h"
#import "WXDBTextField.h"

@interface ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) WXDBTextField *textField;
@property (strong, nonatomic) WXDBLabel *label;
@property (nonatomic, strong) WXDBButton *button;

@property (nonatomic, strong) ViewModel *vm;
@property (nonatomic, strong) WXDBObserver *vueObserver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewModel *vm = [ViewModel new];
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
    
    self.vueObserver = WXDBObserver.bindConvert(self.label, @"text", ^(NSString * string) {
        NSLog(@"change--%@", string);
        return string;
    }).bindUI(self.textField, @"text", UIControlEventEditingChanged).bind(self.vm, @"num").bind(self.vm, @"title").bind(self.vm, @"progress").bind(self.vm, @"nsNum");
    
}

- (void)resetAction:(id)sender {
    self.vm.nsNum = [NSNumber numberWithFloat:1.234];
    NSLog(@"num-%@, title-%@, progress-%@, nsNum-%@", @(self.vm.num), self.vm.title, @(self.vm.progress), self.vm.nsNum);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField endEditing:YES];
    NSLog(@"num-%@, title-%@, progress-%@, nsNum-%@", @(self.vm.num), self.vm.title, @(self.vm.progress), self.vm.nsNum);
    return YES;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
