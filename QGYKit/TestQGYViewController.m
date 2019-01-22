//
//  TestQGYViewController.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/18.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "TestQGYViewController.h"

@interface TestQGYViewController ()

//copy 测试
@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, copy) NSString *copyedString;

@property (nonatomic, strong) NSMutableArray *someDataArr;  // 外界数组赋值给它，copy的原因 变成了不可变数组；
@end

@implementation TestQGYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /*
     
     copy 总结:
     
     字符串属性P（strong修饰）：if(接收可变字符串 或 不可变字符串) {
        内存地址不变；（强引用）, 属性P的类型 和 被传入的属性P1 类型相同； NSString 或 MutableString
     }
     
     字符串属性P（copy修饰）：if(接收可变字符串) {
        内存地址会更改；  （创建新的内存地址）； 且这个Copy属性P对象的类型始终是NSString；
     }else{
        接收不可变字符串，内存地址不变；
     }
     

     //copy 属性A被赋值的时候，当接收不可变的时候 效果和 strong 是一样的； 当接收可变的时候，会新开辟出内存 来存储值； 当可变值被中间商改变的时候， 不会影响属性A 的值；
     
     //自定义的类，要实现copy， 遵守NScoping协议，实现copywithzone方；
     
     //block 的copy用法； block 的代码是一个OC对象匿名结构体，默认在栈中； block处理时候 需要用copy 把它拷贝的堆中；
     //ARC 下，定义strong 也可以，系统自动转成copy了； MRC 下 必须用copy ;
     
     //Block 的循环引用： 比如在一个VC中，调用自己的block ，block 里面调用VC自己的方法， 这个时候用self 时候 就回出现引用循环问题；导致内存泄露；通过 __weakSelf 解决（弱引用）；
     
     //Block 里面修改外界中__block 作用是将变量 copy 到堆中处理；
     
     */
    
    NSLog(@"***************************************");
    NSMutableString *string = [NSMutableString stringWithFormat:@"aaa"];
//    NSString *string = @"abc";
    self.strongString = string;  //[string mutableCopy]; //copy 为拷贝一份不可变的字符串；（可变字符串copy 之后 变成了不可变;）   mutableCopy 为可变拷贝, 新对象；
    self.copyedString = string;
    
    if([self.copyedString isKindOfClass:[NSString class]]){
        NSLog(@"1");
    }else{
        NSLog(@"2");
    }
    
    //string = [NSMutableString stringWithFormat:@"aaa"];
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);  //strong 为 内存不变，指针变了；
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);  //copy 为 内存变了，指针变了；
    
   //打印1
    NSString *logStr = [NSString stringWithFormat:@"-----1-------origin string:%@\n,strong string:%@\n,copy string %@",string,_strongString,_copyedString];
    NSLog(logStr);
    
    
    [string appendString:@"bbb"];  //可变字符串改变的时候；

    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);
    
    //打印2
    NSString *logStr2 = [NSString stringWithFormat:@"-----2-------origin string:%@\n,strong string:%@\n,copy string %@",string,_strongString,_copyedString];
        NSLog(logStr2);
    
    
    
    /*****************数组**********************/
    
    /*
     
     总结:
     1、可变数组属性copy修饰时候，外界赋值给它，需copy  ，变成了不可变数组；
     2、可变数组属性strong修饰的时候， 传入可变集合需 mutableCopy ，才是可变数组； 如果copy ,则不可变数组 调用add方法继续崩溃；
     3、copy，assign ,retain 是在set 方法下实现的； 对象销毁的时候, assign 引用的对象不会自动设置nil 造成野指针；weak 可以自动设置nil,
     */
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[@"1",@"2"]];
    
//    NSArray *arr1 = [arr mutableCopy];
//    NSLog(@"-------------arr1:%@",arr1);
//    NSLog(@"arr: %p, %p", arr, &arr);
//     NSLog(@"arr1: %p, %p", arr1, &arr1);
    
    self.someDataArr = [arr mutableCopy]; //可变数组copy 给对象，实变为不可变；调用add方法 会崩溃；
    [self.someDataArr addObject:@"6"];  //someDataArr 为 不可变的了；会崩溃；
    NSLog(@"-------------someArr:%@",_someDataArr);
      NSLog(@"-------------Arr:%@",arr);
    
//     NSLog(@"arr: %p, %p", arr, &arr);
//     NSLog(@"someArr: %p, %p", _someDataArr, &_someDataArr);
    
}


-(void)blockDemoDay
{
     /*****************Block**********************/
    /*
     总结:
     1、blocks 在栈中创建；
     2、blocks 可被拷贝到堆中；
     3、blocks 私有他们自己从 栈中拷贝的变量和指针；
     4、栈中 可变的变量和指针 必须通过__block 关键字来声明；系统会将其拷贝到堆中，产生一个新的变量y来引用；
    
    1、 block 被持有者一直没有执行时，当持有者ViewController 或者其他 回收栈帧时候，Block会被销毁；
     如果block当栈帧回收后需要存活，则他们可被拷贝到堆中；
     
     2、如果在block块调用之前，对象被释放了，则其中块里面引用的变量也被回收了，会出现崩溃；
     
     //Block 经典循环引用:
     1、block 被self持有，块里执行self 相关的方法 会导致循环引用；  需通过__weak 关键字解决循环引用问题；
     self.completionHandler = ^{
     NSLog(@"%@", self);
     }
     2、如果在 Block 内需要多次 访问 self，则需要使用 strongSelf。
     
     */
}

-(void)cocopoadPrivateLib
{
 
    /*****************CocoaPod创建自己的私有库**********************/
    
    /*
     1、github 上创建自己的一个私有仓库， QGYKit；  git clone 仓库地址  到本地；
     2、创建.podspec 文件；  pod spec create QGYKit ; 之后 编辑 .podspec文件 信息；
     3、把项目文件等 放入， git add .；  git commit -m "提交信息"；  git push 到远程；
     4、分支 与 tag ; v0.0.1 版本，提交代码到远程； git branch -a 查看远程分支， git branch 查看本地分支； git push origin --delete 0.0.1 (删除远程分支)  ；  要掌握 分支 与 主干的切换；等git 操作；  git tag 查看tag ;  git tag -d v0.0.1 删除远程tag ;
     5、git push origin v0.0.1 （推送到远程仓库）
     6、pod repo remove QGYKit , 删除本地pod仓库 ； pod repo push QGYKit QGYKit.podspec 更新仓库；pod repo add QGYKit https://github.com/GaoYingQiu/QGYKit.git 添加仓库
     
     
     7、1）pod spec lint ZYRunTimeCoT.podspec --verbose； 验证.podspec 文件；
        2）pod lib lint --allow-warnings 验证pod 私有库是否通过验证； 验证通过则可以使用；

     
     扩展：
     // --use-libraries --allow-warnings
     pod trunk push ZYRunTimeCoT.podspec  发布到cocoapod 审核开源；
     
     错误提示：
     使用 Git 报错 error: src refspec master matches more than one.  有一个与当前分支重名的标签tag;需进行删除tag;
     
     注释：
     s.name：名称，pod search 搜索的关键词,注意这里一定要和.podspec的名称一样,否则报错
     s.version：版本号
     s.ios.deployment_target:支持的pod最低版本
     s.summary: 简介
     s.homepage:项目主页地址
     s.social_media_url:社交网址,这里我写的微博默认是百度,如果你写的是你自己的博客的话,你的podspec发布成功后会@你
     s.license:许可证
     s.author:作者
     s.source:项目的地址
     s.requires_arc: 是否支持ARC
     s.source_files:需要包含的源文件
     s.public_header_files:公开的头文件
     s.resources: 资源文件
     s.dependency：依赖库，不能依赖未发布的库，可以写多个依赖库 字符串逗号隔开；
     
     */
    
    
}


-(void)gitFlow
{
 //   https://www.cnblogs.com/myqianlan/p/4195994.html  git工作流；
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}、
*/

@end
