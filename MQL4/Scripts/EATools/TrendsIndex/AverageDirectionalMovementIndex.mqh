/*
平均定向运动指数 (Average Directional Movement Index)
平均定向运动指数技术指标 (ADX) 有助于判断是否有价格趋势。
它是由 Welles Wilder 开发并在其《技术交易系统中的新概念》一书中介绍的。
基于定向运动系统的最简单交易方法即为比较两条方向指标: 
 1、±DI线的特点
　　（1）当＋DI线位于－DI线的上方，应做多。反之，做空。
　　（2）±DI两线间距越大，说明趋势越强劲。
 2、ADX线的特点
   （1）ADX线位于水平线30以上时，价格波动趋势性更好。
　　（2）ADX线位于水平线25以下时，属于弱趋势。
　　（3）ADX线高于60时，趋势行情可能已经发展到了极端情况，行情随时可能结束，可对前期获利头寸适当减仓。
 3、ADX指标交易法则
    （1）如下图，当＋DI与ADX都位于－DI的上方，并且ADX是上升的，可做多入场。代表上升趋势在增强，建立多头，止损设定在近期回调低点下方。
        当－DI与ADX都位于＋DI的上方，而且ADX上升，可做空入场，止损设定在近期反弹高点上方。
     (2）如下图，当ADX下降时，代表市场逐渐丧失方向感，此时最好不采用顺势交易方法。

    （3）如下图，当ADX下降并且同时低于两条DI线时，代表沉闷的横向走势。
         不可采用顺势交易方法，但应该开始准备，因为这相当于是暴风雨之前的宁静，大趋势经常在此后不久发动。

    （4）如下图，当ADX上升并且同时高于两条DI线，代表行情过热。
         在这种情况下，当ADX向下反转，且位于上方的DI线同步向下时，代表主要的趋势可能发生突变，可以选择获利平仓。

     (5) ADX下降并且同时低于两条DI线，这是趋向系统发出最佳讯号的位置。
         这种情况维持愈久，下一波走势的基础愈稳固。当ADX由两条DI线的下侧位置开始翻升，
         代表行情已经惊醒过来。在这种情况下，如果ADX由底部向上翻升4点（例如：由9到13），
         则宣告新趋势的诞生。当时，如果＋DI位于-DI上方，则做多入场，止损放置在近期回调低点下方；
         如果－DI位于+DI上方，则做空入场，止损放置在近期反弹高点上方。
*/

class AverageDirectionalMovementIndex{
      public:
      static bool isAsk(int period, string symbol, int startShift, int shiftNumber);
      static bool isBid(int period, string symbol, int startShift, int shiftNumber);
};


/**
   是否做多
   判断依据
   1: 当前K线的前一根K线的ADX 和 -DI之间的差值在2 以上
   2: 暂时定为前一根K线的 +DI 和前一根K线处于阶段 【当前K线的前部分根K线的+DI处于上升阶段(80%) 一般为】
   3: 暂时不用[ADX 和 +DI 处于 -DI之上]
*/

bool AverageDirectionalMovementIndex::isAsk(int period, string symbol, int startShift, int shiftNumber){
   double plusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift + 1);
   double minusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_MINUSDI,startShift + 1);
   double mainAdx = iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,startShift + 1);

   double cur_plusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift);
   double cur_minusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_MINUSDI,startShift);
   double cur_mainAdx = iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,startShift);

   // 判断1
   bool is_adx_minus_minusdi_smaller_2 = mainAdx - minusDi >= 2 ? true : false;

   double plusDi1 = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift + 1);
   double plusDi2 = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift + 2);

   // 判断2
   bool pre_plus_di = false;
   if(plusDi1 > plusDi2){
      pre_plus_di = true;
   }

   // 判断3
   bool adx_plus_mt_mdi = true;
//    if(cur_plusDi > cur_minusDi && cur_mainAdx > cur_minusDi){
//       adx_plus_mt_mdi = true;
//    }
   
   return is_adx_minus_minusdi_smaller_2 && pre_plus_di && adx_plus_mt_mdi;
}


/**
   是否做空
   判断依据
   1: 当前K线的前一根K线的+DI处于下降阶段
   2: 暂定为当前K线的前一根K线的-DI处于上升阶段【当前K线的前部分K线的+DI处于下降阶段（80 %）】
   3: 暂时不用[ADX 和 -DI 处于 +DI之上]
*/
bool AverageDirectionalMovementIndex::isBid(int period, string symbol, int startShift, int shiftNumber){
   double plusDi1 = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift + 1);
   double plusDi2 = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift + 2);

   double minusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_MINUSDI,startShift + 1);
   double minusDi2 = iADX(NULL,0,14,PRICE_HIGH,MODE_MINUSDI,startShift + 2);
   double mainAdx = iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,startShift + 1);

   double cur_plusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,startShift);
   double cur_minusDi = iADX(NULL,0,14,PRICE_HIGH,MODE_MINUSDI,startShift);
   double cur_mainAdx = iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,startShift);

   // 判断1
   bool is_plus_di_down = false;
   if(plusDi1 < plusDi2){
       is_plus_di_down = true;
   }

   // 判断2
   bool minus_di_up = false;
   if(minusDi > minusDi2){
      minus_di_up = true;
   }

   // 判断3
   bool m_m_th_pdi = true;
//    if(cur_plusDi < cur_minusDi && cur_plusDi < cur_mainAdx){
//       m_m_th_pdi = true;
//    }

   return is_plus_di_down && m_m_th_pdi && minus_di_up;
}