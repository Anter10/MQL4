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
// 基础下单手数
input double base_order_lots = 0.05; // 基础下单手数

// 当5分钟K线击破中轨(基本指标线)多少下做多单的偏移量 单位默认1美金。
input double break_main_mode_line_of_buy_offset = 1;// 突破中轨多单下单的偏移量  单位美金
// 当5分钟K线击破中轨(基本指标线)多少下做空单的偏移量 单位默认1美金。
input double break_main_mode_line_of_sell_offset = 1;// 突破中轨空单下单的偏移量  单位美金
// 当五分钟K线 在多单的情况下 行情反转多少止损的偏移量 单位为默认1.5美金
input double buy_order_of_reverse_close_order_offset = 1.5; // 多单行情反转止损的偏移量 单位美金
// 当五分钟K线 在空单的情况下 行情反转多少止损的偏移量 单位为默认1.5美金
input double sell_order_of_reverse_close_order_offset = 1.5; // 空单行情反转止损的偏移量 单位美金

// 当前订单的止盈类型类型 1: 不贪心 2: 贪心
input int order_profit_type = 1;// 1: 不贪心 2: 贪心

// 贪心算法的当前K线的值和下单价的差值

// 贪心多单的止盈
input double greedy_profit_close_buy_order_offset = 5; //  贪心多单 当前K线和订单买入价相比的止盈偏移量 单位美金
// 贪心空单的止盈
input double greedy_profit_close_sell_order_offset = 5; // 贪心空单 当前K线和订单买入价相比的止盈偏移量 单位美金


// 不贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
// 不贪心算法的多单当前K线低于前一根K线多少的止盈偏移量 单位美金
input double no_greedy_profit_close_buy_order_lower_pre_k_line_offset = 0.4; // 不贪心 多单低于前几根K线的最高价 止盈偏移量
// 不贪心算法的空单当前K线高于前一根K线多少的止盈偏移量 单位美金
input double no_greedy_profit_close_sell_order_lower_pre_k_line_offset = 0.4; // 不贪心 空单高于前几根K线的最低价 止盈偏移量
// 不贪心在同一根K线的做多订单的止盈偏移量
input double no_greedy_profit_buy_order_when_cur_price_and_highest_offset = 1; // 不贪心做多订单 在同一根K线的最高点和当前价格的止盈偏移量
// 不贪心在同一根K线的做空订单的止盈偏移量
input double no_greedy_profit_sell_order_when_cur_price_and_highest_offset = 1; // 不贪心做空订单 在同一根K线的最高点和当前价格的止盈偏移量


string cur_symbol = "XAUUSD";

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


// 判断当前的K线是否向上突破了布林带的中轨
bool UpDirBrokeMainBands(){
   double main_middle_1 = iBands(cur_symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   double cur_price_offset = Ask - main_middle_1;
   // 首先判断当前的买价是否 和前一根K线的移动平均线的差值
   bool is_up_broke = cur_price_offset >= break_main_mode_line_of_buy_offset;
   // 再判断前一根K线的值的收盘价格是否低于自己的移动平局线
   double pre_k_close_price = iClose( cur_symbol,PERIOD_M5, 1);

   bool upper_k_close_price_is_lower_main_bands_value = false;
   
   if(pre_k_close_price < main_middle_1){
      upper_k_close_price_is_lower_main_bands_value = true;
   }

   bool up_broke = upper_k_close_price_is_lower_main_bands_value && is_up_broke;
   return up_broke;
}


// 判断当前的K线是否向下突破了布林带的中轨
bool DownDirBrokeMainBands(){
   double main_middle_1 = iBands(cur_symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   double cur_price_offset = main_middle_1 - Bid;
   // 判断当前是否突破中轨
   bool is_down_broke = cur_price_offset >= break_main_mode_line_of_sell_offset;
   // 判断前一根的K线收盘价格是否是在中轨的上方
   double pre_k_close_price = iClose( cur_symbol,PERIOD_M5, 1);

   bool pre_k_close_price_is_upper_main_bands_value = false;
   if(pre_k_close_price > main_middle_1){
      pre_k_close_price_is_upper_main_bands_value = true;
   }

   bool down_broke = is_down_broke && pre_k_close_price_is_upper_main_bands_value;
   
   return down_broke;
}

// 得到当前做多订单的的防守价格 止损价是下单的时候设置的止损价格  设置止损价后由系统自动给我们止损 需要向下容错 
double BuyOrderStopLosePriceValue(){
   double main_middle_1 = iBands(cur_symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   return main_middle_1 - buy_order_of_reverse_close_order_offset;
}

// 得到当前做空订单的的防守价格 止损价格设置一次就行了 设置止损价后由系统自动给我们止损
double SellOrderStopLosePriceValue(){
   // 得到当前K线的前一根布林带的中轨的值 然后加上做空止损的偏移量参数 就得到了止损价格 需要向上容错
   double main_middle_1 = iBands(cur_symbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   return main_middle_1 + sell_order_of_reverse_close_order_offset;
}


// 检查做多订单是否盈利并且关闭相依的订单
bool CheckBuyOrderOfProfitCanStop(double order_buy_price){
    if(order_profit_type == 1){
      // 不贪心的算法 贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
      double pre_k_close_value = iClose( cur_symbol,PERIOD_M5, 1);
      double cur_price_offset = pre_k_close_value - Ask;
      bool buy_can_stop_profit = cur_price_offset >= no_greedy_profit_close_buy_order_lower_pre_k_line_offset;
      
      if(buy_can_stop_profit == false){
        // 如果没有产生止盈条件1的话 需要继续往下判断是否在同一根K线上产生止盈
        double cur_highest_price = iHigh( cur_symbol, PERIOD_M5, 0);
        double cur_hightest_and_cur_price_offset = cur_highest_price - Ask;
        buy_can_stop_profit = cur_hightest_and_cur_price_offset >= no_greedy_profit_buy_order_when_cur_price_and_highest_offset;
      }
      return buy_can_stop_profit;
    }else if(order_profit_type == 2){
      // 贪心的算法
      double cur_value_offset = Ask - order_buy_price;
      bool buy_can_stop_profit = cur_value_offset >= greedy_profit_close_buy_order_offset;
    }
    return false;
}

// 检查做空订单是否盈利并且关闭相依的订单
bool CheckSellOrderOfProfitCanStop(double order_sell_price){
    if(order_profit_type == 1){
      // 不贪心的算法 贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
      double pre_k_close_value = iClose( cur_symbol,PERIOD_M5, 1);
      double cur_price_offset = Bid - pre_k_close_value;
      bool sell_can_stop_profit = cur_price_offset >= no_greedy_profit_close_sell_order_lower_pre_k_line_offset;
      // 如果没有产生止盈 则判断当前的K线的最高价格和当前的价格之间的差值是否触发止盈
      if(sell_can_stop_profit == false){
         double cur_lowest_price = iLow( cur_symbol, PERIOD_M5, 0);
         double cur_hightest_and_cur_price_offset = Bid - cur_lowest_price;
         if(cur_hightest_and_cur_price_offset >= no_greedy_profit_sell_order_when_cur_price_and_highest_offset){
            sell_can_stop_profit = true;
         }
      }
      return sell_can_stop_profit;
    }else if(order_profit_type == 2){
      // 贪心的算法
      double cur_value_offset = order_sell_price - Bid;
      bool buy_can_stop_profit = cur_value_offset >= greedy_profit_close_sell_order_offset;
    }
    return false;
}





//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   // 先判断订单的数量
   int order_count = OrdersTotal();

   // 下单之前需要检测我们的订单是否只有1手订单
   if(order_count == 0){
      double stop_loss_price = BuyOrderStopLosePriceValue();
        int res = OrderSend(cur_symbol,OP_BUY,base_order_lots,Ask, 3, 0, 0 ,"", MAGICMA, 0, Blue);
         Print("当前的错误 = ",GetLastError());
      bool is_up = UpDirBrokeMainBands();
      if(is_up){
         Print("从下往上冲破中轨开始做多单");
         // 开始做多单 做单步骤 1: 获得多单的止损价格 2: 直接下单
       
         int res = OrderSend(cur_symbol,OP_BUY,base_order_lots,Ask, 3, stop_loss_price, 0 ,"", MAGICMA, 0, Blue);
         Print("当前的错误 = ",GetLastError());
      }else{
         bool is_down = DownDirBrokeMainBands();
         if(is_down){
            // 开始做空单 
            double stop_loss_price = SellOrderStopLosePriceValue();
            int res=OrderSend(Symbol(),OP_SELL,base_order_lots,Bid,3,stop_loss_price, 0,"", MAGICMA,0, Red);
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
          if(order_profit > 0){
             // 判断做多是否可以止盈
             bool buy_can_stop_profit = CheckBuyOrderOfProfitCanStop(OrderOpenPrice());
             if(buy_can_stop_profit){
                Print("做多单盈利止盈了");
                int order_ticket = OrderTicket();
                OrderClose(order_ticket, base_order_lots, Ask, 3, Blue);
             }
          }else{
             // 当前订单还没有盈利 所以不考虑关闭订单
          }
         
        }else if(order_type == OP_SELL){
          // 判断做空是否可以止盈
          double order_profit = OrderProfit();
          if(order_profit > 0){
              // 如果盈利的话 则判断当前是否可以止盈
              bool sell_can_stop_profit = CheckSellOrderOfProfitCanStop(OrderOpenPrice());
              if(sell_can_stop_profit){
                 Print("做空单盈利止盈了");
                 int order_ticket = OrderTicket();
                 OrderClose(order_ticket, base_order_lots, Bid, 3, Red);
              }
          }else{
             // 如果没有盈利的话 不考虑关闭订单

          }
        }

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
