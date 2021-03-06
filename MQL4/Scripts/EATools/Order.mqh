//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


class Order{
   public:
   // 下单
   static bool  order(string symbol,int op, double lot,double price,int slippage,double stoploss, double takeprofit,string orderinfo,int orderid,datetime dt = NULL,color cl = Red);
   // 关闭订单
   static bool  close(int ticket,double lots,double price,int sloppage,color ccolor=clrNONE);
   // 订单总数
   static int   total();
   // 订单的市场名称
   static string  symbol();
   // 订单当前盈利
   static double profit();
   // 订单盈利位置
   static double takeProfit();
   // 订单手数
   static double lots();
   // 得到订单交易类型
   /*
      OP_BUY - buy order,
      OP_SELL - sell order,
      OP_BUYLIMIT - buy limit pending order,
      OP_BUYSTOP - buy stop pending order,
      OP_SELLLIMIT - sell limit pending order,
      OP_SELLSTOP - sell stop pending order.
   */
   static int type();
   // 订单ticket
   static int ticket();
   // 打印订单信息
   static void print();
   // 更改订单信息
   static bool modify(int ticket,double price,double stoploss,double takeprofit,datetime expiration,color arrow_color=clrNONE);
   // 选择订单
   static bool select(int index,int SELECT_BY_POS_OR_SELECT_BY_TICKET,int MODE_HISTORY_OR_MODE_HISTORY);
   // 历史订单总数
   static int hisTotal();
   // 止损点位置
   static double stopLoos();
   // 删除订单
   static bool Delete(int ticket,  color tcolor = clrNONE);
};



// 下单
/*int  OrderSend(
   string   symbol,              // 下单类型 如：HK50
   int      cmd,                 // 操作类型 (OP_BUY: 多单)(OP_BUYLIMIT[下方]:支撑位做多单) (OP_BUYSTOP：阻力位做多单[上方]) (OP_SELL: 空单）(OP_SELLLIMIT:支撑位做空单【下方】) (OP_SELLSTOP:支撑位做空单【上方】)
   double   volume,              // 手数 如：0.1
   double   price,               // 下单价格: ASK：多单 BID：空单
   int      slippage,            // 在开市场单时市场价为的最大允许滑点数。（只对市场单起作用，和挂单无关。）
   double   stoploss,            // 止损价位
   double   takeprofit,          // 止盈价位
   string   comment=NULL,        // "订单文字描述"
   int      magic=0,             // 订单号码
   datetime expiration=0,        // 单子作废时间
   color    arrow_color=clrNONE  // 图标上开仓箭头颜色 （CLR_NONE: 无颜色）
);
*/
  bool Order::order(string symbol,int op, double lot,double price,int slippage,double stoploss, double takeprofit,string orderinfo,int orderid,datetime dt = NULL,color cl = Red){
       int orderticket = OrderSend(symbol,op,lot,price,slippage,stoploss,takeprofit,orderinfo,orderid,dt,cl);
       if(orderticket == -1){
          Print("交易失败 = ",orderticket);
          return false;
       }else{
          Print("交易成功 = ",orderticket);
          return true;
       }
   }
   
   bool Order::close(int ticket,double lots,double price,int sloppage,color ccolor=clrNONE){
        return OrderClose(ticket,lots,price,sloppage,ccolor);
   }
 
   int Order::total(){
       return OrdersTotal();
   }
   
   string Order::symbol(){
       return OrderSymbol();
   }
   
   double Order::profit(){
       return OrderProfit();
   }
   double Order::takeProfit(){
       return OrderTakeProfit();
   }
   double Order::lots(){
       return OrderLots();
   }
   
   int Order::type(){
       return OrderType();
   }
   
   int Order::ticket(){
      return OrderTicket();
   }
   
   void Order::print(){
      OrderPrint();
   }
   
   int Order::hisTotal(){
      return OrdersHistoryTotal();
   }
   
   double Order::stopLoos(){
      return OrderStopLoss();
   }
 
   bool  Order::Delete(int ticket, color tcolor = clrNONE) {
      return OrderDelete(ticket,tcolor);
   }
   

   bool Order::modify(int ticket,double price,double stoploss,double takeprofit,datetime expiration,color arrow_color=clrNONE){
   
        return false;
   }
   // 选择订单
   bool Order::select(int index,int SELECT_BY_POS_OR_SELECT_BY_TICKET,int MODE_HISTORY_OR_MODE_HISTORY){
   
      return false;
   }