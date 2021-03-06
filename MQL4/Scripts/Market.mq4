//+------------------------------------------------------------------+
//|                                                       Market.mq4 |
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
void OnStart()
  {
//---
    double vbid    = MarketInfo(Symbol(),MODE_BID);
   double vask    = MarketInfo(Symbol(),MODE_ASK);
   double vpoint  = MarketInfo(Symbol(),MODE_POINT);
   int    vdigits = (int)MarketInfo(Symbol(),MODE_DIGITS);
   int    vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   Print("做空价  = ",vbid);
   Print("做多价  = ",vask);
   Print("最小开仓数  = ",vpoint);
   Print("点数  = ",vdigits);
   Print("点差  = ",vspread);
   
   Print("当前打开的市场总量 = ",SymbolsTotal(true));
   Print("当前交易商的总量 = ",SymbolsTotal(false));
  }
//+------------------------------------------------------------------+
