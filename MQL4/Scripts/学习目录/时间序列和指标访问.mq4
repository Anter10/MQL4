//+------------------------------------------------------------------+
//|                                                         指标访问.mq4 |
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
   
   // BARS
   Print("Bars 1分钟数量 = ",Bars(Symbol(),PERIOD_M1));
   Print("Bars 5分钟数量 = ",Bars(Symbol(),PERIOD_M5));
   Print("Bars 15分钟数量 = ",Bars(Symbol(),PERIOD_M15));
   Print("Bars 30分钟数量 = ",Bars(Symbol(),PERIOD_M30));
   Print("Bars 1小时数量 = ",Bars(Symbol(),PERIOD_H1));
   Print("Bars 4小时数量 = ",Bars(Symbol(),PERIOD_H4));
   
   // iBars
   Print("iBars 1分钟数量 = ",iBars(Symbol(),PERIOD_M1));
   Print("iBars 5分钟数量 = ",iBars(Symbol(),PERIOD_M5));
   Print("iBars 15分钟数量 = ",iBars(Symbol(),PERIOD_M15));
   Print("iBars 30分钟数量 = ",iBars(Symbol(),PERIOD_M30));
   Print("iBars 1小时数量 = ",iBars(Symbol(),PERIOD_H1));
   Print("iBars 4小时数量 = ",iBars(Symbol(),PERIOD_H4));
   
   // iBarShift
   datetime some_time=D'2018.11.09 9:15';
    int      shift=iBarShift(Symbol(),PERIOD_M1,some_time);
   Print("index of the bar for the time ",TimeToStr(some_time)," is ",shift);
   
   // iClose
   Print("0 分钟线的最后一根的关闭价= ",iClose(Symbol(),PERIOD_M1,0));
   Print("1 分钟线的最后一根的关闭价= ",iClose(Symbol(),PERIOD_M1,1));
   Print("2 分钟线的最后一根的关闭价= ",iClose(Symbol(),PERIOD_M1,2));
   
   // iOpen
   Print("1分钟K线的最后一根倒数第一根的开始价= ",iOpen(Symbol(),PERIOD_M1,0));
   Print("1分钟K线的最后一根倒数第二根的开始价= ",iOpen(Symbol(),PERIOD_M1,1));
   Print("1分钟K线的最后一根倒数第三根的开始价= ",iOpen(Symbol(),PERIOD_M1,2));
   
   // iHigh
   Print("1分钟K线的最后一根倒数第一根的最高价= ",iHigh(Symbol(),PERIOD_M1,0));
   Print("1分钟K线的最后一根倒数第二根的最高价= ",iHigh(Symbol(),PERIOD_M1,1));
   Print("1分钟K线的最后一根倒数第三根的最高价= ",iHigh(Symbol(),PERIOD_M1,2));
    // iLow
   Print("1分钟K线的最后一根倒数第一根的最低价= ",iLow(Symbol(),PERIOD_M1,0));
   Print("1分钟K线的最后一根倒数第二根的最低价= ",iLow(Symbol(),PERIOD_M1,1));
   Print("1分钟K线的最后一根倒数第三根的最低价= ",iLow(Symbol(),PERIOD_M1,2));
   
   // iVolume
   Print("1分钟K线的最后一根倒数第一根的成交量= ",iVolume(Symbol(),PERIOD_M1,0));
   Print("1分钟K线的最后一根倒数第二根的成交量= ",iVolume(Symbol(),PERIOD_M1,1));
   Print("1分钟K线的最后一根倒数第三根的成交量= ",iVolume(Symbol(),PERIOD_M1,2));
   
   
    // iTime
   Print(shift+"K线的开盘时间= ",iTime(Symbol(),PERIOD_M1,shift));
 
   // iHighest 最高偏移量
   int index = iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,5,0);
   
   Print(index," ","最高偏移量 ",High[index]);
   for(int low = 0; low < 5; low++){
      Print("High ",low," ",High[low]);
   } 
   
   
   // iLowest 最低偏移量
   int index1 = iLowest(Symbol(),PERIOD_CURRENT,MODE_HIGH,5,0);
   for(int low = 0; low < 6; low++){
      Print("Low ",low," ",Low[low]);
   }
   Print(index1," ","最低偏移量 ",Low[index1]);
   
     MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),PERIOD_M1,0,10,rates);
   if(copied>0)
     {
      Print("Bars copied: "+copied);
      string format="open = %G, high = %G, low = %G, close = %G, volume = %d";
      string out;
      int size=fmin(copied,10);
      for(int i=0;i<size;i++)
        {
         out=i+":"+TimeToString(rates[i].time);
         out=out+" "+StringFormat(format,
                                  rates[i].open,
                                  rates[i].high,
                                  rates[i].low,
                                  rates[i].close,
                                  rates[i].tick_volume);
         Print(out);
        }
     }
   else Print("Failed to get history data for the symbol ",Symbol());
  }
//+------------------------------------------------------------------+
