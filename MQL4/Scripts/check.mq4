//+------------------------------------------------------------------+
//|                                                        check.mq4 |
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
   Print("是否是模拟账号：",IsDemo());
   Print("是否连接到服务器",IsConnected());
   Print("当前图标名称",Symbol());
   Print("是否处于测试",IsTesting());
   Print("是否允许交易 ",IsTradeAllowed());
   Print("是否允许交易 ",IsTradeAllowed(Symbol(),PERIOD_CURRENT));
   Print("是否是在虚拟模式",IsVisualMode());
   Print("当前客服端所属公司名称 = ",TerminalCompany());
   Print("当前客服端名称 = ",TerminalName());
   Print("当前客服端允许的目录空间 = ",TerminalPath());
   Print("返回当前交易的信息= ",IsTradeContextBusy());
   Print("当前是否属于优化模式 = ",IsOptimization());
   Print("是否能够调用静态函数 = ",IsLibrariesAllowed());
   Print("是否能运行程序= ",IsExpertEnabled());
   Print("是否能够调用DLL函数",IsDllsAllowed());
   Print("当前市场的PointSize =",Point());
   Print("当前市场的Digits =",Digits());
   Print("当前市场的 Period =",Period());
   
   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH));
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH));
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));
   
   Print("市场IS Stoped",IsStopped());
  }
//+------------------------------------------------------------------+
