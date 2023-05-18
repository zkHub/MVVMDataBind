# WXDataBind

[![CI Status](https://img.shields.io/travis/192938268@qq.com/WXDataBind.svg?style=flat)](https://travis-ci.org/192938268@qq.com/WXDataBind)
[![Version](https://img.shields.io/cocoapods/v/WXDataBind.svg?style=flat)](https://cocoapods.org/pods/WXDataBind)
[![License](https://img.shields.io/cocoapods/l/WXDataBind.svg?style=flat)](https://cocoapods.org/pods/WXDataBind)
[![Platform](https://img.shields.io/cocoapods/p/WXDataBind.svg?style=flat)](https://cocoapods.org/pods/WXDataBind)

WXDataBind是一个轻量便捷的可链式绑定多个对象属性的工具。是通过交换属性的set方法来实现监听属性变化，然后通知绑定关系下的其它属性值的改变。

## 安装引入

Podfile 中加入以下代码：

```ruby
  pod 'WXDataBind',:git => "git@git.100tal.com:tal_internal_pods/wxdatabind.git"
```

## 快速上手

首先引入头文件

```ruby
    #import <WXDataBind.h>
```

### 添加绑定

我们预置了几个宏可以方便的让几个对象属性绑定在一起，如：

```ruby
    __weak typeof(self) weakSelf = self;
    WXDBBind(self.vm, num).db_bind(self.vm, progress).db_bind(self.vm, nsNum);
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
```

`WXDBBind` 和 `db_bind` 只有`target`和`keyPath`简单的绑定方式。

`WXDBBindWithProcess`和`db_bindWithProcess`是增加了filter、convert、didchange三种回调，filter可以通过变化的值判断是否需要更新，convert可以自己增加对值的处理，didchange是在值变化之后的操作（这里直接修改对应的属性也会触发didchange，其它两个不会触发）。

`db_bindEvent` `db_bindEventWithProcess`是对`UIControl`的扩展，可以绑定`UIControlEvent`相关事件。

`db_bindNotify` `db_bindNotifyWithProcess`可以支持绑定`UITextView` `UITextField`的`text`变化时触发的系统通知。

### 移除绑定

```ruby
    WXDBRemoveBind(self.vm, num);
    WXDBRemoveAllBinds(self.vm);
```

## 注意事项

因为绑定时产生的`observer`和`watcher`都会存储在其对象中，所以要注意三种`block`的循环引用问题。

一个`target`的一个`keyPath`只能绑定一个绑定关系，即一个`observer`和一个`watcher`。

`WXDBBind`和`WXDBBindWithProcess`是类方法创建绑定，如果`target`的`keyPath`已存在绑定，会先使用已存在的绑定关系。

**现在只支持了属性为对象和基本数据类型的监听。**

iOS12及以上系统支持使用KVO模式，可以在使用之前调用`WXDataBindUseKVO;`或者`[WXDBObserver UseKVOBind];`

## 性能对比

对比了创建10000次两个数据双向绑定的使用时间和内存占用，结果如下：

KVO的数据是将交换set的方式替换成KVO监听得到的。

|   | time | memory |
| ---- | ---- | ---- |
| 初始化数据 | 3ms | 0M |
| WXDataBind | 212ms |  13.7M |
| KVO | 219ms | 19.1M |
| RAC | 6412ms | 318M |

## Author

zhangke14@tal.com

## License

WXDataBind is available under the MIT license. See the LICENSE file for more info.
