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
input double base_order_lots = 0.01; // 基础下单手数

input double main_middle_line_send_buy_order_min_offset  = 0.4; // 当前K线的开盘价格在中轨之上 且当前价格大于开盘价格 触发下多单的最小偏移量
input double main_middle_line_send_buy_order_max_offset  = 0.6; // 当前K线的开盘价格在中轨之上 且当前价格大于开盘价格 触发下多单的最大偏移量

input double main_middle_line_send_sell_order_min_offset = 0.4; // 当前K线的开盘价格在中轨之下 且当前价格低于开盘价格 触发下空单的最小偏移量
input double main_middle_line_send_sell_order_max_offset = 0.6; // 当前K线的开盘价格在中轨之下 且当前价格低于开盘价格 触发下空单的最大偏移量

input double break_main_mode_line_of_buy_offset          = 0.4; // 突破中轨直接下多单的偏移量
input double break_main_mode_line_of_sell_min_offset     = 0.4; // 突破中轨直接下空单的偏移量

input double buy_order_of_reverse_close_order_offset     = 0.6; // 多单行情反转止损的偏移量
input double sell_order_of_reverse_close_order_offset    = 0.6; // 空单行情反转止损的偏移量

input int order_profit_type = 1; // 1: 不贪心 2: 贪心 （只涉及到止盈的方式）

// 贪心算法的当前K线的值和下单价的差值

// 贪心多单的止盈偏移量
input double greedy_profit_close_buy_order_offset = 1; //  贪心多单 当前K线和订单买入价相比的止盈偏移量 单位美金
// 贪心空单的止盈偏移量
input double greedy_profit_close_sell_order_offset = 1; // 贪心空单 当前K线和订单买入价相比的止盈偏移量 单位美金


// 不贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
// 不贪心算法的多单当前K线低于前一根K线多少的止盈偏移量 单位美金
input double no_greedy_profit_close_buy_order_lower_pre_k_line_offset = 0.4; // 不贪心 多单低于前几根K线的最高价 止盈偏移量
// 不贪心算法的空单当前K线高于前一根K线多少的止盈偏移量 单位美金
input double no_greedy_profit_close_sell_order_lower_pre_k_line_offset = 0.4; // 不贪心 空单高于前几根K线的最低价 止盈偏移量
// 不贪心在同一根K线的做多订单的止盈偏移量
input double no_greedy_profit_buy_order_when_cur_price_and_highest_offset = 1; // 不贪心做多订单 在同一根K线的最高点和当前价格的止盈偏移量
// 不贪心在同一根K线的做空订单的止盈偏移量
input double no_greedy_profit_sell_order_when_cur_price_and_highest_offset = 1; // 不贪心做空订单 在同一根K线的最高点和当前价格的止盈偏移量


input string cur_symbol = "XAUUSD";                     // 当前交易类别名称
input ENUM_TIMEFRAMES cur_time_frame = PERIOD_M5;       // 所用K线的图表周期
input int check_shift_lowest_or_hightest_bar_shift = 3; // 检查最低点和最高点到的K线数量

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
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   double cur_price_offset = Bid - main_middle_1;
   double pre_k_open_price = iOpen( cur_symbol, cur_time_frame, 1);
   double cur_k_open_price = iOpen( cur_symbol, cur_time_frame, 0);

   // 首先判断当前的买价是否 和前一根K线的移动平均线的差值 这个判断判定当前的K线在中轨之上
   bool is_up_broke = cur_price_offset >= break_main_mode_line_of_buy_offset;

   // 下面这段逻辑是个触发了突破信号
   // 判断这根K线的开开盘价格是否在中轨之下 或者 前一根K线是否在中轨之下
   bool open_is_lower_main_middle =  cur_k_open_price <= main_middle_1;
   // 判断这根K线的前一根开盘价格是否在中轨之下
   bool pre_k_open_is_lower_main_middle = pre_k_open_price <= main_middle_1;
   bool is_up_broke_sign = open_is_lower_main_middle || pre_k_open_is_lower_main_middle;
   if(is_up_broke_sign == false){
      // 如果突破信号没有产生 那么判断当前的K线是否在中轨之上并且和前一根K线的中轨值有一定的距离
      bool open_price_than_main_middle = cur_k_open_price >= main_middle_1;
      bool cur_price_than_main_middle_line_offset = Ask - main_middle_1;
      // 这里需要做一个区间 如果没有在这个区间内是不能下单的
      if(cur_price_than_main_middle_line_offset > main_middle_line_send_buy_order_min_offset && cur_price_than_main_middle_line_offset < main_middle_line_send_buy_order_max_offset){
         is_up_broke_sign = true;
      }
   }

   bool up_broke_main_middle = is_up_broke && is_up_broke_sign;


   return up_broke_main_middle;
}


// 判断当前的K线是否向下突破了布林带的中轨
bool DownDirBrokeMainBands(){
   double main_middle_1 = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
   double cur_price_offset = main_middle_1 - Ask;
   // 判断当前是否突破中轨也就是在中轨的下边 
   bool is_down_broke = cur_price_offset >= break_main_mode_line_of_sell_min_offset;

   // 判断这根K线的开盘价格是否在中轨的上方
   double pre_k_open_price = iOpen( cur_symbol, cur_time_frame, 1);
   double cur_k_open_price = iOpen( cur_symbol, cur_time_frame, 0);

   bool cur_k_open_price_is_middle_upper =  cur_k_open_price >= main_middle_1;
   bool pre_k_open_price_is_midele_upper =  pre_k_open_price >= main_middle_1;
   
   bool is_down_broke_sign = cur_k_open_price_is_middle_upper || pre_k_open_price_is_midele_upper;

   // 如果没有触发做空信号 需要判断当前是否是在
   if(is_down_broke_sign == false){
      // 判断当前的K线的开盘价格是否在中轨的下方 并且在给定的区间内 
      double open_price_and_cur_bid_price_offset = main_middle_1 - Bid;
      // 这里还需要判断一下
      if(open_price_and_cur_bid_price_offset > main_middle_line_send_sell_order_min_offset && open_price_and_cur_bid_price_offset <= main_middle_line_send_sell_order_max_offset){
         is_down_broke_sign = true;  
         // Print(open_price_and_cur_bid_price_offset," 向下穿透这里进来了 ",is_down_broke_sign);
      }
   }


   // Print( "cur_k_open_price_is_middle_upper = ", cur_k_open_price_is_middle_upper , "pre_k_open_price_is_midele_upper = ",pre_k_open_price_is_midele_upper);

   bool down_broke_main_middle = is_down_broke && is_down_broke_sign;

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
      // 不贪心的算法 贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
      double pre_k_close_value = iClose( cur_symbol,cur_time_frame, 0);
      double cur_price_offset = pre_k_close_value - Ask;
      bool buy_can_stop_profit = cur_price_offset >= no_greedy_profit_close_buy_order_lower_pre_k_line_offset;
      
      if(buy_can_stop_profit == false){
        int max_high_value_shift = iHighest( cur_symbol, cur_time_frame, MODE_HIGH, check_shift_lowest_or_hightest_bar_shift, 0);
        // 如果没有产生止盈条件1的话 需要继续往下判断是否在同一根K线上产生止盈
        double cur_highest_price = iHigh( cur_symbol, cur_time_frame, max_high_value_shift);
        double cur_hightest_and_cur_price_offset = cur_highest_price - Ask;
        buy_can_stop_profit = cur_hightest_and_cur_price_offset >= no_greedy_profit_buy_order_when_cur_price_and_highest_offset;
      }
      return buy_can_stop_profit;
    }else if(order_profit_type == 2){
      // 贪心的算法
      // 判断当前K线的值和中轨是否接近止盈偏移量的值
      double bands_value = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
      double cur_value_offset = Ask - bands_value;

      bool buy_can_stop_profit = cur_value_offset < greedy_profit_close_buy_order_offset;
      return buy_can_stop_profit;
    }
    return false;
}

// 检查做空订单是否盈利并且关闭相依的订单
bool CheckSellOrderOfProfitCanStop(double order_sell_price){
    if(order_profit_type == 1){
      // 不贪心的算法 贪心的止盈方式 当前K线的值低于前一根K线的收盘价多少后开始止盈
      double pre_k_close_value = iClose( cur_symbol,cur_time_frame, 0);
      double cur_price_offset = Bid - pre_k_close_value;
      bool sell_can_stop_profit = cur_price_offset >= no_greedy_profit_close_sell_order_lower_pre_k_line_offset;
      // 如果没有产生止盈 则判断当前的K线的最高价格和当前的价格之间的差值是否触发止盈
      if(sell_can_stop_profit == false){
         int low_est_shift_value = iLowest( cur_symbol, cur_time_frame, MODE_LOW, check_shift_lowest_or_hightest_bar_shift, 0);
         double cur_lowest_price = iLow( cur_symbol, cur_time_frame, low_est_shift_value);
         double cur_hightest_and_cur_price_offset = Bid - cur_lowest_price;
         if(cur_hightest_and_cur_price_offset >= no_greedy_profit_sell_order_when_cur_price_and_highest_offset){
            sell_can_stop_profit = true;
         }
      }
      return sell_can_stop_profit;
    }else if(order_profit_type == 2){
      // 贪心的算法
      double bands_value = iBands(cur_symbol, cur_time_frame, 20, 2, 0, PRICE_CLOSE, MODE_MAIN,1);
      double cur_value_offset = bands_value - Bid;
      bool sell_can_stop_profit = cur_value_offset >= greedy_profit_close_sell_order_offset;
      return sell_can_stop_profit;
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
         int res = OrderSend(cur_symbol,OP_BUY,base_order_lots,Ask, 3, stop_loss_price, 0 ,"", MAGICMA, 0, Blue);
       Print("往上冲破中轨开始做多单",GetLastError());
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
   // Print("最近三根K线中价值最高的那根K线 = ",high_shift, " 最低的那根线 = ",low_shift);
   
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
