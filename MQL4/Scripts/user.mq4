//+------------------------------------------------------------------+
//|                                                         user.mq4 |
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
/*
   multiple -line comments start with   and end with;
*/

 

void OnStart()
  {
//--- 
     double count = AccountInfoDouble(ACCOUNT_BALANCE);
     printf("用户名称 =  %s",AccountName());
     printf("用户账号 =  %d",AccountNumber());
     printf("用户盈利 =  %G",AccountInfoDouble(ACCOUNT_PROFIT));
     printf("用户结余 =  %G", AccountInfoDouble(ACCOUNT_BALANCE));
     printf("剩余预付款 =  %G",AccountInfoDouble(ACCOUNT_MARGIN));
     printf("可用预付款 =  %G",AccountInfoDouble(ACCOUNT_MARGIN_FREE));
     printf("可用预付款比例 =  %G",AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));    
     printf("追加预付款水平。依据建立的ACCOUNT_MARGIN_SO_MODE，以百分比形式或存入货币形式表示 =  %G",AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
     printf("可用预付款比例 =  %G",AccountInfoDouble(ACCOUNT_CREDIT)); 
     printf("______________________________________________________-\n\n");
     
     printf("Symbol=%s",Symbol());  
     printf("市场最低价= %G",MarketInfo(Symbol(),MODE_LOW));   // 最低价
     printf("市场最高价= %G",MarketInfo(Symbol(),MODE_HIGH));  // 最高价
     printf("市场当前价= %G",MarketInfo(Symbol(),MODE_BID));   // bid: 报价
     printf("市场做空价= %G",MarketInfo(Symbol(),MODE_ASK));   // 做空价
     printf("最低购买手数=%G",MarketInfo(Symbol(),MODE_POINT));// 最低购买手数
     
      Print("最新接收到的tick(最新的价位)的时间 (最新知道的服务器时间)= ",(MarketInfo(Symbol(),MODE_TIME)));// 最后已知的服务器时间
      Print("在货币对价格中小数点后小数位数。对于当前货币对，它被保存在预定义变量 Digits 中=",MarketInfo(Symbol(),MODE_DIGITS));
      Print("当前点差值 =",MarketInfo(Symbol(),MODE_SPREAD));
      Print("止损位置与入场价格之间的最小点数差距 =",MarketInfo(Symbol(),MODE_STOPLEVEL));
      Print("基本货币批量=",MarketInfo(Symbol(),MODE_LOTSIZE));
      Print("一手每点该货币的价值=",MarketInfo(Symbol(),MODE_TICKVALUE));
      Print("当前品种报价每一跳的大小=",MarketInfo(Symbol(),MODE_TICKSIZE)); 
      Print("看涨仓位掉期=",MarketInfo(Symbol(),MODE_SWAPLONG));
      Print("卖空仓位掉期=",MarketInfo(Symbol(),MODE_SWAPSHORT));
      Print("交易开始日期 =",MarketInfo(Symbol(),MODE_STARTING));
      Print("交易开始日期 =",MarketInfo(Symbol(),MODE_EXPIRATION));
      Print("市场是否允许交易=",MarketInfo(Symbol(),MODE_TRADEALLOWED));
      Print("允许交易的最小手数=",MarketInfo(Symbol(),MODE_MINLOT));
      Print("交易手数的最小增量=",MarketInfo(Symbol(),MODE_LOTSTEP));
      Print("允许交易的最大手数=",MarketInfo(Symbol(),MODE_MAXLOT));
      Print("掉期计算方法=",MarketInfo(Symbol(),MODE_SWAPTYPE)); // 0 - in点;1 -在符号基础货币中;2 -利息;3 -保证金货币
      Print("利润计算方式=",MarketInfo(Symbol(),MODE_PROFITCALCMODE)); // 0 -外汇;1 - CFD(差价合约);2 -期货
      Print("保证金计算模式=",MarketInfo(Symbol(),MODE_MARGINCALCMODE)); // 0 -外汇;1 - CFD(差价合约);2 -期货;3 - CFD指数
      Print("1标准手的初始保证金需求=",MarketInfo(Symbol(),MODE_MARGININIT));
      Print("维持开仓1标准手的保证金 =",MarketInfo(Symbol(),MODE_MARGINMAINTENANCE));
      Print("1标准手的对冲保证金 =",MarketInfo(Symbol(),MODE_MARGINHEDGED));
      Print("要求买1标准手的保证金余额 =",MarketInfo(Symbol(),MODE_MARGINREQUIRED));
      Print("冻结订单的点位。如果执行价出现在冻结订单的点位范围内，订单将不能被修改会、取消或平仓 =",MarketInfo(Symbol(),MODE_FREEZELEVEL)); 
      Print("交易类型总量",SymbolsTotal(true));
      Print("交易类型名称",SymbolName(0,true));
      
      //--- int a = Order();
      
      closeOrder();
  }
//+------------------------------------------------------------------+
