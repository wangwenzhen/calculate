# calculate
swift_calculate
####最后呈现的UI

![CE93F82D-C3E4-4C2B-8251-F3BC1703D676.png](http://upload-images.jianshu.io/upload_images/1517349-f7473509ca03ce14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/200)
###mainStoryBoard布局
![A2CC459F-CCF1-41B2-B5F1-4ECFA0355244.png](http://upload-images.jianshu.io/upload_images/1517349-9a9937b559e66b47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/200)

```swift
  @IBOutlet weak var display: UILabel!
  @IBAction func appendDigit(sender: UIButton) {}
  @IBAction func operate(sender: UIButton) {}
  @IBAction func enter() {}
```
* display 
   * ` var display` 表示的是对一个变量的声明,`@IBOutlet` 意味着是 SB中 拖出的 引用，`:`表示继承的类别这是从SB（故事版的简称）中脱出的空间已经存在所以  `UILable!`中的`!`解包，表示这个实例对象是不能为nil的也就是不可optional。  `weak`是为了内存安全，不导致重复引用，这个Lb的创建是在SB而我们的控制器只是对他进行引用，所以你可以简单理解为 值传递 这里写出weak防止控件的引用计数器`+ 1`.

* appendDigit 
    * `@IBAction`,SB中发送的消息触发事件。 `appendDigit` ，0...9的Btn事件触发消息。`(sender: UIButton)` 触发事件的对象。 
   * operate 同理 ，`加减乘除发送的消息 `
   * enter。return键 的消息 。我们不关注发送的对象，只是关心事件的执行，省去`(  )`中的参数，SB拖线中`type`选中 None
 
```swift
var userIsInputNum = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsInputNum {
            display.text = display.text! + digit
        }else{
            display.text = digit
            print("display.text =  \(display.text!)")
            userIsInputNum = true
        }
    }
```
  `全局变量的声明`在swift中是要赋予初始值的，let 和var 区别，let是一种值传递，  `userIsInputNum ` 用户是否正在进行计算操作，如果是第一次操作Lb的text是点击Btn上的数字。如果是正在操作计算则是文本拼接. 例如：6 按击 2次，Lb中显示66. swift中文本的拼接直接写`+`就行了，OC中却使用`[NSString stringWithFormate...]`,方便吧！
   
```swift
   var openrandStack = Array<Double>()
   @IBAction func enter() {
        userIsInputNum = false
        openrandStack.append(displayValue)
        print("openrandStack = \(openrandStack)")
    }
    
    var displayValue : Double{
        get{
            return (NSNumberFormatter().numberFromString(display.text!)!.doubleValue)
        }
        set{
            display.text = "\(newValue)"
            userIsInputNum = false
        }
    }
```
* 我们现在应该把计算要的数字存入我们的栈，也就是Array。`var #变量名 = #类型<#存放中 遵循的类型> （）#赋予空间` ，每次return进入enter也就是用户的文本拼接结束，将之前Lb中拼接好的文本存入栈中。`displayValue `重写它的get 、set方法为的是将Lb的text转为Double类型符合规范。
`"\(newValue)" `拼接为字符串 同`  print("display.text =  \(display.text!)")`,newValue 是在执行set方法时，传入的值

###运算 ，我说下逻辑，用户可能在点击6 再去retrun，也可能是去点击 加减乘除的运算符，这个时候的效果都应该是存入栈，点击运算符只有当栈中的个数多于等于2 的时候才会执行。set的赋值在结束的一刻其实调用了get（希望大家明白）
```swift
@IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInputNum{
            enter()
        }
        switch operation{
            case "×" : performOperation{ $0 * $1 }
            case "÷" : performOperation{ $1 / $0 }
            case "−" : performOperation{ $1 - $0 }
            case "+" : performOperation{ $0 + $1 }
            case "√" : performOperation{ sqrt($0) }
            default  : break
        
        }
    }

    func performOperation(operation : (Double , Double) -> Double){
        if openrandStack.count >= 2{
            displayValue = operation(openrandStack.removeLast(),openrandStack.removeLast())
            print("displayValue =  \(displayValue)")
            enter()
        }
    
    
    }
   
    private func performOperation(operation : Double -> Double){
        if openrandStack.count >= 1{
            displayValue = operation(openrandStack.removeLast())
            enter()
        }

        
    }
```
`performOperation { $0 * $1 }` 同
```swift
performOperation({(po1 : Double , po2 : Double) -> Double in return po1 * pop })
```
因为swift编译的时候对变量名没有要求,而且`performOperation `中有函数指针的参数类型，没有声明的变量名用$0...$n表示，所以可以写成
```swift
performOperation({($0 * $1)})
```
而因为最后一个形参可以写在外部，并且无参`()`可以省略 `----->  performOperation { $0 * $1 }`
* 算数平方根的求取，利用重载 方法，通过形参的个数让编译器自行判断发送消息的对象。
    * swift 中，控制器 的父类是`UIViewController` 而它 的父类 `NSObject`相当于导入了OC。因为oc中 重载的时候会报同名错误。所以在switf中加上private 私有化 区别。

##### AutoLayout 
 
![2C877D15-30D8-4D38-B362-A9A716210726.png](http://upload-images.jianshu.io/upload_images/1517349-f88e92e7efee52dd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/200)

这是有规律的约束一起设置的方法。`注意`我除了按键其他的都是空白的按钮填充 ，使最后成为了5 * 4 的一个矩阵。然后选中所有的空间选中`红箭头`设置but 的 W 和 H，eaqul（相等）并且距离上（Lb），左右下（控制器 view边界）一个固定值。试试吧 小伙子


##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* QQ: 575385842@qq.com
