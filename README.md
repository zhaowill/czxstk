# Stata命令：czxstk
### 这个命令的作用是从网易财经获取中国股票数据，然后绘制股票最高价-最低价-收盘价走势图和交易量的直方图，最后导出至本地保存。这个命令的帮助文档完全使用中文书写，下载得到的股票数据的标签也是中文的，希望这样能方便我的朋友们使用。例如：

![600000.png](http://upload-images.jianshu.io/upload_images/8103632-62b3283f8100e3e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 安装：

#### 首先你需要安装github命令，这个命令是用来安装github上的命令的：
```stata
net install github, from("https://haghish.github.io/github/")
```

#### 然后就可以安装这个命令了：
```stata
github install czxa/czxstk
```

#### 更新：
```stata
github install czxa/czxstk, replace
```

#### 或者下载安装：
* 另外你也可以从这里把ado文件和sthlp文件下载下来，然后放在你的C:/ado/plus文件夹中对应的首字母文件夹里面，如果你的电脑是Mac系统，那么你需要把这两个文件放在这个文件夹里：
```
/Users/mr.cheng/Library/Application Support/Stata/ado/plus/
```
* 注意把“mr.cheng”改成你自己的电脑名字。

#### 用法：
##### 基本语法：
```stata
czxstk code_list [, stock index path(~/Desktop) from(20170101) to(20171125) savefile closegraph fmt(pdf)]
```
* code_list:  是一列你想要可视化的股票或指数代码，它们之间使用空格分离。中国股票的代码为六位数，如果不足六位，该命令会自动在代码前面加0补齐至六位。例如:

> 股票代码和股票名称:
 000001 平安银行（原为深发展）  
 000002 深万科Ａ
 600000 浦发银行

> 指数代码和名称:
 000001 上证综合指数.
 000300 沪深300.
 399001 深证成指.

* 股票代码前面的几个零是可以省略的.

* path: 如果有选择项s，path选项可以用来指定dta文件的保存位置，很遗憾暂时只能把生成的图片文件保存在工作目录里。
这个文件夹可以是已经存在的，也可以是新创建的。
如果这个文件夹不存在，那么会自动创建。

##### 选项

* path(文件夹的名字): 如果有选择项s，path选项可以用来指定dta文件的保存位置，默认路径为工作目录。
* stock: 指定代码列表为股票代码，并且这是默认选项。
* index: 指定代码列表为指数代码。
* from(string): 可以简写为f。指定八位数字的年月日作为绘图的起始日期，例如20170101或2017-01-01。
* to(string): 可以简写为t。指定八位数字的年月日作为绘图的终止日期，例如20171127或2017-11-27。如果指定了起始日，又指定了终止日，那么该命令就会绘制两个日期之间的图；如果只指定了起始日期，那么就会绘制从起始日期到当天的图；如果只指定了终止日期，那么就会绘制从终止日期前60天（连续天而非交易日）开始到终止日期的图；如果既没有指定起始日期，又没有指定终止日期，那么将会默认绘制从当天的60天前开始到当天结束的图。
* fmt(string): 指定输出图片的格式，有ps/eps/wmf/emf/pdf/png/tif七种图片导出的格式。默认为png格式。
* savefile: 可以简写为s。用来指定是否保存股票的完整数据文件，默认不保存。
* closegraph: 可以简写为cg。用来指定是否显示图，如果指定不显示图，会自动保存股票的完整数据文件。如果没有指定，默认不保存。

#### 示例

```stata
czxstk 600000
czxstk 2, stock
czxstk 600000, path(~/Desktop)
czxstk 2, path(~/Desktop)
czxstk 600000 000001 600810
czxstk 600000 000001 600810, path(~/Desktop)
czxstk 1, index
czxstk 1 300, index
czxstk 1 300, index from(20170101) to(20171125)
czxstk 1 300, index from(20170101) to(20171125) s
czxstk 1 300, index f(20170101) t(20171125) cg
czxstk 1 300, index fmt(pdf) f(20170101) t(20171125) cg
```

#### 作者

程振兴
暨南大学经济学院
中国广州
[该命令Github地址](https://github.com/czxa/czxstk)
[该命令的网页](http://www.czxa.top/czxstk/)
[个人网站](www.czxa.top)
邮箱：czxjnu@163.com

#### Reference:

* cntrade命令: 张璇. 李春涛. 薛原.
* 安装cntrade命令：

```stata
ssc install cntrade
```

* 查看帮助

```stata
help cntrade
```
