https://github.com/BashGui/easybashgui

简化编写 bash 制作 GUI 前端对话框的方法！查看 YouTube 视频：

[![观看视频](https://camo.githubusercontent.com/430ee064bf1e88d7d049faee7d5e0496d268e3a0dff3deef8af76c1a4c51b0cb/687474703a2f2f696d672e796f75747562652e636f6d2f76692f46456e34646f586d6958302f6d7164656661756c742e6a7067)](http://www.youtube.com/watch?feature=player_embedded&v=FEn4doXmiX0)

## EBG 简介

**E** asy **B** ash **G** ui 缩写为 EBG，是一个符合 Posix 的 Bash 函数库，旨在使用对话框的前端提供统一的 GUI 功能（从用户的角度来看是前端，但从 EGB 方面来看是后端）

#### 后端环境 GUI

EBG 实现了不同的对话框！您不必担心在什么环境中运行脚本，因为**EasyBashGUI**将根据后端（前端）的可用性透明地处理此问题。

- 控制台模式：
    - 胶
    - 对话
    - 无 (= bash)
- 图形模式：
    - 亚德
    - 对话框
    - 对话
    - 禅意
    - 对话

[![](https://github.com/BashGui/easybashgui/raw/master/docs/easybasguidialogs.jpeg)](https://github.com/BashGui/easybashgui/blob/master/docs/easybasguidialogs.jpeg)

#### 兼容性和运行时


EBG 用 编码`bash`，并使用大多数`coreutils`命令，但它可能在任何其他环境中工作，因为这些只是内部使用。

## 成分


EBG 是完全模块化的：

- `easybashgui`一个启动器，它将是你脚本中的端点
- `easybashgui-debug`切换前一个组件管理的一些调试选项
- `easybashgui.lib`管理后端，称为小部件库
- `easydialog-legacy`独立地在外部创建对话框（如今已过时）
- `easybashlib`用于可选功能，如清理临时工作目录

## 快速启动


```shell
source easybashgui

message "hola"
```

[很简单！？对吧？阅读docs/README.md](https://github.com/BashGui/easybashgui/blob/master/docs/README.md#quick-start-usage)中的“快速入门使用”部分[](https://github.com/BashGui/easybashgui/blob/master/docs/README.md#quick-start-usage)

### 安装


请查看[docs/install.md](https://github.com/BashGui/easybashgui/blob/master/docs/install.md)文档文件！

### 文档


请查看[docs/README.md](https://github.com/BashGui/easybashgui/blob/master/docs/README.md)文档文件！