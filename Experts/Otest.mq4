//+------------------------------------------------------------------+
//|                                                        Otest.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int OnStart()
{
//----
   
//----
   return(0);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     int i;
   string obj_name="label_object";
   long current_chart_id=ChartID();
//--- creating label object (it does not have time/price coordinates)
   if(!ObjectCreate(current_chart_id,obj_name,OBJ_LABEL,0,0,0))
     {
      Print("Error: can't create label! code #",GetLastError());
      return(0);
     }
//--- set color to Red
   ObjectSetInteger(current_chart_id,obj_name,OBJPROP_COLOR,clrRed);
//--- move object down and change its text
   for(i=0; i<200; i++)
     {
      //--- set text property
      ObjectSetString(current_chart_id,obj_name,OBJPROP_TEXT,StringFormat("Simple Label at y= %d",i));
      //--- set distance property
      ObjectSet(obj_name,OBJPROP_YDISTANCE,i);
      //--- forced chart redraw
      ChartRedraw(current_chart_id);
      Sleep(10);
     }
     
    Print( "on start kaishi" );
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
