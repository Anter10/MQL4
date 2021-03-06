#property copyright "Copyright 2018, Heisekeji."
#property link      "http://www.heisekeji.com"
#property creatime  "create by guoyouchao on 20181110"
#property strict


class Market{
      public:
      // 得到显示的市场总数
      /**
       * @param select 是否是选中的
       */
      static int Total(bool select);
      // 得到市场名称
      static string Name(int pos, bool select);
      // 选择市场 
      static bool Select(string name, bool select);
      // 市场当前做空价
      static bool bidPrice(string name);
      // 市场当前做多价
      static bool askPrice(string name);
      // 市场最小开仓数
      static double Points(string name);
      // 市场点数
      static double dianCha(string name);
      // 市场点差
      static double dianShu(string name);
      // 市场当天最高价
      static double highPrice(string name);
      // 市场当天最低价
      static double lowPrice(string name);
      // 市场名称
      static string curName();
      // 下单最大手数
      static double  maxLot(string name);
};

      // 得到显示的市场总数
      int Market::Total(bool select){
         return SymbolsTotal(select);
      }
      // 得到市场名称
      string Market::Name(int pos, bool select){
         return SymbolName(pos,select);
      }
      
      // 选择市场 
      bool Market::Select(string name, bool select){
         return SymbolSelect(name,select);
      }
      // 市场当前做空价
      bool Market::bidPrice(string name){
         return MarketInfo(Symbol(),MODE_BID);
      }
      // 市场当前做多价
      bool Market::askPrice(string name){
         return MarketInfo(Symbol(),MODE_ASK);
      }
      // 市场最小开仓数
      double Market::Points(string name){
         return  MarketInfo(Symbol(),MODE_POINT);
      }
      // 市场点数
      double  Market::dianCha(string name){
         return MarketInfo(name,MODE_SPREAD);
      }
      // 市场点差
      double Market::dianShu(string name){
         return MarketInfo(name,MODE_DIGITS);
      }
      // 市场当天最高价
      double Market::highPrice(string name){
         return MarketInfo(name,MODE_HIGH);
      }
      // 市场当天最低价
      double Market::lowPrice(string name){
         return MarketInfo(name,MODE_LOW);
      }
      // 市场名称
      string Market::curName(){
         return Symbol();
      }
      // 市场点数
      double  Market::maxLot(string name){
         return MarketInfo(name,MODE_MAXLOT);
      }