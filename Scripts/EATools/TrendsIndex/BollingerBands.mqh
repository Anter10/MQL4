/**@description 布林带的策略 
   包括三条线 
   压力线: 上轨
   平均线: 中轨
   支撑线: 下轨

   技术点:
   1: 当K线突破上轨的时候出现超买现象 这个时候需要择机卖出。
   2: 当K线突破支撑线的时候出现超卖现象，这个时候需要择机买入，不过最好不要买进。
   3: 当股价从上往下突破中轨的时候 需要择机做空。
   4: 当股价从下往上突破平均线 需要择机做多。
   5: K线在上轨和平均线之间时 处于上升阶段。
   6: K线在平均线和下轨之间波动时，处于下降状态。
   7: 看布林带的开口大小和方向 开口往上变大 说明股价即将上涨 开口往下变大 股价要下跌了。

*/


/*
布林带 (Bollinger BollingerBands®)
布林带 (BB) 类似于轨道线。唯一的区别在于轨道线的带边线与移动平均线的距离 (%) 是固定的，
而布林带则是采用某个距其的标准偏差数字来绘制。标准偏差是一种波动性测量值，因此布林带调整自身来适应行情状况。
当行情不稳定时，布林带就会放宽，而在稳定期就会收缩。
布林带通常绘制在价格图表上，但也能添加到指标图表。
就像轨道线指标的情况，布林带的阐释基于价格趋于保持在波带的顶部界线和底部界线之间的事实。
布林带指标的一个显著特征就是随着价格的波动，其宽度可变。
在重大价格变化期间 (即，剧烈波动时) 带宽扩大为价格进入留有很多空间。
在平静期，或低波动性期间，带宽收缩保持价格在它们的极限之内。
以下特征是布林带特有的:
由于波动性降低带宽收缩，易于发生价格突变;
如果价格突破上边带，预期当前的趋势会延续;
如果尖顶和深坑超出带宽之后又缩回带宽之内，也许趋势会逆转;
若价格走势始自一条边带线，那么通常会到达相对一侧。
最后的观察对于预测价格指导是有用的。
*/

class BollingerBands
{
  public:
    static int m1qz;
    static int m5qz;
    static int m15qz;
    static int m30qz;
    static int h1qz;
    static int h4qz;

    // 相关的控制器

    // 分析的K线数量
    static int shiftNumber;
    // 穿破的值
    static double breakValue;
    // 涨跌范围
    static double lowAndHighRange;
    
    // 布林带的方向是向上
    static boolean dirIsUp();
    // 布林带的方向是向下
    static boolean dirIsDown();
    // 布林带处于顶部盘整
    static boolean isTopSlice();
    // 布林带处于底部盘整
    static boolean isBottomSlice();
    // 布林带是否开始处于向上反转 多单
    static boolean bottomDirStartUp();
    // 布林带开始向下反转 空单
    static boolean topDirStartDown();
    // 交易决策
    static int  smart();

};


int BollingerBands::shiftNumber = 5;
float BollingerBands::breakValue = 20;
float BollingerBands::lowAndHighRange = 80;

 // 判断依据 K线的最终价格 在平均线 和 上轨道之间 得添加
 boolean BollingerBands::dirIsUp(int period, string symbol, int shiftNumber, double breakValue, int startShift){
    boolean is_up = true;

    for(int shift = startShift; shift < shiftNumber; shift ++){
        double  upper_value = iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_UPPER, shift);
        double  main_value  = iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_MAIN, shift);
        double  close_value = iClose(symbol, period, shift);

        if(close_value + breakValue < main_value){
            is_up = false;
            break;
        }
    }

    return is_up;
 }

 // 判断依据 K值的关闭价格是否在平均线之下 
 boolean BollingerBands::dirIsDown(int period, string symbol, int shiftNumber, double breakValue, int startShift){
    boolean is_down = true;

    for(int shift = startShift; shift < shiftNumber; shift ++){
        double  main_value  = iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_MAIN, shift);
        double  close_value = iClose(symbol, period, shift);

        if(close_value - breakValue > main_value){
            is_down = false;
            break;
        }
    }

    return is_down;
 }

/**
 判断当前是否是在调整阶段
 顶部调整判断依据:
    1: 当前K线的前一根关闭价格小于前1根K的最高价格
    2: 当前K线的前一根的开盘价格小于前1根K线的关闭价格
*/

boolean BollingerBands::isTopSlice(int period, string symbol, int shiftNumber, double breakValue, int startShift){
      boolean is_slice = false;

      for(int shift = startShift; shift < shiftNumber; shift ++){
         double  close_value =  iClose(symbol, period, shift);
         double  pre_close_value = iClose(symbol, period, shift + 1);
         double  open_value = iOpen(symbol, period, shift);
 
         if(close_value + breakValue < pre_close_value){
             is_slice = true;
             break;
         }
 
         if(open_value + breakValue < pre_close_value){
             is_slice = true;
             break;
         }
      }

      return is_slice;
}


/**
 判断当前是否是在调整阶段 
 底部调整判断依据:
   1: 当前K线的前一根K线的收盘价格大于前一根K线的收盘价格
   2: 当前K线的前一根K线的收盘价格大于前一根K线的开盘价格
   3: 当前K线的前一根K线的收盘价格大于前一根K线的最低价格
*/

boolean BollingerBands::isBottomSlice(int period, string symbol, int shiftNumber, double breakValue, int startShift){
      boolean is_slice = false;

      for(int shift = startShift; shift < shiftNumber; shift ++){
         double  close_value =  iClose(symbol, period, shift);
         
         // 判断1
         double  pre_close_value = iClose(symbol, period, shift + 1);
         if(close_value + breakValue > pre_close_value){
             is_slice = true;
             break;
         }
 
         // 判断2
         if(close_value < pre_open_value){
             is_slice = true;
             break;
         }

         // 判断3
         double low_value = iLow(symbol, period, shift + 1);
         if(close_value  > low_value){
             is_slice = true;
             break;
         }
      }

      return is_slice;
}


/**
   判断底部调整完成即将向上的的信号 
   判断依据
   1: 处于底部调整
   2: 当前K线的前1根K线的收盘价格在平均线之上
   3: 当前K线的前1根K线的收盘价格在所有样本K线中大于最低的样本K线值
   4: 并且这个阶段的涨跌幅值不能超过给定的危险值
*/
boolean BollingerBands::bottomDirStartUp(int period, string symbol, int shiftNumber, double breakValue, double lowAndHighRange, int startShift){
    // 判断1
    boolean is_bottom_slice = BollingerBands::isBottomSlice(period, symbol, shiftNumber,  breakValue);
    
    // 判断2
    double  close_value =  iClose(symbol, period, startShift);
    double  main_value  =  iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_MAIN, startShift);
    boolean is_main_upper = false;
    if(close_value > main_value){
        is_main_upper = true;
    }

    // 判断3
    double lowest = iLowest(symbol, period,MODE_LOW, shiftNumber, startShift);
    boolean more_than_low = false;
    if(close_value > lowest){
        more_than_low = true;
    }

    // 判断4
    double highest = iHighest(symbol, period,MODE_LOW, shiftNumber, startShift);
    boolean is_security = false;
    if(highest - lowest < lowAndHighRange){
       is_security = true;
    }

    return is_bottom_slice && is_main_upper && more_than_low && is_security;
}

/**
  判断顶部调整完成 方向即将开始向下。
  判断依据
  1: 是顶部盘整阶段
  2: 当前K线的前一根K线必须处于下轨和中轨之间(注意: 当前的值需要加上容错值)
  3: 当前K线的前一根K线的上轨值开始下降
*/

boolean BollingerBands::topDirStartDown(int period, string symbol, int shiftNumber, double breakValue, double lowAndHighRange, int startShift){
    // 判断1
    boolean is_top_slice = BollingerBands::isTopSlice(period,  symbol,  shiftNumber,  breakValue,  startShift);
    // 判断2
    double  close_value =  iClose(symbol, period, startShift + 1);
    double  main_value  =  iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_MAIN, startShift + 1);
    double  low_value  =  iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_LOW, startShift + 1);
    
    boolean is_between_main_and_low = false;
    if(close_value > low_value && close_value < main_value){
        is_between_main_and_low = true;
    }
    // 判断3
    double  upper_value_1  =  iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_UPPER, startShift + 1);
    double  upper_value_2  =  iBands(symbol, period, 20, 2, 0, PRICE_LOW, MODE_UPPER, startShift + 2sss);
    boolean is_down = false;
    if(upper_value_1 < upper_value_2){
        is_down = true;
    }
    
    return is_top_slice && is_between_main_and_low && is_down;

}


// 返回 1:buy 0: sell -1 观望
int BollingerBands::smart()
{
   
   return 1;
}


