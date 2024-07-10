
## 推荐

关于 Flutter 状态管理，强烈推荐看下面这几篇文章，还有手把手的 demo APP。

- [How the GetIt service locator package works in Dart](https://medium.com/flutter-community/how-the-getit-service-locator-package-works-in-dart-fc16a2998c07)
- [Flutter state management for minimalists](https://suragch.medium.com/flutter-state-management-for-minimalists-4c71a2f2f0c1)
- [GitHub - suragch/minimalist\_state\_management\_timer\_app](https://github.com/suragch/minimalist_state_management_timer_app/tree/master)
- [Flutter minimalist state management: Counter app](https://suragch.medium.com/flutter-minimalist-state-management-counter-app-ab1671a1f877)
- [Flutter minimalist state management: Weather app](https://suragch.medium.com/flutter-minimalist-state-management-weather-app-708b01417b9a)





## 什么是状态管理

老实说，之前看 Flutter 相关的文章和视频的时候，有些上来就推荐用 `Bloc` 的就很懵，没有前因后果，就告诉我要用这个东西，这东西用了有什么好处？这东西上手难度如何，这东西是必备的吗？和其他的状态管理库（比如`GetX`）对比有什么优点，等等之类的都不清楚，所以一直很难深入学习。


来看下图：
![1*psOXLwRrq0Bh-Z8yu5Bkrw.png (700×555) (medium.com)](https://miro.medium.com/v2/resize:fit:700/1*psOXLwRrq0Bh-Z8yu5Bkrw.png)



我本人是 iOS APP 开发，所以对于 MVVM 很熟悉，对比上图，UI Layer 是 View，Service Layer是 Model，所以 State Management Layer 就是 ViewModel，这样解释对比，我就对状态管理有了直观的理解，只是换了个名称，其实就是 ViewModel。

## 为什么要状态管理


那为什么要状态管理呢？其实理解了上面，就知道这其实不是个问题。由于项目使用`MVVM`所以需要 ViewModel。 同理由于采用了`UI Layer`、`State Management Layer`、`Service Layer`这种架构设计，所以需要状态管理，所以真正的问题是为什么采用这种架构？而这个问题就简单了，因为采用这种架构设计清晰、更容易实现数据分离、容易测试、代码更容易复用。


## `UI Layer`、`State Management Layer`、`Service Layer`

在 `Flutter` 中
`UI Layer`是绘制 UI，尽量不要把逻辑写作 `UI Layer`中，最多就是写一些`If else`判断显示不同的 UI，而 UI 要显示什么，显示成什么样，则是`state`控制的。
`UI Layer`是把`state`显示给用户。所以解析、格式化字符串、存储数据之类的逻辑也不应该写在这一层中。

`State Management Layer`是负责数据和 UI 交互的，一方面把数据处理后显示到 UI 上，另一方面处理响应 UI的事件，对数据进行计算变更。这个地方是大部分逻辑应该存在的地方。使用`State Managerment Layer`时需要注意，虽然这层负责和 UI 的交互，但是不应该把`UI Layer`和他混在一起，简单的说，可以这么理解`UI Layer`通过 `State Management Layer`获取数据，处理数据，但是`State Management Layer`对`UI Layer`了解不多，这样做的好处是，当重构`UI Layer`时，`State Management Layer`不受影响。

`Service Layer`，虽然大部分的逻辑在`State Management Layer`中，但是还有一部分逻辑是在这一层处理的，这一层可以理解为封装好的统一的数据层，里面可能是一个本地数据库、或者网络请求的数据，或者其他存储的数据。然后统一封装为`Service Layer`对外调用。通常做法是把`Service Layer`定义为`Protocol`或者`interface`，然后再由具体的`Service`实现这些协议或者接口，对于`State Management Layer`来说，只知道有这些协议或者接口，至于具体是怎么实现的，`State Management Layer`并不清楚。这样做的好处是，通过定义协议或者接口，可以更方便的实现分离，更方便的测试，比如可以在服务端没好的时候，通过 Service来实现`Mock Fake Data`进行测试。

## 作者推崇的`Service Locator`模式

回归主题，如何实现状态管理，即如何设计`State Management Layer`？

首先再来思考一下`State Management Layer`的作用：
1. 在`UI Layer`能够引用`State Management Layer`
2. `State Management Layer`能够响应`UI Layer`的事件
3. `UI Layer`能够通过`State Management Layer`监听状态变化
4. 状态变化能够自动刷新 UI

下面一条条来看，如何处理：

### 在`UI Layer`能够引用`State Management Layer`

这一步，很简单，只需要在对应`Widget`中声明对应的 `State Manager` 即可，这里有两种方式，
一种是普通的
``` dart
class MyPage extends StatefulWidget {
  // ... 
} 

class _MyPageState extends State<MyPage> {
  final manager = MyPageManager(); 
  // ...
}

```

一种是使用`GetIt`，单例模式的

```dart
class MyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final manager = getIt<MyPageManager>();
    // return ...
  }
}
```

使用`GetIt`的`Service Locator`模式，可以参考[How the GetIt service locator package works in Dart](https://suragch.medium.com/how-the-getit-service-locator-package-works-in-dart-fc16a2998c07?sk=496f177587ce0c6932d8874642fc9425)。这里感觉还是有些难以接受，因为之前开发 APP 时，被教导的是尽量少用单例，因为单例全局可访问，不可控，容易造成难以测试，难以维护。但是这里作者提出的是，在遵循下面规则的情况下，可以使用单例，来进行状态管理。
- 不要直接通过`UI Layer`修改`State Management`中的`State`。要通过调用`State Management Layer`中的方法来修改。
- 针对测试的问题，`GetIt`提供测试的方法，参考[GetIt provides a way to test these classes](https://pub.dev/packages/get_it#testing-with-getit)


### `State Management Layer`能够响应`UI Layer`的事件

`UI Layer`中的事件响应，直接通过调用`State Management Layer`中的方法来实现，如下：

``` dart
loginPageManager.submitUserInfo(username, password);
```


如果有需要在页面打开时初始化的逻辑，可以放在`initState`中来初始化。如下：

``` dart
@override 
void initState() { 
  super.initState(); 
  manager.doSomething(); 
}
```


### `UI Layer`能够通过`State Management Layer`监听状态变化

这一步是比较麻烦的，直接使用`Flutter`自带的`ValueNotifier`或者`ChangeNotifier`来实现。使用方式如下：

``` dart
final myStateNotifier = ValueNotifer<int>(1);

myStateNotifier.value = 2;
```

也可以声明一个类继承自`ValueNotifier`，如下：

``` dart
class FavoriteNotifier extends ValueNotfier<bool> {
  // set initial value to false
  FavoriteNotfier(): super(false);

  // get reference to service layer
  final _storageService = getIt<StorageService>();

  // a method to call from the outside
  void toggleFavoriteStatus(Song song) {
    value = !value;
    _storageService.updateFavoriteSong(song, value);
  }
}
```

从上面的代码可以看出，所有的逻辑都封装在 `Notifier`中，对外暴露的是只一个调用方法。在`State Management`类中，只需要创建这个`Notifier`，然后调用`Notifier`中的方法即可。从而把复杂的逻辑进一步细化到具体的`Notifier`中，而不是直接成堆的混在`State Management Layer`中。

### 状态变化能够自动刷新 UI

最后，如果使用了`ValueNotifier`或者`ChangeNotifier`，那么`UI`的显示也需要做对应的调整。比如使用了`ValueNotifier`则需要用对应的`ValueListenableBuilder` Widget 来接收并响应对应`Value`的改变。
比如想要接收`FavoriteNotifer`的变化刷新 UI，则需要如下实现：

``` dart
class FavoriteButton extends StatelessWidget { 
  const FavoriteButton({Key? key}) : super(key: key); 
  @override Widget build(BuildContext context) { 
    final playPage = getIt<PlayPageManager>(); // 1 
    return ValueListenableBuilder<bool>( // 2 
      valueListenable: playPage.favoriteNotifier, // 3 
      builder: (context, value, child) { // 4, 5, 6, 7 
        return IconButton( 
          icon: Icon( 
            (value) 
            ? Icons.favorite 
            : Icons.favorite_border, 
	      ), 
	      onPressed: playPage.onFavoritePressed, 
	    ); 
      }, 
    ); 
  } 
}
```


## 总结

`Flutter`中的状态管理，可以简单理解为`MVVM`中`VM`的实现方式。其目的都是为了架起数据和 UI 的桥梁，不同的状态管理方式，本质上是不同的传递数据和事件的方式。

针对不复杂的项目，可以采用`service locator`的模式，通过`GetIt`把对应的`State Management Layer`声明为单例，然后在`UI Layer`中通过`GetIt`直接获取。这种模式把项目架构总体分为三层：
- `UI Layer`：尽量不要包含逻辑，只负责渲染`State`的数据；
- `State Management Layer`
	- 响应`UI Layer`的事件
	- 读取`Service Layer`的数据，处理后传递给`UI Layer`
	- 调用`Service Layer`方法，处理数据
	- 把逻辑尽量拆分细，不同模块的逻辑不要混在一起，建议抽取相同模块的逻辑，封装为`Notifier`，然后在`State Management Layer`中调用`Notifier`的实现。
- `Service Layer`
	- 一个项目可能用多个不同的`Service`
	- `Service`定义为`interface`或者`protocol`，具体的实现，通过集成自`interface`的类来实现。

## 参考


- [GitHub - suragch/minimalist\_state\_management\_timer\_app](https://github.com/suragch/minimalist_state_management_timer_app/tree/master)
- [Flutter state management for minimalists | by Suragch | Medium](https://suragch.medium.com/flutter-state-management-for-minimalists-4c71a2f2f0c1)
- [How the GetIt service locator package works in Dart](https://suragch.medium.com/how-the-getit-service-locator-package-works-in-dart-fc16a2998c07?sk=496f177587ce0c6932d8874642fc9425)
- [GetIt provides a way to test these classes](https://pub.dev/packages/get_it#testing-with-getit)
