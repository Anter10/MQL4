
#include "../EATools.mqh"
#include "../Order.mqh"
/* 
    移动均线 (Moving Average)
    移动平均线技术指标显示某一个时间周期内产品的平均价格。当计算移动平均线的时候，是将这个时间周期内产品的价格摊平。由于价格的变化，移动平均线也会增长和降低。
    有四种不同类型的移动平均线: 简单移动平均线 (也被称为算术), 指数移动平均线, 平滑移动平均线 以及 加权移动平均线 。移动平均线可以针对任何连续的数据集进行计算，包括开盘价和收盘价，最高价和最低价，交易量或任何其它指标。还经常用到双重移动平均的情况。
    只有在一种情况下，不同种类的移动平均线会产生相当大的分歧，就是为后期的数据分配不同权重系数的情况。在 简单移动均线情况下, 问题涉及的所有时间周期内的价格权重相等。指数移动均线 和 线性加权移动均线 为后期价格分配更多的权重。
    解释价格平均移动的更普遍方法是就是将其与价格动作相比较。当产品价格上升到其移动平均线之上时，买入信号出现; 当价格回落到移动平均线以下时，我们所得到的是一个卖出信号。
    基于移动平均线的交易系统，并非设计用来在最低点入场，且在峰顶正确离场。它可以根据随后的趋势而动作: 价格抵达底部后尽快买入，并在价格触及峰顶后尽快卖出。
    移动平均线也应用于指标。指标移动平均线的解释类似于价格移动平均线: 如果指标涨过其移动平均线，意味着指标上升走势很可能延续; 如果指标跌过其移动平均线，意味着会持续走低。
    图表上是移动平均线的类型:
    简单移动平均线 (SMA)
    指数移动平均线 (EMA)
    平滑移动平均线 (SMMA)
    线形加权移动平均线 (LWMA)
*/

// 移动平均指标的交易策略
class MoveAverage
{
  public:
    // 盈利多少
    static int ordercount;
    // 盈利多少
    static double takeprofitprice;
    // 止损多少
    static double stopprice;
    // profit
    static double profit;
    // 当前交易手数 始终保持lots手进行交易
    static double lots;
    // 当前是否是停止关闭交易的状态
    static bool stoptrade;
    // 当前是否能做多
    static bool canBuy();
    // 当前是否能做空
    static bool canSell();
    // 关闭当前订单
    static bool closeOrder();
    // 下单
    static bool order();
    // 初始化交易数据
    static void init();
    // 开始交易
    static void startTrade();
};

double MoveAverage::lots = 0.1;
double MoveAverage::stopprice = 120;
double MoveAverage::takeprofitprice = 300;
double MoveAverage::profit = 20;
int MoveAverage::ordercount = 0;
bool MoveAverage::stoptrade = true;

bool MoveAverage::canBuy()
{
    double m1 = iMA(Market::curName(), PERIOD_M1, 10, 8, MODE_SMMA, PRICE_CLOSE, 0);
    double m2 = iMA(Market::curName(), PERIOD_M1, 10, 8, MODE_SMMA, PRICE_CLOSE, 1);

    int more = 0;
    if (Open[1] < m1 && Close[1] > m1)
    {
        more = more + 1;
    }
    if (Open[2] < m2 && Close[2] > m2)
    {
        more = more + 2;
    }

    double m3 = iMA(Market::curName(), PERIOD_M5, 10, 8, MODE_SMMA, PRICE_CLOSE, 0);
    double m4 = iMA(Market::curName(), PERIOD_M5, 10, 8, MODE_SMMA, PRICE_CLOSE, 1);

    if (Open[1] < m3 && Close[1] > m3)
    {
        more = more + 2;
    }
    if (Open[2] < m4 && Close[2] > m4)
    {
        more = more + 1;
    }

    Print("做多权重 = ", more);
    if (more >= 2)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool MoveAverage::canSell()
{
    double m1 = iMA(Market::curName(), PERIOD_M1, 10, 8, MODE_SMMA, PRICE_CLOSE, 0);
    double m2 = iMA(Market::curName(), PERIOD_M1, 10, 8, MODE_SMMA, PRICE_CLOSE, 1);

    int more = 0;
    if (Open[1] > m1 && Close[1] < m1)
    {
        more = more + 1;
    }
    if (Open[2] > m2 && Close[2] < m2)
    {
        more = more + 1;
    }
    double m3 = iMA(Market::curName(), PERIOD_M5, 10, 8, MODE_SMMA, PRICE_CLOSE, 0);
    double m4 = iMA(Market::curName(), PERIOD_M5, 10, 8, MODE_SMMA, PRICE_CLOSE, 1);
    if (Open[1] > m3 && Close[1] < m3)
    {
        more = more + 2;
    }
    if (Open[2] > m4 && Close[2] < m4)
    {
        more = more + 1;
    }
    Print("做空权重 = ", more);
    if (more >= 2)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool MoveAverage::closeOrder()
{
    for (int orderIndex = 0; orderIndex < Order::total(); orderIndex++)
    {
        if (Order::select(orderIndex, SELECT_BY_POS, MODE_TRADES))
        {
            if (Order::profit() >= MoveAverage::profit)
            {
                if (Order::type() == OP_SELL)
                {
                    Order::close(Order::ticket(), Order::lots(), Bid, 4);
                    return true;
                }
                else if (Order::type() == OP_BUY)
                {
                    Order::close(Order::ticket(), Order::lots(), Ask, 4);
                    return true;
                }
            }
        }
    }
    return false;
}

bool MoveAverage::order()
{

    if (MoveAverage::canBuy() == true)
    {
        bool suc = Order::order(Market::curName(), OP_BUY, MoveAverage::lots, Ask, 4, Ask - MoveAverage::stopprice, Ask + MoveAverage::takeprofitprice, "order" + MoveAverage::ordercount, MoveAverage::ordercount);
        if (suc)
        {
            MoveAverage::ordercount++;
        }
        return true;
    }
    else if (MoveAverage::canSell() == true)
    {
        bool suc = Order::order(Market::curName(), OP_SELL, MoveAverage::lots, Bid, 4, Bid - MoveAverage::takeprofitprice, Bid + MoveAverage::stopprice, "order" + MoveAverage::ordercount, MoveAverage::ordercount);
        if (suc)
        {
            MoveAverage::ordercount++;
        }
        return true;
    }
    else
    {
        Print("坐等机会下单");
        return false;
    }
}

void MoveAverage::startTrade()
{
    bool closeorder = MoveAverage::closeOrder();
    Print("订单关闭状态  = ", closeorder, " 订单数量 = ", Order::total());

    if (closeorder == false && Order::total() > 0)
    {
        Print("坐等订单盈利");
    }
    else if (closeorder == true || Order::total() == 0)
    {
        MoveAverage::order();
    }
}
