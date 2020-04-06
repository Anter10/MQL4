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
input double bid_of_stoch_min = 60; // 多空最低stoch的值

input double offset_env_of_bid = 5; // 包络线做空的偏差
input double offset_env_of_ask = 5; // 包络线做多的偏差

input double offset_of_stoch_ask_max_value = 1; // 根据底部包络线做多的最大偏移量
input double offset_of_stoch_bid_min_value = 1;   // stoch做单的偏移量

input double offset_of_bid_mfi_value = 0.5;   // 做空资金流加快流速偏移量
input double offset_of_ask_mfi_value = 0.5;   // 做多资金流加快流速偏移量

input double offset_bid_stop_lose_value = 3; // 做空止损偏移量(相对包络线的的顶部)
input double offset_ask_stop_lose_value = 3; // 做多止损偏移量
input double offset_bid_stop_proft_value = 3; // 做空的止盈价格偏移量
input double offset_ask_stop_proft_value = 3; // 做多的止盈价格偏移量

input string offset_of_ask_close_order_mfi_value = 0.5;// 关闭做多订单资金流会退的偏移量
input string offset_of_bid_close_order_mfi_value = 0.5;// 关闭做空订单资金流会退的偏移量


input double env_offset = 1; // 包络线的偏差
input double base_order_lots = 0.1;// 最小做单手数
input string cur_symbol = "XAUUSD"; // 当前的做单类型
input ENUM_TIMEFRAMES cur_time_frame = PERIOD_H1;       // 所用K线的图表周期

enum BuyType{
   None = 0,// 不做单
   Buy = 1, // 做多单
   Sell = 2,// 做空单
};


// 0 不做单 1 做多单 2做空单
int stoch_order_type(){
  double cur_stoch_signal = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_SIGNAL, 0 );
  double cur_stoch_main = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_MAIN, 0 );
   
  if(cur_stoch_main > cur_stoch_signal  && cur_stoch_signal <= ask_of_stoch_max){
     // if(cur_stoch_main - cur_stoch_signal >= offset_of_stoch_ask_max_value){
        // 满足做多的stoch条件
        double cur_mfi = iMFI( cur_symbol, cur_time_frame, 14, 0);
        double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
        // if(cur_mfi - upper_mfi){
           // 满足资金回收速率的要求 根据当前价格在包络线的相对位置来判读当前是否可以做多
           double cur_env_down_value =   iEnvelopes( cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, env_offset, MODE_LOWER, 0);
   // Print( "做多单啊2" );
           // if(Ask <= cur_env_down_value + offset_env_of_ask && Ask > cur_env_down_value - offset_env_of_ask){
                // Print( "做多单啊1" );
               
               return 1;
           // }    

        // }
     // }
  }
  else if(cur_stoch_main < cur_stoch_signal  && cur_stoch_signal >= bid_of_stoch_min){
    // 满足stoch做空需求
    // if(cur_stoch_signal - cur_stoch_main >= offset_of_stoch_bid_min_value){
         double cur_mfi = iMFI( cur_symbol, cur_time_frame, 14, 0);
         double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
         // Print( "判断资金是否可以做空单" );
         // if(cur_mfi - upper_mfi >= offset_of_bid_mfi_value){
            // 满足资金流
            double cur_env_upper_value = iEnvelopes( cur_symbol, cur_time_frame, 14, MODE_SMA, 0, PRICE_CLOSE, env_offset, MODE_UPPER, 0);
            // Print(Bid, "cur_env_upper_value - offset_env_of_bid = ",cur_env_upper_value - offset_env_of_bid);
            // if(Bid <= cur_env_upper_value + offset_env_of_bid && Bid > cur_env_upper_value - offset_env_of_bid ){
                // Print( "做空单啊" );
               return 2;
            // }
         // }
     // }
    }

  return 0;
}

// 检查订单的状态 进行订单的关闭处理
void check_order(){
   int order_count = OrdersTotal();
   for(int order_pos = 0; order_pos< order_count; order_pos++){
        if(OrderSelect(order_pos,SELECT_BY_POS) == false){
           continue;
        }
        // 判断订单的类型
        int order_type = OrderType();
        int order_ticket = OrderTicket();
        double cur_stoch_signal = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_SIGNAL, 0 );
        double cur_stoch_main = iStochastic( cur_symbol, cur_time_frame, 5,3,3, MODE_SMA,1, MODE_MAIN, 0 );
      
        datetime order_date = OrderOpenTime();
        datetime cur_bar_date =  iTime( cur_symbol, cur_time_frame,0);
        int order_time_miute = TimeHour( order_date );
        int cur_time_miute = TimeHour( cur_bar_date );


        int order_pass_time = cur_time_miute - order_time_miute;
        // Print("order_date = ",order_date);
        // Print("cur_bar_date = ",cur_bar_date);
        // Print("order_pass_time = ",order_pass_time);


         // if(order_pass_time * 60  > cur_time_frame){
          if(order_type == OP_BUY && OrderProfit() > 0){
              if(cur_stoch_main <= cur_stoch_signal){
                OrderClose(order_ticket, OrderLots(), Bid, 3, CLR_NONE );
              }
              // 做多订单的关闭订单的方式
              // double cur_mfi = iMFI( cur_symbol, cur_time_frame, 14, 0);
              // double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
              // double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 2);
              // if(upper_mfi - cur_mfi >= offset_of_ask_close_order_mfi_value){
              //    OrderClose(order_ticket, OrderLots(), Bid, 3, CLR_NONE );
              // }
          }else if(order_type == OP_SELL  && OrderProfit() >= 0){
              if(cur_stoch_main >= cur_stoch_signal){
                 OrderClose(order_ticket, OrderLots(), Ask, 3, CLR_NONE );
              }
              // // 做多订单的关闭订单的方式
              // double cur_mfi = iMFI( cur_symbol, cur_time_frame, 14, 0);
              // double upper_mfi = iMFI( cur_symbol, cur_time_frame, 14, 1);
              // if(upper_mfi - cur_mfi >= offset_of_bid_close_order_mfi_value){
              //    OrderClose(order_ticket, OrderLots(), Ask, 3, CLR_NONE );
              // }
          }
          // }
        
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
    // Print( "order_type ",order_type );

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
