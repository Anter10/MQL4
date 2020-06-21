//+------------------------------------------------------------------+
//|                                                      IBandEA.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

// 5分钟K线下单黄金的EA交易系统需要的参数


#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict



#define MAGICMA  20120319

input double base_order_lots = 0.01; // 基础下单手数
input int beishu = 1; // 手数增加的倍数
input int index_bar_number = 3;// 技术指标检测的条数
input int self_index_bar_number = 10;// 自身技术指标检测的条数
input double high_low_offset = 6;// 高低差距


input int enough_index = 2; // 满足指标的数量

input double max_low_and_high_value = 5;// 前后两根K最大和最小之间的差距 
input double main_middle_line_send_buy_order_min_offset  = 2; // 当前K线的开盘价格在中轨之上 且当前价格大于开盘价格 触发下多单的最小偏移量
input double main_middle_line_send_buy_order_max_offset  = 3; // 当前K线的开盘价格在中轨之上 且当前价格大于开盘价格 触发下多单的最大偏移量
input double main_middle_line_send_sell_order_min_offset = 2; // 当前K线的开盘价格在中轨之下 且当前价格低于开盘价格 触发下空单的最小偏移量
input double main_middle_line_send_sell_order_max_offset = 3; // 当前K线的开盘价格在中轨之下 且当前价格低于开盘价格 触发下空单的最大偏移量
input double buy_order_of_reverse_close_order_offset     = 3; // 多单行情反转止损的偏移量
input double sell_order_of_reverse_close_order_offset    = 3; // 空单行情反转止损的偏移量

input int order_profit_type = 1; // 1: 不贪心
// 贪心算法的当前K线的值和下单价的差值
input double stop_order_profit = 6;                   // 止盈的订单
input string cur_symbol = "XAUUSD";                     // 当前交易类别名称
input ENUM_TIMEFRAMES cur_time_frame = PERIOD_M5;       // 所用K线的图表周期

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   // 先判断订单的数量
   // clearAllOrders();
   Print("进入EA交易");
    Print("当前的ASK = ",Ask);
   Print("当前的Bid = ",Bid);
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


// 判断MACD是否上升
bool macdIsUp(){
     int bar_up_number = 0;
     int bar_down_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double macd_pre_bar_value = iMACD( cur_symbol, cur_time_frame, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, index_bar_number);
         double macd_cur_bar_value = iMACD( cur_symbol, cur_time_frame, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, index_bar_number - 1);
         if(macd_cur_bar_value > macd_pre_bar_value){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }
     
     if(bar_up_number > enough_index){
        return true;
     }else{
        return false;
     }
}

// 判断MACD是否上升
bool macdIsDown(){
     int bar_up_number = 0;
     int bar_down_number = 0;
     for(int i = index_bar_number; i > 0; i --){
         double macd_pre_bar_value = iMACD( cur_symbol, cur_time_frame, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, index_bar_number);
         double macd_cur_bar_value = iMACD( cur_symbol, cur_time_frame, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, index_bar_number - 1);
         if(macd_cur_bar_value < macd_pre_bar_value){
            bar_down_number ++;
         }else{
            bar_up_number ++;
         }
     }
     
     if(bar_down_number > enough_index){
        return true;
     }else{
        return false;
     }
}


bool rviIsUp(){
     int bar_up_number = 0;
     int bar_down_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double rvi_pre_bar_value = iRVI( cur_symbol, cur_time_frame, 12, MODE_SIGNAL, index_bar_number);
         double rvi_cur_bar_value = iRVI( cur_symbol, cur_time_frame, 12, MODE_SIGNAL, index_bar_number - 1);
         if(rvi_cur_bar_value > rvi_pre_bar_value){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }
     
     if(bar_up_number > enough_index){
        return true;
     }else{
        return false;
     }
}

bool rviIsDown(){
     int bar_up_number = 0;
     int bar_down_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double rvi_pre_bar_value = iRVI( cur_symbol, cur_time_frame, 12, MODE_SIGNAL, index_bar_number);
         double rvi_cur_bar_value = iRVI( cur_symbol, cur_time_frame, 12, MODE_SIGNAL, index_bar_number - 1);
         if(rvi_cur_bar_value > rvi_pre_bar_value){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }
     
     if(bar_up_number < enough_index){
        return true;
     }else{
        return false;
     }
}

bool iacIsUp(){
     int bar_up_number = 0;
     int bar_down_number = 0;
     for(int i = index_bar_number; i > 0; i --){
         double iac_pre_bar_value = iAC( cur_symbol, cur_time_frame, index_bar_number);
         double iac_cur_bar_value = iAC( cur_symbol, cur_time_frame, index_bar_number - 1);
         if(iac_pre_bar_value < iac_cur_bar_value){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }
     
     if(bar_up_number > enough_index){
        return true;
     }else{
        return false;
     }
}

bool iacIsDown(){
     int bar_up_number = 0;
     int bar_down_number = 0;
     for(int i = index_bar_number; i > 0; i --){
         double iac_pre_bar_value = iAC( cur_symbol, cur_time_frame, index_bar_number);
         double iac_cur_bar_value = iAC( cur_symbol, cur_time_frame, index_bar_number - 1);
         if(iac_pre_bar_value < iac_cur_bar_value){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }
     
     if(bar_down_number > enough_index){
        return true;
     }else{
        return false;
     }
}

bool curBuyPriceIsNearMax(){
     int bar_up_number = 0;
     int bar_down_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double high_value = iHigh( cur_symbol, cur_time_frame,index_bar_number);
         if(high_value < Ask){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }

     if(bar_up_number > enough_index){
        return true;
     }else{
        return false;
     }
}


bool curSellPriceIsNearMax(){
     int bar_up_number = 0;
     int bar_down_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double low_value = iLow( cur_symbol, cur_time_frame,index_bar_number);
         if(low_value > Ask){
            bar_up_number ++;
         }else{
            bar_down_number ++;
         }
     }

     if(bar_up_number > enough_index){
        return true;
     }else{
        return false;
     }
}


bool preBarIsSell(){
     int sell_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double close_value = iClose( cur_symbol,cur_time_frame, i );
         if(close_value > Ask){
            sell_number ++;
         }
     }

     if(sell_number > enough_index){
       return true;
     }else{
       return false;
     }
}


bool preBarIsBuy(){
     int sell_number = 0;

     for(int i = index_bar_number; i > 0; i --){
         double close_value = iClose( cur_symbol,cur_time_frame, i );
         if(close_value < Ask){
            sell_number ++;
         }
     }

     if(sell_number > enough_index){
       return true;
     }else{
       return false;
     }
}



bool preBarMainIsBuy(){
     int sell_number = 0;

     for(int i = index_bar_number; i > 0; i --){
          double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,index_bar_number);
         if(main_middle_1 < Ask){
            sell_number ++;
         }
     }

     if(sell_number > enough_index){
       return true;
     }else{
       return false;
     }
}



// 判断当前的K线是否向上突破了布林带的中轨
bool UpDirBrokeMainBands(){
   // 2020年3月20号 修改中轨的值为当前K线的值
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,0);
   double cur_price_offset = Ask - main_middle_1;
   double open_price = iOpen( cur_symbol, cur_time_frame, 0 );
   double pre_open_price = iOpen( cur_symbol, cur_time_frame, 1 );
   double pre_close_price = iClose( cur_symbol, cur_time_frame, 1 );

   double open_pricce_15 = iOpen( cur_symbol, PERIOD_M15, 0 );
   double main_middle_15 = iBands(cur_symbol, PERIOD_M15, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);

   // 首先判断当前的买价是否 和前一根K线的移动平均线的差值 这个判断判定当前的K线在中轨之上
   bool is_up_broke = cur_price_offset >= main_middle_line_send_buy_order_min_offset && cur_price_offset <= main_middle_line_send_buy_order_max_offset;
   double rvi = iRVI( cur_symbol, cur_time_frame, 12, MODE_MAIN,0 );
   bool iac_up = iacIsUp();
   bool macd_up = macdIsUp();
   bool rvi_up= rviIsUp();
   bool up_value = curBuyPriceIsNearMax();
   bool is_buy = preBarIsBuy();

   double hight_value = iHighest( cur_symbol, cur_time_frame, MODE_CLOSE, self_index_bar_number, 0 );
   double low_value = iLowest( cur_symbol, cur_time_frame, MODE_CLOSE, self_index_bar_number, 0);

   double high_and_low_offset = hight_value - low_value;
   bool is_not_top = high_and_low_offset < high_low_offset;

   bool up_broke_main_middle = is_up_broke&& Ask > open_price && open_price > pre_open_price && iac_up && rvi >= 0 && macd_up && is_buy;
   return up_broke_main_middle;
}



// 判断当前的K线是否向下突破了布林带的中轨
bool DownDirBrokeMainBands(){
  iBands( str symbol, int timeframe=PERIOD_M1|PERIOD_M5|PERIOD_M15|PERIOD_M30|PERIOD_H1|PERIOD_H4|PERIOD_D1|PERIOD_W1|PERIOD_MN1|0, int period, int deviation, int bands_shift, int applied_price=PRICE_OPEN|PRICE_HIGH|PRICE_LOW|PRICE_CLOSE|PRICE_MEDIAN|PRICE_TYPICAL|PRICE_WEIGHTED, int mode=MODE_UPPER|MODE_LOWER, int shift )
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,0);
   double cur_price_offset = main_middle_1 - Bid;
   double open_price = iOpen( cur_symbol, cur_time_frame, 0 );
   double pre_open_price = iOpen( cur_symbol, cur_time_frame, 1 );

   double main_middle_15 = iBands(cur_symbol, PERIOD_M15, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   double pre_close_price = iClose( cur_symbol, cur_time_frame, 1 );


   // 判断当前是否突破中轨也就是在中轨的下边 
   bool is_down_broke = cur_price_offset >= main_middle_line_send_sell_order_min_offset && cur_price_offset <= main_middle_line_send_sell_order_max_offset;
   double rvi_value = iRVI( cur_symbol, cur_time_frame, 12, MODE_MAIN, 0);
   bool iac_down = iacIsDown();
   bool macd_down = macdIsDown();
   bool rvi_down = rviIsDown();
   bool sell_down= curSellPriceIsNearMax();
   bool is_sell = preBarIsSell();

   double hight_value = iHighest( cur_symbol, cur_time_frame, MODE_CLOSE, self_index_bar_number, 0 );
   double low_value = iLowest( cur_symbol, cur_time_frame, MODE_CLOSE, self_index_bar_number, 0);

   double high_and_low_offset = hight_value - low_value;
   bool is_top = high_and_low_offset > high_low_offset;

   bool down_broke_main_middle = is_down_broke && pre_open_price > open_price && Ask < open_price && iac_down && rvi_value <= 0 && macd_down && sell_down;

   return down_broke_main_middle;
}

// 得到当前做多订单的的防守价格 止损价是下单的时候设置的止损价格  设置止损价后由系统自动给我们止损 需要向下容错 
double BuyOrderStopLosePriceValue(){
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   return NormalizeDouble(main_middle_1 - buy_order_of_reverse_close_order_offset,Digits);
}

// 得到当前做空订单的的防守价格 止损价格设置一次就行了 设置止损价后由系统自动给我们止损
double SellOrderStopLosePriceValue(){
   // 得到当前K线的前一根布林带的中轨的值 然后加上做空止损的偏移量参数 就得到了止损价格 需要向上容错
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   return NormalizeDouble(main_middle_1 + sell_order_of_reverse_close_order_offset, Digits);
}


// 检查做多订单是否盈利并且关闭相依的订单
bool CheckBuyOrderOfProfitCanStop(double order_buy_price){
    if(order_profit_type == 1){
       // 判断当前的值是否和Ima接近
       double ima = iMA( cur_symbol, cur_time_frame, 14, 0, MODE_SMA, PRICE_CLOSE, 0);
       if(Ask < ima){
          return true;
       }
    }
    return false;
}

// 检查做空订单是否盈利并且关闭相依的订单
bool CheckSellOrderOfProfitCanStop(double order_sell_price){
    if(order_profit_type == 1){
       double ima = iMA( cur_symbol, cur_time_frame, 14, 0, MODE_SMA, PRICE_CLOSE, 0);
       if(Bid > ima){
          return true;
       }
    }
    return false;
}


void smartEa(){
  int order_count = OrdersTotal();

   // 下单之前需要检测我们的订单是否只有1手订单
   if(order_count == 0){
     
      bool is_up = UpDirBrokeMainBands();
      if(is_up){
        
         // 开始做多单 做单步骤 1: 获得多单的止损价格 2: 直接下单
         double stop_loss_price = BuyOrderStopLosePriceValue();
         int res = OrderSend(cur_symbol,OP_BUY,beishu * base_order_lots,Ask, 3, 0, 0 ,"", MAGICMA, 0, Blue);
      }else{
         bool is_down = DownDirBrokeMainBands();
         if(is_down){
            // 开始做空单 
            double stop_loss_price = SellOrderStopLosePriceValue();
            int res = OrderSend(Symbol(),OP_SELL,beishu * base_order_lots,Bid,3,0, 0,"", MAGICMA,0, Red);
         }
      }
   }else{
     // 那我们就开始检测我们的订单是否可以止盈了
     for(int order_pos = 0; order_pos< order_count; order_pos++){
        if(OrderSelect(order_pos,SELECT_BY_POS) == false){
           continue;
        }

        // 判断订单的类型
        int order_type = OrderType();
        if(order_type == OP_BUY){
          // 判断当前的订单是否盈利
          double order_profit = OrderProfit();
          int order_ticket = OrderTicket();

          // Print("     ",order_ticket, "  当前空单盈利 = ",  order_profit);
          bool buy_can_stop_profit = CheckBuyOrderOfProfitCanStop(OrderOpenPrice());

          if(buy_can_stop_profit && order_profit > 0){
             // 判断做多是否可以止盈
             OrderClose(order_ticket, OrderLots(), Bid, 3, Blue);
          }else{
             // 当前订单还没有盈利 所以不考虑关闭订单
          }

        }else if(order_type == OP_SELL){
          // 判断做空是否可以止盈
          double order_profit = OrderProfit();
          int order_ticket = OrderTicket();

          // Print("     ",order_ticket, "  当前空单盈利 = ",  order_profit);
          bool sell_can_stop_profit = CheckSellOrderOfProfitCanStop(OrderOpenPrice());

          if(sell_can_stop_profit && order_profit > 0){
              // 如果盈利的话 则判断当前是否可以止盈
              OrderClose(order_ticket, OrderLots(), Ask, 3, Red);
          }else{
             // 如果没有盈利的话 不考虑关闭订单

          }
        }

     }
   }
}


void clearAllOrders(){
   int hstTotal=OrdersHistoryTotal();
   // for(int i=0;i<hstTotal;i++)
   //  {
   //   //---- check selection result
     if(OrderSelect(0,SELECT_BY_POS,MODE_HISTORY)==true){
   //     {
         int order_ticket = OrderTicket();
         OrderDelete(order_ticket, CLR_NONE);
    //    }
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   smartEa();
   // int low_shift = iLowest( cur_symbol, cur_time_frame, MODE_HIGH, 4,0 );
   // int high_shift = iHighest( cur_symbol, cur_time_frame, MODE_HIGH, 4,0 );
   // Print("当前K线的关闭价格 = ",iClose(cur_symbol, cur_time_frame, 0 ));
  
   
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
 