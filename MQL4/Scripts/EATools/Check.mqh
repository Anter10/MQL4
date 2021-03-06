//+------------------------------------------------------------------+
//|                                                        Check.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


class Check{
    static bool demo();
    static bool connected();
    static string symbol();
    static bool testing();
    static bool allowedTrade();
    static bool visualMode();
}; 

    bool Check::demo(){
         return IsDemo();
    }
    bool Check::connected(){
         return IsConnected();
    }
    string Check::symbol(){
         return Symbol();
    }
    bool Check::testing(){
         return IsTesting();
    }
    bool Check::allowedTrade(){
        return IsTradeAllowed();
    }
    bool Check::visualMode(){
        return IsVisualMode();
    }
 