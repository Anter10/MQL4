//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../MQL4/Scripts/FM/FileManager.mqh"
#include "./../MQL4/Scripts/mql4/Market.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   double mode_low = Market::Low("HK50");
   Print("market mode low = ",mode_low);
   double mode_high = Market::High("HK50");
   Print("market mode high = ", mode_high);
   double time = Market::Time("HK50");
   Print("marke mode time = ", time);
   
   double bid = Market::Bid("HK50");
   Print("mode bid =", bid);

   double ask = Market::Ask("HK50");
   Print("mode ask = ", ask);

   double point = Market::Point("HK50");
   Print("mode point = ",point);

   double digits = Market::Digits("HK50");
   Print("mode digits = ", digits);

   double spread = Market::Spread("HK50");
   Print("mode spread = ", spread);

   double stop_level = Market::StopLevel("HK50");
   Print("mode stop level = ",stop_level);

   double lot_size = Market::LotSize("HK50");
   Print("lot size = ", lot_size);

   double tick_value = Market::TickValue("HK50");
   Print("tick value = ",tick_value);
   
   // Print("StopOut level = ", AccountStopoutLevel());
   // printf("ACCOUNT_Number=  %d",AccountNumber());
   // printf("ACCOUNT_LOGIN =  %d",AccountInfoInteger(ACCOUNT_LOGIN));
   // printf("ACCOUNT_LEVERAGE =  %d",AccountInfoInteger(ACCOUNT_LEVERAGE));
   // bool thisAccountTradeAllowed=AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);
   // bool EATradeAllowed=AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
   // ENUM_ACCOUNT_TRADE_MODE tradeMode=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
   // ENUM_ACCOUNT_STOPOUT_MODE stopOutMode=(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
 
   // printf("ACCOUNT_BALANCE =  %G",AccountInfoDouble(ACCOUNT_BALANCE));
   // printf("ACCOUNT_CREDIT =  %G",AccountInfoDouble(ACCOUNT_CREDIT));
   // printf("ACCOUNT_PROFIT =  %G",AccountInfoDouble(ACCOUNT_PROFIT));
   // printf("ACCOUNT_EQUITY =  %G",AccountInfoDouble(ACCOUNT_EQUITY));
   // printf("ACCOUNT_MARGIN =  %G",AccountInfoDouble(ACCOUNT_MARGIN));
   // printf("ACCOUNT_MARGIN_FREE =  %G",AccountInfoDouble(ACCOUNT_FREEMARGIN));
   // printf("ACCOUNT_MARGIN_LEVEL =  %G",AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
   // printf("ACCOUNT_MARGIN_SO_CALL = %G",AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
   // printf("ACCOUNT_MARGIN_SO_SO = %G",AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
  
   // string data_path = TerminalInfoString(TERMINAL_DATA_PATH);
   // Print("data path = ",data_path);
   // string file_name = "a.txt";
   // int file_handler = FileOpen(file_name, FILE_WRITE |FILE_CSV);
   // Print("file handler", file_handler);
   // Print("file size = ",FileSize(file_handler));
   // if(file_handler<0){
   //    Print("Failed to open the file by the absolute path ",file_name);
   //    Print("Error code ",GetLastError());
   // }else{
   //    FileWrite(file_handler,1,2,3,4,5);
   //    FileWrite(file_handler,1,2,3,4,5);
   //    FileWrite(file_handler,1,2,3,4,5);
   //    FileWrite(file_handler,1,2,3,4,5);
   //    FileClose(file_handler);
   // }
  
 
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
