{smcl}
{* 25Nov2017}{...}
{cmd:help czxstk}{right: }
{hline}

{title:标题}


{phang}
{bf:czxstk} {hline 2} 这个命令的作用是从网易财经获取中国股票数据，然后绘制股票最高价-最低价-收盘价走势图和交易量的直方图，最后导出至本地保存。
这个命令的帮助文档完全使用中文书写，下载得到的股票数据的标签也是中文的，希望这样能方便我的朋友们使用。例如：

{pstd}{browse "http://upload-images.jianshu.io/upload_images/8103632-62b3283f8100e3e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240":示例结果图片}{p_end}

{title:语法}

{p 8 18 2}
{cmdab:czxstk} {it: codelist} {cmd:,} [{it:options}]

{marker description}{...}
{title:描述}

{pstd}{it:codelist} 是一列你想要可视化的股票或指数代码，它们之间使用空格分离。中国股票的代码为六位数，如果不足六位，该命令会自动在代码前面加0补齐至六位。例如: {p_end}

{pstd} {hi:股票代码和股票名称:} {p_end}
{pstd} {hi:000001} 平安银行（原为深发展）  {p_end}
{pstd} {hi:000002} 深万科Ａ {p_end}
{pstd} {hi:600000} 浦发银行 {p_end}

{pstd} {hi:指数代码和名称:} {p_end}
{pstd} {hi:000001} 上证综合指数. {p_end}
{pstd} {hi:000300} 沪深300. {p_end}
{pstd} {hi:399001} 深证成指. {p_end}

{pstd}股票代码前面的几个零是可以省略的. {p_end}

{pstd}{it:path} 如果有选择项s，path选项可以用来指定dta文件的保存位置，很遗憾暂时只能把生成的图片文件保存在工作目录里。 {p_end}
{pstd} 这个文件夹可以是已经存在的，也可以是新创建的。 {p_end}
{pstd} 如果这个文件夹不存在，那么会自动创建。 {p_end}

{marker options}{...}
{title:选项}

{phang}
{opt path(文件夹的名字)}: 如果有选择项s，path选项可以用来指定dta文件的保存位置，默认路径为工作目录。{p_end}

{phang}
{opt stock}: 指定代码列表为股票代码，并且这是默认选项。 choice.{p_end}

{phang}
{opt index}: 指定代码列表为指数代码。{p_end}

{phang}
{opt from(string)}: 可以简写为f。指定八位数字的年月日作为绘图的起始日期，例如20170101或2017-01-01。

{phang}
{opt to(string)}: 可以简写为t。指定八位数字的年月日作为绘图的终止日期，例如20171127或2017-11-27。如果指定了起始日，又指定了终止日，那么该命令就会绘制两个日期之间的图；如果只指定了起始日期，那么就会绘制从起始日期到当天的图；如果只指定了终止日期，那么就会绘制从终止日期前60天（连续天而非交易日）开始到终止日期的图；如果既没有指定起始日期，有没有指定终止日期，那么将会默认绘制从当天的60天前开始到当天结束的图。

{phang}
{opt fmt(string)}: 指定输出图片的格式，有ps/eps/wmf/emf/pdf/png/tif七种图片导出的格式。默认为png格式。

{phang}
{opt savefile}: 可以简写为s。用来指定是否保存股票的完整数据文件，默认不保存。

{phang}
{opt closegraph}: 可以简写为cg。用来指定是否显示图，如果指定不显示图，会自动保存股票的完整数据文件。如果没有指定，默认不保存。


{title:示例}

{phang}
{stata `"czxstk 600000"'}
{p_end}
{phang}
{stata `"czxstk 2, stock"'}
{p_end}
{phang}
{stata `"czxstk 600000, path(~/Desktop)"'}
{p_end}
{phang}
{stata `"czxstk 2, path(~/Desktop)"'}
{p_end}
{phang}
{stata `"czxstk 600000 000001 600810"'}
{p_end}
{phang}
{stata `"czxstk 600000 000001 600810, path(~/Desktop)"'}
{p_end}
{phang}
{stata `"czxstk 1, index"'}
{p_end}
{phang}
{stata `"czxstk 1 300, index"'}
{p_end}
{phang}
{stata `"czxstk 1 300, index from(20170101) to(20171125)"'}
{p_end}
{phang}
{stata `"czxstk 1 300, index from(20170101) to(20171125) s"'}
{p_end}
{phang}
{stata `"czxstk 1 300, index f(20170101) t(20171125) cg"'}
{p_end}
{phang}
{stata `"czxstk 1 300, index fmt(pdf) f(20170101) t(20171125) cg"'}
{p_end}

{title:作者}

{pstd}程振兴{p_end}
{pstd}暨南大学经济学院{p_end}
{pstd}中国广州{p_end}
{pstd}{browse "https://github.com/czxa/czxstk":Github/czxstk}{p_end}
{pstd}{browse "http://czxa.top":个人网站}{p_end}
{pstd}czxjnu@163.com{p_end}

{title:Also see}

{p 4 14 2}
Reference: cntrade: 张璇. 李春涛. 薛原.

{space 4}Article: {it:Stata Journal}, volume 14, number 2: {browse "http://www.stata-journal.com/article.html?article=dm0074":dm0074}

{psee}
{space 2}Help:  {manhelp cntrade D}
{break}{helpb cntrade} if installed
{p_end}
