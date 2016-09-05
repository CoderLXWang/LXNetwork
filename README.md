# LXNetwork - 基于AF3.0封装的iOS网络请求库

原文地址：http://www.jianshu.com/p/b2c0f5f577c7

>本框架实现思路与YTKNetwork类似，相当于一个简单版，把每一个网络请求封装成对象。使用LXNetwork，你的每一个请求都需要继承LXBaseRequest类，通过覆盖父类的一些方法或者实现相关协议方法来构造指定的网络请求。这个网络库可直接在项目中使用，但是有些功能完成度不是很完美，待完善。

---

一、为什么要这样做？

实现思路的图在下面，可以对比着图看下面内容。
直接封装一个简易的HttpTool，里面直接调用AF，返回responseObject直接返回， 这样不行吗， 为什么要弄这么麻烦？
显而易见的优点大概有以下几点：
1，前后隔离AFNetworking，以后如果升级AF或者替换其他框架， 只需要改动直接与AF接触的LXRequestProxy和LXResponse内的代码即可，避免对项目中业务代码产生影响（半小时完成从AF2.6升级AF3.0，重度使用的三方框架一般都要隔离一下）
2，将每个接口抽象成一个类，易于管理，按每个接口的需求构造请求（比如有的接口要缓存，有的接口不要缓存）
3，所有接口调用都经过LXBaseRequest，可以方便的在基类中处理公共逻辑（比如项目全部完成了，突然要用请求参数排序，加盐等方式加密）

缺点：使用麻烦。。。。。


![实现思路.png](http://upload-images.jianshu.io/upload_images/2162015-d73291194e853b81.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
二、思路讲解
包括缓存在内的大体思路即上图，上图中箭头颜色由浅到深即为调用顺序，大概讲解一下

1，首先要把网络请求封装成对象，即图中TestApi（继承于LXBaseRequest），在Viewcontroller中调用接口loadData

2，这时会调用到TestApi的父类LXBaseRequest中的loadData方法， 并从TestApi实现的重写或者协议方法中获取url， 请求类型， 参数等信息， 调用LXRequestProxy中的请求方法

3， LXRequestProxy内部调用AF的GET或其他方法

4， 回调之后并没有直接返回responseObject，而是转换成LXResponse，这样返回的数据经过封装， 相当于从后面也进行了隔离， 比如AF2.x的时候回调block的参数还是`^(AFHTTPRequestOperation *operation, id reponseObject)`，AF3.x就变成了`^(NSURLSessionDataTask *task, id reponseObject)`，如果不转换一下， 直接返回到控制器，改起来就尴尬了。。。

5，一路回调到TestApi， 再到ViewController

6，走完之后再看一下缓存如何处理，首先，缓存一定分为存和取， 
存，在第5步， 一路回调到父类中的successCallApi这一步，将回调数据存起来的（用GET+登录状态或其他+url+参数转换的字符串作为key，这个随意，适合项目即可）。
取，在第2步调用父类LXBaseRequest中的loadData时会先检测该接口对应的数据是否存在， 存在直接返回父类LXBaseRequest中的successCallApi，不存在则正常发出请求

---
三， 举个栗子

......
