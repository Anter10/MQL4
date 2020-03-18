//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
//#property indicator_minimum 0
//#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 LightSeaGreen
#property indicator_color3 BlueViolet
#property  indicator_level1 0
//---- input parameters
extern int KPeriod=9;
extern int DPeriod=3;
extern int Slowing=3;
//---- buffers
double Buffer[];
double MainBuffer[];
double SignalBuffer[];
double JBuffer[];
double HighesBuffer[];
double LowesBuffer[];

//----
int draw_begin1=0;
int draw_begin2=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(6);
   SetIndexBuffer(3, HighesBuffer);
   SetIndexBuffer(4, LowesBuffer);
   SetIndexBuffer(5, Buffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, MainBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1, SignalBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2, JBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="KDJ("+KPeriod+","+DPeriod+","+Slowing+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"K");
   SetIndexLabel(1,"D");
   SetIndexLabel(2,"J");
//----
   draw_begin1=KPeriod+Slowing;
   draw_begin2=draw_begin1+DPeriod;
   SetIndexDrawBegin(0,draw_begin1);
   SetIndexDrawBegin(1,draw_begin2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//----
   if(Bars<=draw_begin2) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=draw_begin1;i++) MainBuffer[Bars-i]=0;
      for(i=1;i<=draw_begin2;i++) SignalBuffer[Bars-i]=0;
     }
//---- minimums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double min=1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=Low[k];
         if(min>price) min=price;
         k--;
        }
      LowesBuffer[i]=min;
      i--;
     }
//---- maximums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double max=-1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=High[k];
         if(max<price) max=price;
         k--;
        }
      HighesBuffer[i]=max;
      i--;
     }
//---- %K line
   i=Bars-draw_begin1;
   if(counted_bars>draw_begin1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double sumlow=0.0;
      double sumhigh=0.0;
      sumlow=Close[i]-LowesBuffer[i];
      sumhigh=HighesBuffer[i]-LowesBuffer[i];
      if(sumhigh==0.0) Buffer[i]=100.0;
      else Buffer[i]=sumlow/sumhigh*100;
      i--;
     }
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
      MainBuffer[i]=iMAOnArray(Buffer,Bars,DPeriod,0,MODE_SMMA,i);
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MainBuffer,Bars,Slowing,0,MODE_SMMA,i);
   for(i=0; i<limit; i++)
      JBuffer[i]=3*MainBuffer[i]-2*SignalBuffer[i];
//----
   return(0);
  }
//+------------------------------------------------------------------+


