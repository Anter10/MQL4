//+------------------------------------------------------------------+
//|                                                    Stoch.mq4.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#define MAGICMA  2012046

// stoch 和 包络线 和 资金流动指标的EA


// stoch 和 MFI 包络线 一起决定是否买入时机  包络线决定止损和止盈


input double ask_of_stoch_max = 45; // 做多最高stoch的值
input double ask_of_stoch_min = 40; // 做多最高stoch的值
input double bid_of_stoch_min = 65; // 多空最低stoch的值
input double bid_of_stoch_max = 70; // 多空最低stoch的值


input double ask_stop_profit_of_stoch_max = 65; // 做多最高stoch止盈
input double bid_stop_profit_of_stoch_max = 35; // 做空最低stoch止盈




input double env_offset = 1; // 包络线的偏差
input double base_order_lots = 0.01;// 最小做单手数
input string cur_symbol = "XAUUSD"; // 当前的做单类型

input ENUM_TIMEFRAMES cur_time_frame = PERIOD_M15;       // 所用K线的图表周期

enum BuyType{
   None = 0,// 不做单
   Buy = 1, // 做多单
   Sell = 2,// 做空单
};


// 0 不做单 1 做多单 2做空单
int stoch_order_type(){
  double cur_stoch_signal = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_SIGNAL, 0 );
  double cur_stoch_main = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_MAIN, 0 );
  if(cur_stoch_main > cur_stoch_signal && cur_stoch_main <= ask_of_stoch_max){
      // 满足做多的stoch条件
      double cur_mfi   = iMFI( cur_symbol, cur_time_frame, 14, 0);
      double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
      // 满足资金回收速率的要求 根据当前价格在包络线的相对位置来判读当前是否可以做多
      double cur_env_down_value = iEnvelopes( cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, env_offset, MODE_LOWER, 0);
      return 1;
  }else if(cur_stoch_main < cur_stoch_signal && cur_stoch_main >= bid_of_stoch_min){
      // 满足stoch做空需求
      double cur_mfi = iMFI( cur_symbol, cur_time_frame, 14, 0);
      double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
      // 满足资金流
      double cur_env_upper_value = iEnvelopes(cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, env_offset, MODE_UPPER, 0);
      return 2;
  }

  return 0;
}


// 检查订单的状态 进行订单的关闭处理
void check_order(){
   double cur_stoch_signal = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_SIGNAL, 0 );
   int order_count = OrdersTotal();

   for(int order_pos = 0; order_pos< order_count; order_pos++){
       if(OrderSelect(order_pos,SELECT_BY_POS) == false){
          continue;
       }

       // 判断订单的类型
       int order_type = OrderType();
       int order_ticket = OrderTicket();
       double profit = OrderProfit() > 0;
       datetime date = OrderOpenTime();
       
       int bar_index = iBarShift(cur_symbol,cur_time_frame,date);
       if(order_type == OP_BUY && bar_index >= 4  && profit){
           double cur_stoch_main = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_MAIN, 0 );
           // 增加一个或条件 
           if(cur_stoch_main <=  bid_stop_profit_of_stoch_max || cur_stoch_main >= ask_stop_profit_of_stoch_max){ 
             OrderClose(order_ticket, OrderLots(), Bid, 3, CLR_NONE );
           }
       }else if(order_type == OP_SELL && bar_index >= 4 && profit){ 
           double cur_stoch_main = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_MAIN, 0 );

           if((cur_stoch_main >=  ask_stop_profit_of_stoch_max || cur_stoch_main <= bid_stop_profit_of_stoch_max) ){ //&& cur_stoch_main <= 30
              OrderClose(order_ticket, OrderLots(), Ask, 3, CLR_NONE );
           }
       }
    }
}



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
 
//---
  int order_count = OrdersTotal();
  

  if(order_count== 0){
     int order_type = stoch_order_type();

     Print( "order_type ",order_type );

    if(order_type == 0){
       
    } else if(order_type == 1){
      double cur_env_upper_value = iEnvelopes( cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, 3, MODE_LOW, 0);
      
      int res = OrderSend(cur_symbol,OP_BUY,base_order_lots,Ask, 3, 0, 0 ,"order_buy", MAGICMA, 0, Blue);
    } else if(order_type == 2){
      // double cur_env_upper_value = iEnvelopes( cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, 3, MODE_UPPER, 0);
      // Print("有空单啊");

      int res = OrderSend(cur_symbol,OP_SELL,base_order_lots,Bid, 4 ,0, 0,"order_sell", MAGICMA + 1,0, Red);
    }
  }else{
    check_order();
  }
} 



//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
