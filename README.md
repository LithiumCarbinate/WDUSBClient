# WDUSBClient(only support iOS9+, iOS10+)
##Features
- 更加快速的通信效率, 直接使用socket通信, 而非http.
- 无需担心设备没有连接上wifi等影响.链路层走的是USB数据线.
- 基于facebook的WebDriverAgent驱动进行开发.
- 基于OC语言, 可供广大iOS开发者方便的实现自动化UI, 提供App稳定性.
- 支持多机并发测试。
- 非侵入式框架, 无需在项目中嵌入


# 安装文章参考
https://testerhome.com/topics/6172

##Now, the framework only works on usb connection, so simulator doesn't support(只支持真机设备)

#将Client文件夹下的东西都拖到你的工程中。引入主头文件
`#import "WDClient.h"`

#Create Client(创建客户端)
```
NSString *udid = @"a49bcbd6a9d3b24b8f70b8adde348925a5bfac6e";
FBHTTPOverUSBClient *client = [[WDClient alloc] initWithDeviceUDID: udid];
```
#Start A App on real device(在真机上运行)
###first set the bundle id(先设置bundle id)
`[client setBundleID: @"com.nd.www.TestAppForIOS"]`
###next step, call startApp method(下一步, 调用startApp方法)
`[client startApp]`

# 相关连接(更多文档查看具体链接)
- API(接口档案): https://github.com/sixleaves/WDUSBClient/wiki
- WD地址(建议用我的, 我会和facebook那边的框架保持同步, 并会添加新功能, 修复bug):https://github.com/sixleaves/WebDriverAgent

# 交流QQ群
`QQ群: 114577285`

##更多的用处等待你的探索!!!


