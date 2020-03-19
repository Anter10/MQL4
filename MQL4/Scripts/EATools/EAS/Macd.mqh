/*
均线聚散 (MACD)

均线聚合/发散 (MACD) 是趋势追随动态指标。它指明两条价格移动平均线的相关性。
均线聚合/发散 (MACD) 技术指标是 26-周期和 12-周期的指数移动平均线 (EMA) 的差值。为了清晰地展示买入/卖出的机会，一条所谓的信号线 (9-周期指数移动平均线) 绘制在 MACD 图表上。
在宽幅震荡的行情中，MACD 证明非常有效。MACD 有三种流行的运用方法: "交叉"，超买/超卖条件，和背离。
交叉
基本 MACD 交易规则就是当 MACD 下穿信号线时 (死叉) 卖出，类似地，当 MACD 上穿信号线时买入信号产生。当 MACD 在零轴上/下穿越时，买入/卖出也很受欢迎。
超买/超卖条件
MACD 也是一个非常有用的超买/超卖指标。当短期均线急剧偏离长期均线时 (即 MACD 上升)，品种价格有可能过度扩张，且可能很快会回到更为现实的价位上。
背离
当 MACD 与品种背离时，就意味着当前趋势结束的时刻邻近发生。当 MACD 指标创出新高，而价格未创新高时，牛势背离即会产生。当 MACD 指标创出新低时，而此刻价格未能达到新低，熊势背离产生。当这两种背离发生在超买/超卖价位时，它们具有非常重大的意义。
*/

class Macd{
    public:
    static int m1qz;
    static int m5qz;
    static int m15qz;
    static int m30qz;
    static int h1qz;
    static int h4qz;
    
    static int macdnumber;
    
    static int macdSort(int period);
    
    static bool canSell();
    static bool canBuy();
    static int smart();
    
};

// 不同时刻的macd指标决定市场的权重
int Macd::m1qz  = 2;
int Macd::m5qz  = 1;
int Macd::m15qz = 3;
int Macd::m30qz = 3;
int Macd::h1qz  = 2;
int Macd::h4qz  = 1;


// macd条数
int Macd::macdnumber = 5;

// false 不能做多
bool Macd::canSell(){
  
  return false;
}

// false: 不能做多
bool Macd::canBuy(){

   return false;
}

// 1看多 0 看空
int Macd::macdSort(int period){
    int bidcount = 0;
    int askcount = 0;
    for (int k = 0; k < Macd::macdnumber; k++)
    {
        double imacd1 = iMACD(Symbol(),period,12,26,9,PRICE_CLOSE,MODE_MAIN,k);
        Print(period," 当前的MACD值 = ",imacd1);
        double imacd2 = iMACD(Symbol(),period,12,26,9,PRICE_CLOSE,MODE_MAIN,k + 1);
        if (imacd1 < imacd2)
        {
            bidcount ++;
         }else{
            askcount ++;
         }
     }
     
     if (askcount > bidcount) {
         return 1;
     }else{
         return 0;
     }
}



// 返回1:buy 0: sell -1 观望 
int Macd::smart(){
   int macdm1sc = Macd::macdSort(PERIOD_M1);
   int macdm5sc = Macd::macdSort(PERIOD_M5);
   int macdm15sc = Macd::macdSort(PERIOD_M15);
   int macdm30sc = Macd::macdSort(PERIOD_M30);
   int macdmh1sc = Macd::macdSort(PERIOD_H1);
   int macdmh4sc = Macd::macdSort(PERIOD_H4);
   
   int bidcount = 0;
   int askcount = 0;
   
   macdm1sc  == 1 ? askcount = askcount + Macd::m1qz  : bidcount  = bidcount + Macd::m1qz;
   macdm5sc  == 1 ? askcount = askcount + Macd::m5qz  : bidcount  = bidcount + Macd::m5qz;
   macdm15sc == 1 ? askcount = askcount + Macd::m15qz : bidcount  = bidcount + Macd::m15qz;
   macdm30sc == 1 ? askcount = askcount + Macd::m30qz : bidcount  = bidcount + Macd::m30qz;
   
   macdmh1sc == 1 ? askcount = askcount + Macd::h1qz  : bidcount  = bidcount + Macd::h1qz;
   macdmh4sc == 1 ? askcount = askcount + Macd::h4qz  : bidcount  = bidcount + Macd::h4qz;
   Print("智能做单情况 = ", "askcount = ", askcount, "bidcount = ", bidcount);
   if (askcount > bidcount){
       Print("当前建议做多");
       return 1;
   }else if (askcount < bidcount){
       Print("当前建议做空");
       return 0;
   }
   // 不做单
   return -1;
}