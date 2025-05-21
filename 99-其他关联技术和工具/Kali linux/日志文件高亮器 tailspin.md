
### 简介

`tailspin` 是一个功能强大的日志文件查看工具，无需任何配置即可支持查看任意格式的日志文件。它通过逐行读取日志文件，并针对每一行运行一系列正则表达式来识别诸如日期、数字、严重性关键字等常见的日志文件模式，并对这些元素进行高亮显示。由于不依赖于特定格式或位置假设，因此在不同日志文件中都能保持一致的高亮效果。

### 安装方法

可通过多种包管理器轻松安装 `tailspin`，其二进制名称为 `tspin`：
- 使用 Homebrew：`brew install tailspin`
- 使用 Cargo：`cargo install tailspin`
- 对于 Archlinux：`pacman -S tailspin`
- 在 Nix 环境下：`nix-shell -p tailspin`
- 在 NetBSD 中：`pkgin install tailspin`
- 在 FreeBSD 上：`pkg install tailspin`

从源代码编译安装时，使用 `cargo install --path .` 命令，安装完成后，二进制文件将位于 `~/.cargo/bin` 目录下，请确保将其添加到环境变量 `PATH` 中，并确保使用的是最新版本的 `less` 工具。

### 高亮组

`tailspin` 默认会自动识别并高亮以下类别：
- 日期
- 关键字
- URL
- 数字
- IP 地址
- 引号
- Unix 文件路径
- HTTP 方法
- UUID
- 键值对
- Unix 进程

用户可以通过创建 `~/.config/tailspin/config.toml` 文件来自定义高亮组样式。样式的定义包括前景色、背景色、斜体、粗体和下划线等属性。例如，要更改日期高亮组的颜色，只需在 `config.toml` 文件中指定绿色前景色。

监控文件夹
`tailspin` 可以监听指定文件夹中新行条目的出现，这对于监视被轮换的日志文件非常有用。当监听文件夹时，`tailspin` 将进入跟随模式（按 `Ctrl + C` 可中断），仅显示启动后新增的行。

自定义高亮组
用户可以在 `config.toml` 文件中编辑不同高亮组的样式设置，如需禁用某个高亮组，只需将 `disabled` 字段设为 `true`。

通过 `config.toml` 添加关键词
用户可以在配置文件中直接添加自定义关键词及其相应的样式，也可以扩展已有关键词列表。

命令行添加关键词
如果希望临时增加高亮关键词而不修改配置文件，可以使用命令行标志 `--words-[颜色名]` 后接逗号分隔的关键词列表。

与标准输入输出协作
默认情况下，`tailspin` 会使用分页程序 `less` 查看高亮过的日志文件。但若将数据管道传输至 `tailspin`，它将直接向 `stdout` 输出高亮后的结果。例如，可以将其他命令的输出通过管道传递给 `tailspin` 来实时高亮日志信息。

使用分页程序 `less`
`tailspin` 内置使用 `less` 作为分页浏览工具。用户可以通过 `man less` 获取更多关于 `less` 的信息，或者在 `less` 中按下 `h` 键访问帮助屏幕。

在 `less` 中导航可通过一组熟悉的键绑定完成，比如使用 `j` 和 `k` 键上下滚动一行，`d` 和 `u` 键上/下半页滚动，`g` 和 `G` 键跳转到文件顶部或底部。

跟随模式
使用 `-f` 或 `--follow` 标志运行 `tailspin`，将自动滚动至底部并随日志文件更新而实时打印新行内容。按 `Ctrl + C` 可停止跟随，但仍可查看当前文件内容；在 `less` 中按 `Shift + F` 可重新开始跟随。

搜索功能
使用 `/` 加搜索词执行搜索，如 `/ERROR` 查找第一个 ERROR 出现的位置，然后分别使用 `n` 和 `N` 键查找下一个和上一个匹配项。

过滤功能
在 `less` 中可以通过 `&` 后跟模式进行行过滤，例如 `&ERROR` 显示仅包含 ERROR 的行。还可以使用正则表达式组合多个关键词，如 `&\(ERROR\|WARN\)` 显示包含 ERROR 或 WARN 的行，清空过滤条件只需单独输入 `&`。

### 设置选项

`tailspin` 提供了一系列命令行参数用于控制行为，如：
- `-f` 或 `--follow`：跟随文件内容更新
- `-e` 或 `--start-at-end`：从文件末尾开始
- `-p` 或 `--print`：直接输出到标准输出
- `-c` 或 `--config-path [PATH]`：指定配置文件路径
- `-l` 或 `--follow-command [CMD]`：跟随提供的命令输出
- `--bucket-size [SIZE]`：设置并行处理的缓冲区大小
- `--words-[COLOR] [WORDS]`：使用指定颜色高亮给定单词
- `--disable-builtin-keywords`：禁用所有内置高亮组
- `--disable-booleans`：禁用布尔值和空值的高亮
- `--disable-severity`：禁用严重性级别的高亮
- `--disable-rest`：禁用 REST 动词的高亮