//+------------------------------------------------------------------+
//|                                                        Grail.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


input double small_lot = 0.1; // small buy lot
input ENUM_TIMEFRAMES time_frame = PERIOD_M1; // timeframe

input string symbol = "HK50";// trade market name


#define MAGICMA  20120601
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
    int order_total = OrdersTotal();
    
    if(order_total > 0){
      for(int i = 0; i < order_total; i ++){
          // if pre bar close price lower order close order
          OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
          datetime order_open_time = OrderOpenTime();
          int order_bar_index = iBarShift(symbol, time_frame, order_open_time,false);
          Print("order_bar_index",order_bar_index);
          int ticket = OrderTicket();
          double profit = OrderProfit();
          bool is_profit = profit > 0;
          if(order_bar_index >= 2){
             double pre_close_price = iClose(symbol, time_frame, 1);
             double pre_open_price = iOpen(symbol, time_frame, 1);
             
             double pre_of_pre_price = iClose(symbol, time_frame, 2);
             double pre_of_pre_open_price = iOpen(symbol, time_frame, 2);
             
             double open_price = OrderOpenPrice();
             
             if(OrderType() == OP_BUY ){
                // if pre bar close price lower pre of pre bar price close and order bar >= 2
                
                if((is_profit && pre_close_price < pre_open_price)){
                   OrderClose(ticket, OrderLots(),Bid, 3, CLR_NONE);
                }
             }else if((is_profit  && pre_close_price > pre_open_price)){
                if(pre_close_price > pre_of_pre_price){
                   OrderClose(ticket, OrderLots(),Ask, 3, CLR_NONE);
                }
             }
          }
         
      }
    }else if(order_total == 0){
    
      double pre_close_price = iClose(symbol, time_frame, 1);
      double pre_open_price = iOpen(symbol, time_frame, 1);
      
      
      if(pre_close_price < pre_open_price && Ask < pre_close_price){
         OrderSend(symbol,OP_SELL ,small_lot,Bid, 3, 0, 0 ,"order_buy", MAGICMA, 0, Blue);
      }else if(pre_close_price > pre_open_price && Bid > pre_close_price){
         OrderSend(symbol,OP_BUY,small_lot,Ask, 4 ,0, 0,"order_sell", MAGICMA + 1,0, Red);
      }
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
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
