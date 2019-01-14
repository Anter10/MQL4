/*
平均定向运动指数 (Average Directional Movement Index)
平均定向运动指数技术指标 (ADX) 有助于判断是否有价格趋势。
它是由 Welles Wilder 开发并在其《技术交易系统中的新概念》一书中介绍的。
基于定向运动系统的最简单交易方法即为比较两条方向指标: 
14-周期 +DI 和14-周期 -DI。为此，要把指标图表之一置于另一个上面，或者从 -DI 里减去 +DI 。
W.Wilder 建议当 +DI 高于 -DI 时买入，而 +DI 低于 -DI 时卖出。
对于这些简单的交易规则, Wells Wilder 加入了 "极值点规则"。
用来清除错误的信号减少交易量。根据极值点规则，“极值点”就是+DI 和 -DI互相交叉的点。
如果 +DI 升起高于-DI，那么一天中最大价格值的点它们像交叉。
如果+DI 低于-DI，该点在最小价格值的点交叉。
极值点用作入场价位。因此，买入信号之后 (+DI 高于 -DI) 必须等待价格超过极值点，只有在那时才可以买入。
然而，如果价格下跌超过极值点价位，需要保留空头持仓。
*/

class AverageDirectionalMovement{
    static int m1qz;
    static int m5qz;
    static int m15qz;
    static int m30qz;
    static int h1qz;
    static int h4qz;

    static int adxnumber;

    static bool canSell();
    static bool canBuy();
    static int smart();
    static int plusDI(int period);
    static int smart();
};

int AverageDirectionalMovement::m1qz = 1;
int AverageDirectionalMovement::m5qz = 2;
int AverageDirectionalMovement::m15qz = 3;
int AverageDirectionalMovement::m30qz = 3;
int AverageDirectionalMovement::h1qz = 2;
int AverageDirectionalMovement::h4qz = 1;

int AverageDirectionalMovement::adxnumber = 5;

bool AverageDirectionalMovement::canSell(){

    return false;
}
bool AverageDirectionalMovement::canBuy(){

    return false;
}
int AverageDirectionalMovement::smart(){

    return -1;
}
int AverageDirectionalMovement::plusDI(int period){
    int askcount = 0;
    int bidcount = 0;
    for (int iadxindex = 0; iadxindex < AverageDirectionalMovement::adxnumber; iadxindex ++){
        double adx1 = iADX(Symbole(), period, 14, PRICE_HIGH, MODE_PLUSDI, iadxindex); // DI+
        double adx2 = iADX(Symbole(), period, 14, PRICE_HIGH, MODE_MINUSDI, iadxindex); // DI+
        if(adx1 > adx2){
            askcount ++;
        }else{
            bidcount ++;
        }
    }
    
    if(askcount > bidcount){
        return 1;
    }else if(bidcount > askcount){
        return 0;
    }

    return -1;
}
int AverageDirectionalMovement::smart(){
     
    return -1;
}