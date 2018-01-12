# Markdown 插件介绍
* [MarkdownEditing][MarkdownEditing-main]  
MarkdownEditing是Markdown写作者必备的插件，它可以不仅可以高亮显示Markdown语法还支持很多编程语言的语法高亮显示。

* [OmniMarkupPreviewer][OmniMarkupPreviewer-main]  
OmniMarkupPreviewer用来预览markdown 编辑的效果，同样支持渲染代码高亮的样式。

# 安装MarkdownEditing插件
使用快捷键 'command + shift + p' 进入到Sublime命令面板，输入"package install"，从列表中选择"install Package"，然后回车,等列表更新后输入”MarkdownEditing“,选择并回车  
插件安装完毕后需要重新启动Sublime插件才能生效。插件除了能高亮语法，还提供快捷键快速插入标记，下面是常用的快捷键：

* command + shift + k 创建或者拷贝粘贴板内容插入一个image标记
* command + option + r 创建或者拷贝粘贴板内容插入一个link标记

# 安装OmniMarkupPreviewer插件
使用快捷键 'command + shift + p' 进入到Sublime命令面板，输入"package install"，从列表中选择"install Package"，然后回车,等列表更新后输入”OmniMarkupPreviewer“,选择并回车  
插件安装成功后就可以使用快捷键对编辑的markdown源文件进行预览了。下面是几个常用快捷键.

* Command +Option +O 在浏览器中预览
* Command+Option+X 导出HTML
* Ctrl+Alt+C HTML标记拷贝至剪贴板

# MaxOS上命令行打开markdown文件
需要配置sublime应用的软连接，具体操作如下：
```
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
open ~/.bash_profile
#then add line "export PATH=/usr/local/bin:$PATH" to ~/.bash_profile
source ~/.bash_profile
```

配置完后有如下几种使用方式：

* `sublime $filename` 打开文件
* `sublime $foldername`打开文件夹下内容
* `sublime .` 打开当前文件夹下所有文件

更多快捷键请参考[官方文档][markdownediting-key]

[markdownediting-key]: https://github.com/SublimeText-Markdown/MarkdownEditing#key-bindings
[MarkdownEditing-main]: https://github.com/SublimeText-Markdown/MarkdownEditing
[OmniMarkupPreviewer-main]: https://github.com/timonwong/OmniMarkupPreviewer
