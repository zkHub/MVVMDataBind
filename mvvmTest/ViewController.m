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
#import "VueObserver.h"
#import "VueButton.h"
#import "VueLabel.h"
#import "VueTextField.h"

@interface ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) VueTextField *textField;
@property (strong, nonatomic) VueLabel *label;
@property (nonatomic, strong) VueButton *button;

@property (nonatomic, strong) ViewModel *vm;
@property (nonatomic, strong) VueObserver *vueObserver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewModel *vm = [ViewModel new];
    self.vm = vm;
    
    VueTextField *textField = [[VueTextField alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    self.textField = textField;
    
    VueLabel *label = [[VueLabel alloc] initWithFrame:CGRectMake(200, 100, 100, 40)];
    label.text = @"12";
    [self.view addSubview:label];
    self.label = label;
    
    VueButton *button = [VueButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"abc" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    button.frame = CGRectMake(50, 200, 100, 30);
    [button addTarget:self action:@selector(resetAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    self.button = button;
    
    self.vueObserver = VueObserver.bindConvert(self.label, @"text", ^(NSString * string) {
        NSLog(@"change--%@", string);
        return string;
    }).bindUI(self.textField, @"text", UIControlEventEditingChanged).bind(self.vm, @"num").bind(self.vm, @"title").bind(self.vm, @"progress");
    
}

- (void)resetAction:(id)sender {
    self.vm.title = @"abc";
    NSLog(@"num-%@, title-%@, progress=%@", @(self.vm.num), self.vm.title, @(self.vm.progress));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField endEditing:YES];
    NSLog(@"num-%@, title-%@, progress=%@", @(self.vm.num), self.vm.title, @(self.vm.progress));
    return YES;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
