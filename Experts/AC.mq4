//+------------------------------------------------------------------+
//|                                                         ACEA.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

extern int preac = 0;
int count = 0;
int preticketid = 0;
extern int profit = 10;

bool Order(string symbol,int op, double lot,double price,int slippage,double stoploss, double takeprofit,string orderinfo,int orderid,datetime dt = NULL,color cl = Red){
    int orderticket = OrderSend(symbol,op,lot,price,slippage,stoploss,takeprofit,orderinfo,orderid,dt,cl);
    if(orderticket == -1){
     Print("交易失败 = ",orderticket);
       return false;
    }else{
       Print("交易成功 = ",orderticket);
       preticketid = orderticket;
       return true;
    }
}

bool closeOrder(){
     int total = OrdersTotal();
     if(total == 1){
        if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)){
           if(OrderProfit() >= profit){
              return OrderClose(OrderTicket(),OrderLots(),Ask,3,clrAliceBlue);
           }else{
              Print("订单还没有盈利");
              return false;
           }
        }else{
           return true;
        }
     }else{
       return true;
     }
  };
  
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
     bool start =  EventSetTimer(5);
  if(start){
     Print("开始EA成功");
  }else{
     Print("开始EA失败");
  }     
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
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
    Print("行情变化"+preac);
     bool closeor = closeOrder();
     
     if(preac > 0 && iAC(Symbol(),PERIOD_CURRENT,1) > 0){
       
     }else if(preac > 0 && iAC(Symbol(),PERIOD_CURRENT,1) < 0){ // 做空
       preac = iAC(Symbol(),PERIOD_CURRENT,1);
       if(closeror){
          bool suc = Order(Symbol(),OP_SELL,0.1,Ask,2,Ask+250,Ask-200,"做空单",PERIOD_CURRENT,PERIOD_CURRENT);
          if(suc == true){
             count ++;
             Print("第几次做单 = ",count);
          }
       }
      
     }else if(preac < 0 && iAC(Symbol(),PERIOD_CURRENT,1) > 0){ // 做多
       preac = iAC(Symbol(),PERIOD_CURRENT,1);
       count ++;
       if(closeor){
          bool suc = Order(Symbol(),OP_BUY,0.1,Ask,2,Ask-250,Ask+200,"做多单",PERIOD_CURRENT,PERIOD_CURRENT);
          if(suc == true){
             count ++;
             Print("第几次做单 = ",count);
          }
       }
     }
     preac = iAC(Symbol(),PERIOD_CURRENT,1);
     
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
