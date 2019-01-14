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

    static int macdnumber;


    static bool canSell();
    static bool canBuy();
    static int  smart();
    static int lowerSmart(int period);
    static int uperSmart(int period);
};

// 不同时刻的macd指标决定市场的权重
int BollingerBands::m1qz = 2;
int BollingerBands::m5qz = 1;
int BollingerBands::m15qz = 3;
int BollingerBands::m30qz = 3;
int BollingerBands::h1qz = 2;
int BollingerBands::h4qz = 1;

// macd条数
int BollingerBands::macdnumber = 5;

// false 不能做多
bool BollingerBands::canSell()
{

    return false;
}

// false: 不能做多
bool BollingerBands::canBuy()
{

    return false;
}

// 1看多 0 看空
int BollingerBands::lowerSmart(int period) 
{
    int bidcount = 0;
    int askcount = 0;
    for (int k = 0; k < BollingerBands::macdnumber; k++)
    {
        double imacd1 = iBollingerBands(Symbol(), period, 20, 2, 0, PRICE_LOW, MODE_LOWER, k);
        Print(period, " 分钟线的BollingerBands值 = ", imacd1);
        double imacd2 = iBollingerBands(Symbol(), period, 20, 2, 0, PRICE_LOW, MODE_LOWER, k + 1);
        if (imacd1 < imacd2)
        {
            bidcount++;
        }
        else
        {
            askcount++;
        }
    }

    if (askcount > bidcount)
    {
        Print("升序");
        return 1;
    }
    else
    {
        Print("降序");
        return 0;
    }
}

// 1看多 0 看空
int BollingerBands::uperSmart(int period)
{
    int bidcount = 0;
    int askcount = 0;
    for (int k = 0; k < BollingerBands::macdnumber; k++)
    {
        double iband1 = iBollingerBands(Symbol(), period, 20, 2, 0, PRICE_LOW, MODE_UPPER, k);
        Print(period, " 分钟线的 BAND 值 = ", iband1);
        double iband2 = iBollingerBands(Symbol(), period, 20, 2, 0, PRICE_LOW, MODE_UPPER, k + 1);
        if (iband1 < iband2)
        {
            bidcount++;
        }
        else
        {
            askcount++;
        }
    }

    if (askcount > bidcount)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

// 返回1:buy 0: sell -1 观望
int BollingerBands::smart()
{
    int macdm1sc =  BollingerBands::lowerSmart(PERIOD_M1);
    int macdm5sc =  BollingerBands::lowerSmart(PERIOD_M5);
    int macdm15sc = BollingerBands::lowerSmart(PERIOD_M15);
    int macdm30sc = BollingerBands::lowerSmart(PERIOD_M30);
    int macdmh1sc = BollingerBands::lowerSmart(PERIOD_H1);
    int macdmh4sc = BollingerBands::lowerSmart(PERIOD_H4);

    int bidcount = 0;
    int askcount = 0;
    macdm1sc == 1 ? askcount = askcount + BollingerBands::m1qz : bidcount = bidcount + BollingerBands::m1qz;
    macdm5sc == 1 ? askcount = askcount + BollingerBands::m5qz : bidcount = bidcount + BollingerBands::m5qz;
    macdm15sc == 1 ? askcount = askcount + BollingerBands::m15qz : bidcount = bidcount + BollingerBands::m15qz;
    macdm30sc == 1 ? askcount = askcount + BollingerBands::m30qz : bidcount = bidcount + BollingerBands::m30qz;
    macdmh1sc == 1 ? askcount = askcount + BollingerBands::h1qz : bidcount = bidcount + BollingerBands::h1qz;
    macdmh4sc == 1 ? askcount = askcount + BollingerBands::h4qz : bidcount = bidcount + BollingerBands::h4qz;
    if (askcount > bidcount)
    {
        return 1;
    }
    else if (askcount < bidcount)
    {
        return 0;
    }

    return -1;
}