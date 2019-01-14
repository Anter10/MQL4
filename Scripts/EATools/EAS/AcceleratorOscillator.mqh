#include "../Order.mqh"
#include "../Market.mqh"
// 加速震荡指标

/*
加速振荡器 (Accelerator Oscillator)

价格是变化的最后元素。先于价格变化，市场驱动推力改变其方向，驱动推力的加速度必须减速，并趋于零。此后，开始逆向加速直到价格开始改变其方向。
加速/减速技术指标 (AC) 测量当前驱动推力的加速和减速。该指标在驱动推发生任何变化之前即会改变方向，反过来，其方向变化先于价格变动。如果您能意识到加速/减速是早期预警信号的话，它就会给您带来明显的优势。
零轴基本上是驱动推力加速度的平衡点。如果加速度/减速度大于零，通常加速度会更容易延续向上走势 (反之亦然，当低于零时)。不像 动量震荡器, 零轴的交叉并非信号。若要控制市场并作出决定唯一要做的就是观察颜色的变化。要保存自己的反映，您必须记住：在当前栏是红色时，不能在加速/减速的帮助下购买，并且，当当前栏是绿色时，也不能卖。
如果您顺从驱推动力方向入场 (指标高于零买入，或低于零卖出)，则您买入时只需要两根绿色列 (两根红色列卖出)。如果驱动推力的指向与持仓相反 (指标低于零买入，或高于零卖出)，则需要确认，因此需要额外的列。在这种情况下，对于空头，指标需在零轴之上显示三根红色列，对于多头需在零轴之下显示三根绿色列。
*/

class AcceleratorOscillator{
    public:
      static int m1weight;
      static int m5weight;
      static int m15weight;
      static int m30weight;
      static int h1weight;
      static int h4weight;
      static bool canSell();
      static bool canBuy();
      static int periodSort(int period);
      static int smart();
};

 
int AcceleratorOscillator::m1weight = 1;
int AcceleratorOscillator::m5weight = 2;
int AcceleratorOscillator::m15weight = 3;
int AcceleratorOscillator::m30weight = 3;
int AcceleratorOscillator::h1weight = 2;
int AcceleratorOscillator::h4weight = 1;

int AcceleratorOscillator::smart(){
   int sortacm1 = AcceleratorOscillator::periodSort(PERIOD_M1);
   int sortacm5 = AcceleratorOscillator::periodSort(PERIOD_M5);
   int sortacm15 = AcceleratorOscillator::periodSort(PERIOD_M15);
   int sortacm30 = AcceleratorOscillator::periodSort(PERIOD_M30);
   int sortach1 = AcceleratorOscillator::periodSort(PERIOD_H1);
   int sortach4 = AcceleratorOscillator::periodSort(PERIOD_H4);
   int bidcount = 0;
   int askcount = 0;
   sortacm1 == 1 ? askcount = askcount + AcceleratorOscillator::m1weight : bidcount = bidcount + AcceleratorOscillator::m1weight;
   sortacm5 == 1 ? askcount = askcount + AcceleratorOscillator::m5weight : bidcount = bidcount + AcceleratorOscillator::m5weight;
   sortacm15 == 1 ? askcount = askcount + AcceleratorOscillator::m15weight : bidcount = bidcount + AcceleratorOscillator::m15weight;
   sortacm30 == 1 ? askcount = askcount + AcceleratorOscillator::m30weight : bidcount = bidcount + AcceleratorOscillator::m30weight;
   sortach1 == 1 ? askcount = askcount + AcceleratorOscillator::h1weight : bidcount = bidcount + AcceleratorOscillator::h1weight;
   sortach4 == 1 ? askcount = askcount + AcceleratorOscillator::h4weight : bidcount = bidcount + AcceleratorOscillator::h4weight;
   Print("智能做单情况 = ", "askcount = ", askcount, "bidcount = ", bidcount);
   if (askcount > bidcount){
       Print("当前建议做多");
       return 1;
   }else{
       Print("当前建议做空");
       return 0;
   }
}

// 对某个时间周期中的AC排序
// 对AC k线排序 做空排序 做多排序
/**
 *@param {Int} period K线的周期
*/
int AcceleratorOscillator::periodSort(int period)
{
    int bidcount = 0;
    int askcount = 0;
    for (int k = 0; k < 5; k++)
    {
        double iac1 = iAC(Market::curName(), period, k);
        double iac2 = iAC(Market::curName(), period, k + 1);
        if (iac1 < iac2)
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

bool AcceleratorOscillator::canSell(){
    if (AcceleratorOscillator::smart() == 0){
        return true;
    }
    return false;
}
bool AcceleratorOscillator::canBuy(){
    if (AcceleratorOscillator::smart() == 1){
        return true;
    }
    return false;
}
 