//+------------------------------------------------------------------+
//|                                                        Order.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
// 订单的相关方法

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


bool Order(string symbol,int op, double lot,double price,int slippage,double stoploss, double takeprofit,string orderinfo,int orderid,datetime dt = NULL,color cl = Red){
    int orderticket = OrderSend(symbol,op,lot,price,slippage,stoploss,takeprofit,orderinfo,orderid,dt,cl);
    if(orderticket == -1){
     Print("交易失败 = ",orderticket);
       return false;
    }else{
       Print("交易成功 = ",orderticket);
       return true;
    }
}



void OnStart()
  {
//---
    // Order(Symbol(),OP_SELL,0.1,Bid,1,Ask - 20,Ask + 40,"做多单",120001);
    int total  = OrdersTotal();
    for(int i = 0; i < total; i ++){
        bool ticket = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
        OrderPrint();
    }
    
    Print("当前订单总数 = ",total);
    int histotal = OrdersHistoryTotal();
    Print("历史订单总数 = ",histotal);
    for(int i = 0; i < histotal; i ++){
        bool ticket = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
        OrderPrint();
    }
  }
//+------------------------------------------------------------------+
