//+------------------------------------------------------------------+
//|                                                      MarketI.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
   Print("Symbol=",Symbol());
   Print("今天最高价 = ",MarketInfo(Symbol(),MODE_LOW));
   Print("今天最低价 = ",MarketInfo(Symbol(),MODE_HIGH));
   Print("最近的报价时间 = ",(MarketInfo(Symbol(),MODE_TIME)));
   Print("最近的做空价格 = ",MarketInfo(Symbol(),MODE_BID));
   Print("最近的做多价格 = ",MarketInfo(Symbol(),MODE_ASK));
   Print("报价货币的点数大小 =",MarketInfo(Symbol(),MODE_POINT));
   Print("符号价格中小数点后的位数计数 = " ,MarketInfo(Symbol(),MODE_DIGITS));
   Print("点差价值 = ",MarketInfo(Symbol(),MODE_SPREAD));
   Print("止损点 = ",MarketInfo(Symbol(),MODE_STOPLEVEL));
   Print("基本货币的手数 = ",MarketInfo(Symbol(),MODE_LOTSIZE));
   Print("存款货币的报价价格 = ",MarketInfo(Symbol(),MODE_TICKVALUE));
   Print("刻度大小 = ",MarketInfo(Symbol(),MODE_TICKSIZE)); 
   Print("买单互换 = ",MarketInfo(Symbol(),MODE_SWAPLONG));
   Print("卖单互换 = ",MarketInfo(Symbol(),MODE_SWAPSHORT));
   Print("市场开始日期（通常用于期货） = ",MarketInfo(Symbol(),MODE_STARTING));
   Print("市场到期日（通常用于期货） = ",MarketInfo(Symbol(),MODE_EXPIRATION));
   Print("该符号允许交易 = ",MarketInfo(Symbol(),MODE_TRADEALLOWED));
   Print("最低允许数量 = ",MarketInfo(Symbol(),MODE_MINLOT));
   Print("换手步骤 = ",MarketInfo(Symbol(),MODE_LOTSTEP));
   Print("最大允许数量 = ",MarketInfo(Symbol(),MODE_MAXLOT));
   Print("掉期计算方法。0-积分；1-使用符号基础货币；2-按利息；3-保证金货币 = ",MarketInfo(Symbol(),MODE_SWAPTYPE));
   Print("利润计算模式。0-外汇；1-差价合约; 2-期货 = ",MarketInfo(Symbol(),MODE_PROFITCALCMODE));
   Print("保证金计算模式。0-外汇；1-差价合约; 2-期货；3-指数差价合约 =",MarketInfo(Symbol(),MODE_MARGINCALCMODE));
   Print("1手的初始保证金要求 = ",MarketInfo(Symbol(),MODE_MARGININIT));
   Print("维持按1手计算的未结订单保证金 = ",MarketInfo(Symbol(),MODE_MARGINMAINTENANCE));
   Print("计算1手的对冲保证金 = ",MarketInfo(Symbol(),MODE_MARGINHEDGED));
   Print("开1手交易所需的可用保证金 = ",MarketInfo(Symbol(),MODE_MARGINREQUIRED));
   Print("以点为单位的冻结级别。如果执行价格在冻结级别定义的范围内，则无法修改，取消或关闭订单 = ",MarketInfo(Symbol(),MODE_FREEZELEVEL)); 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
