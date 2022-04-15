# **AR元相机SDK接入说明**
********
## 一、项目地址

1、Unity项目
[https://git.crhlink.com/ar/arcamera](https://git.crhlink.com/ar/arcamera)

2、iOS-SDK项目
[https://git.crhlink.com/ar/arcamera-ios](https://git.crhlink.com/ar/arcamera-ios)

iOS-SDK项目包含SDK、Demo，接入时只需要添加SDK目录下代码。时间关系，暂时没有封装成Framework。


本文档以一个AR相机的Unity场景为例，说明App+SDK对接方式，代码使用sdk分支。
具体相机API，后续陆续更新。

********
## 二、项目配置

1、加载Unity项目，选择ARCameraScene场景，切换iOS平台，导出Unity-iPhone工程。

2、创建workspace，添加App工程、Unity-iPhone工程、SDK目录下源码。

3、配置Framework依赖、bitcode等，这里暂不赘述。

********
## 三、SDK接入

### 1、SDK设置
#### (1) 在main.m入口函数添加
```
    [[WTUnitySDK sharedSDK] runInMainWithArgc:argc argv:argv];

```
即
```
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    [[WTUnitySDK sharedSDK] runInMainWithArgc:argc argv:argv];
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

```

#### (2) 在AppDelegate.m中添加
```
    [[WTUnitySDK sharedSDK] setLaunchOptions:launchOptions];
    [[WTUnitySDK sharedSDK] setMainWindow:self.window];
```
即
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[WTUnitySDK sharedSDK] setLaunchOptions:launchOptions];
    [[WTUnitySDK sharedSDK] setMainWindow:self.window];
    return YES;
}
```


### 2、视图场景切换
通过以下两个方法进行Native/Unity Controller切换。
```
- (void)showNativeWindow; // 显示Native
- (void)showUnityWindowFrom:(UIViewController *)fromController withController:(UIViewController *)uiController; // 显示Unity
```

#### （1）Native切换至Unity
需要传入当前发起视图控制器。
    如需要在Unity视图上方添加原生Overlay视图，需要传入Overlay视图的控制器。
    Overlay视图通过WTUnityOverlayViewDelegate的代理方法viewToOverlayInUnity返回
```
@protocol WTUnityOverlayViewDelegate <NSObject>

@optional
- (UIView *)viewToOverlayInUnity;

@end
```
**注意：viewToOverlayInUnity代理方法不要返回ViewController默认View，单独创建一个ContainerView即可。**

在目前的实现中，发起方视图控制器是使用presentViewController方式加载Overlay的控制器。

#### （2）Unity返回Native
通过showNativeWindow返回发起的视图控制器。
    通过WTUnityViewControllerDelegate代理方法可以获取返回事件。
```
@protocol WTUnityViewControllerDelegate <NSObject>

@optional
- (void)unityDidReturnToNativeWindow:(UIViewController *)fromController;

@end
```

### 3、App、Unity互调
统一术语，App调用Unity方法称为正向调用，Unity调用App方法称为回调。


#### （1） App调用Unity方法
通过Framework中的WTUnitySDK类调用。
```
@interface WTUnitySDK : NSObject

+ (WTUnitySDK *)sharedSDK;
+ (UnityFramework *)ufw;

#pragma Config Methods
-(void)runInMainWithArgc:(int)argc argv:(char **)argv;
- (void)setLaunchOptions:(NSDictionary *)opts;
- (void)setMainWindow:(UIWindow *)window;

#pragma Operation Methods
- (void)showNativeWindow;
- (void)showUnityWindowFrom:(UIViewController *)fromController withController:(UIViewController *)uiController;
- (void)switchToScene:(NSString *)sceneName;


#pragma Select Model
- (void)useMantisVisionModel:(NSString *)modelPath;
- (void)useCommon3DModel:(NSString *)modelPath;

#pragma Shooting
- (void)takePhoto:(NSString *)pID;
- (void)startRecordingVideo:(NSString *)vID;
- (void)stopRecordingVideo;

@end

```

#### （2）Unity回调App方法
Unity回调目前主要通过WTUnityCallbackUtils注册代理方法实现。
通过
```
    [WTUnityCallbackUtils registerApiForShootingCallbacks:self];

```
监听相应的代理事件。代理方法将按业务模块进行分类。

SDK内声明如下，代参考：
```
@protocol WTUnityShootingCallbackProtocol
@optional
- (void)unityDidFinishPhotoing:(NSString *)pID withPath:(NSString *)path;

@optional
- (void)unityDidStartRecording:(NSString *)vID;

@optional
- (void)unityDidFinishRecording:(NSString *)vID withPath:(NSString *)path;
@end


__attribute__ ((visibility("default")))
@interface WTUnityCallbackUtils : NSObject

+ (void)registerApiForShootingCallbacks:(NSObject<WTUnityShootingCallbackProtocol> *)api;

@end

```


### 4、部分接口说明

#### （1） 模型加载

在相机页面，调用以下方法设置当前选用模型，参数为模型文件路径
```
- (void)useMantisVisionModel:(NSString *)modelPath; // 我的形象素材
- (void)useCommon3DModel:(NSString *)modelPath; // 热门3D素材
```


#### （2） 合拍功能
    
在相机页面，选定模型并放置完成后，调用以下方法。
    
##### 1、拍摄照片
```
- (void)takePhoto:(NSString *)pID;
``` 
pID自行定义，回调中对应返回。

```
- (void)unityDidFinishPhotoing:(NSString *)pID withPath:(NSString *)path;
```
拍摄完成回调方法，返回拍摄传入pID，及照片存储路径。
默认路径为Documents/Photo，文件名格式photo_2022_4_7_16_13_6_977.png



##### 2、拍摄视频

```
- (void)startRecordingVideo:(NSString *)vID;
- (void)stopRecordingVideo;
``` 
vID自行定义，回调中对应返回。


```
- (void)unityDidStartRecording:(NSString *)vID;
- (void)unityDidFinishRecording:(NSString *)vID withPath:(NSString *)path;
```
视频拍摄开始、及拍摄完成回调，返回拍摄传入vID，及视频存储路径。
默认路径为Documents/Video，文件名格式recording_2022_04_07_15_45_53_195.mp4


##### 3、拍摄参数

```
typedef enum _WTShootingParams {
    WTShooting_SD,
    WTShooting_HD
} WTShootingParams;

- (void)setShootingParams:(WTShootingParams)params;
```
目前支持高清(HD)与标清(SD)，默认为标清。
