capture program drop czxstk
program define czxstk
	version 12.0
	syntax anything(name = tickers), [ path(string) stock index from(string) to(string) f(string) t(string) fmt(string) savefile s closegraph cg]
	if "`savefile'" != ""{
		local s = "`savefile'"
	}
	if "`closegraph'" != ""{
		local cg = "`closegraph'"
	}
	if "`from'" != ""{
		cap local f = "`from'"
	}
	if "`to'" != ""{
		cap local t = "`to'"
	}
	if "`stock'" != "" & "`index'" != "" {
		disp as error "错误！：你不能同时使用选择项stock和index'"
		exit 198
	}
	
	local address "http://quotes.money.163.com/service/chddata.html"

	if "`index'" == "" local field "TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP"
	else local field "TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER"

	local start 19900101
	local end: disp %dCYND date("`c(current_date)'","DMY")

	if "`path'" ~= "" {
		capture mkdir `path'
	} 

	else {
		local path `c(pwd)'
	}
	
	if regexm("`path'", "(/|\\)$") local path = regexr("`path'", ".$", "")

	foreach name in `tickers' {

		if length("`name'") > 6 {
			disp as error `"错误！：`name' 不是一个有效的股票代码"'
			exit 601
		} 
		while length("`name'") < 6 {
			local name = "0"+"`name'"
		}
		
		qui if "`index'" == "" {
			if `name' >= 600000 local url "`address'?code=0`name'&start=`start'&end=`end'&fields=`field'"
			else local url "`address'?code=1`name'&start=`start'&end=`end'&fields=`field'"
		}
				
		qui else {
			if `name'<=1000 local url "`address'?code=0`name'&start=`start'&end=`end'&fields=`field'"
			else local url "`address'?code=1`name'&start=`start'&end=`end'&fields=`field'"
		}
		
		qui capture copy `"`url'"' tempcsvfile.csv, replace
		local times = 0
		while _rc ~= 0 {
			local times = `times' + 1
			sleep 1000
			qui cap copy `"`url'"' tempcsvfile.csv, replace
			if `times' > 10 {
				disp as error "错误！：因为你的网络速度贼慢，无法获得数据"
				exit 601
			}
		}
		
		qui {
		
			if c(stata_version) >= 14 {
				clear
				unicode encoding set gb18030
				qui unicode translate tempcsvfile.csv
				unicode erasebackups, badidea
			}
				
			qui insheet using tempcsvfile.csv, clear
			
			if `=_N' == 0 {
				disp as error `"错误！：`name'是一个无效的股票代码"'
				clear
				cap erase tempcsvfile.csv
				if _rc != 0 {
					! del tempcsvfile.csv /F
				}
				exit 601
			}

			if "`index'" == "" {
				if c(stata_version) < 14 {
					gen date = date(v1, "YMD")
					drop v1 
					format date %dCY-N-D
					label var date "Trading Date"
					rename v2 stkcd 
					capture destring stkcd, replace force ignor(')
					label var stkcd "股票代码"
					rename v3 stknme
					label var stknme "股票名称"
					rename v4 clsprc 
					label var clsprc "收盘价"
					drop if clsprc==0
					rename v5 hiprc 
					label var hiprc  "最高价"
					rename v6 lowprc 
					label var lowprc "最低价"
					rename v7 opnprc
					label var opnprc "开盘价"
					destring v10, force replace
					rename v10 rit
					replace rit = 0.01 * rit
					label var rit "日收益率"
					rename v11 turnover
					label var turnover "换手率"
					rename v12 volume
					label var volume "交易量"
					rename v13 transaction
					label var transaction "交易额（RMB）"
					rename v14 tcap
					label var tcap "市价总值"
					rename v15 mcap
					label var mcap "流通市值"
					drop v8 v9
				}
				
				else {
					gen date = date(日期, "YMD")
					drop 日期 
					format date %dCY-N-D
					label var date "交易日"
					rename 股票代码 stkcd
					capture destring stkcd, replace force ignor(')
					label var stkcd "股票代码"
					rename 名称 stknme
					label var stknme "股票名称"
					rename 收盘价 clsprc
					label var clsprc "收盘价"
					drop if clsprc==0
					rename 最高价 hiprc
					label var hiprc  "最高价"
					rename 最低价 lowprc
					label var lowprc "最低价"
					rename 开盘价 opnprc
					label var opnprc "开盘价"
					destring 涨跌幅, replace force
					rename 涨跌幅 rit
					replace rit = 0.01*rit
					label var rit "日收益率"
					rename 换手率 turnover
					label var turnover "换手率"
					rename 成交量 volume
					label var volume "交易量"
					rename 成交金额 transaction
					label var transaction "交易额（RMB）"
					rename 总市值 tcap
					label var tcap "市价总值"
					rename 流通市值 mcap
					label var mcap "流通市值"
					drop 前收盘 涨跌额
				}
				order stkcd date
			}

			else {
				if c(stata_version) < 14 { 
					gen date = date(v1, "YMD")
					drop v1 
					format date %dCY-N-D
					label var date "交易日"
					rename v2 indexcd 
					capture destring indexcd, replace force ignor(')
					label var indexcd "指数代码"
					rename v3 indexnme
					label var indexnme "指数名称"
					rename v4 clsprc
					label var clsprc "收盘价"
					drop if clsprc==0
					rename v5 hiprc
					label var hiprc  "最高价"
					rename v6 lowprc
					label var lowprc "最低价"
					rename v7 opnprc
					label var opnprc "开盘价"
					destring v10, replace force
					rename v10 rmt
					gen rmt = 0.01*rmt
					label var rmt "日收益率"
					rename v11 volume
					label var volume "交易量"
					rename v12 transaction
					label var transaction "交易额（RMB）"
					drop v8 v9
				}
				
				else {
					gen date = date(日期, "YMD")
					drop 日期
					format date %dCY-N-D
					label var date "交易日"
					rename 股票代码 indexcd
					capture destring indexcd, replace force ignor(')
					label var indexcd "指数代码"
					rename 名称 indexnme
					label var indexnme "指数名称"
					rename 收盘价 clsprc
					label var clsprc "收盘价"
					drop if clsprc==0
					rename 最高价 hiprc
					label var hiprc  "最高价"
					rename 最低价 lowprc
					label var lowprc "最低价"
					rename 开盘价 opnprc
					label var opnprc "开盘价"
					destring 涨跌幅, replace force
					rename 涨跌幅 rmt
					replace rmt = 0.01*rmt
					label var rmt "日收益率"
					rename 成交量 volume
					label var volume "交易量"
					rename 成交金额 transaction
					label var transaction "交易额（RMB）"
					drop 前收盘 涨跌额
				}
				order indexcd date
			}
			sort date 
			if "`s'" != ""{
				save `"`path'/`name'"', replace
				noi disp as text "file `name'.dta has been saved"
			}
			if "`cg'" != ""{
				save `"`path'/`name'"', replace
				noi disp as text "file `name'.dta has been saved"
			}
			cap erase tempcsvfile.csv
			if _rc != 0 {
				! del tempcsvfile.csv /F
			}
		}
		if "`cg'" == ""{
			if "`t'" == ""{
			local t: disp %dCYND date("`c(current_date)'","DMY")
				if "`f'" == ""{
					local f: disp %dCYND (date("`c(current_date)'","DMY")-60)
				}
			}
			if "`t'" != "" & "`f'" == ""{
					local f: disp %dCYND (date("`t'","YMD")-60)
			}
			if date("`f'", "YMD") >= date("`t'", "YMD"){
				disp as error "错误！：你输入的起始日期晚于结束日期"
			}
			if "`fmt'" == "" {
				local fmt = "png"
			}
			if "`fmt'" == "ps" | "`fmt'" == "eps" | "`fmt'" == "wmf" | "`fmt'" == "emf" | "`fmt'" == "pdf" | "`fmt'" == "png" | "`fmt'" == "tif" {
					qui sum volume
					if `r(max)' <= 100{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'" , replace as(`fmt')	
					}
					if `r(max)' > 100 & `r(max)' <= 1000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						replace volume = volume/10
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（十股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'" , replace as(`fmt')	
					}
					if `r(max)' > 1000 & `r(max)' <= 10000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						replace volume = volume/100
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（百股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'" , replace as(`fmt')	
					}
					if `r(max)' >= 10000 & `r(max)' < 100000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						qui replace volume = volume/1000
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（千股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'", replace as(`fmt')	
					}
					if `r(max)' >= 100000 & `r(max)' < 1000000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						qui replace volume = volume/10000
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（万股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'", replace as(`fmt')	
					}
					if `r(max)' >= 1000000 & `r(max)' < 10000000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						qui replace volume = volume/100000
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（十万股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'", replace as(`fmt')
					}
					if `r(max)' >= 10000000 & `r(max)' < 100000000{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						qui replace volume = volume/1000000
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（百万股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'" , replace as(`fmt')
					}
					else{
						qui keep if date >= date("`f'", "YMD") & date <= date("`t'", "YMD")
						qui replace volume = volume/10000000
						tw rspike hiprc lowprc date || line clsprc date, xtitle(日期) ytitle("股价-最高价&最低价-收盘价", place(top)) name(hilo, replace) xscale(off) legend(off)
						tw bar volume date, xtitle(日期) ytitle("交易量（千万股）") name(vol, replace) ylabel(#4) fysize(35)
						graph combine hilo vol, cols(1) imargin(b = 0 t = 0)
						graph export "`name'.`fmt'" , replace as(`fmt')
					}
			}
			else{
				disp as error "错误！：你只能选择ps/eps/wmf/emf/pdf/png/tif七种导出图片的格式"
			}
		}		
	}
end
