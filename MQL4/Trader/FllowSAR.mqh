/*
  根据SAR的值进行交易
*/

#include "./FllowBase.mqh";

class FllowSAR : public FllowBase{
	  public:
		bool is_trend_up();
		bool is_trend_down();
		bool can_close();

	  public:
		void check_order();
    bool buy_order_can_close();
    bool sell_order_can_close();
};





bool FllowSAR::buy_order_can_close(){
     bool can_close = false;

     double order_profit_point = Ask - OrderOpenPrice() * 100;
     // 如果没有赚到就不关闭 交由趋势指标SAR自动处理
     double one_dot_margin = MarketInfo(Symbol(),MODE_MARGINREQUIRED);
     // 订单的成本
     double order_margin = one_dot_margin * OrderLots();
     // 订单利润
     double order_ylv = OrderProfit() / order_margin;
     Print("多单= ",order_profit_point, "订单盈利率  = ", order_ylv);
     if(order_ylv > 0.2){
        can_close = true;
     }

     return can_close;
}

bool FllowSAR::sell_order_can_close(){
     bool can_close = false;

     double order_profit_point = (OrderOpenPrice() - Bid) * 100;
   
     double one_dot_margin = MarketInfo(Symbol(),MODE_MARGINREQUIRED);
     // 订单的成本
     double order_margin = one_dot_margin * OrderLots();
     // 订单利润
     double order_ylv = OrderProfit() / order_margin;
     Print("空单 = ", order_profit_point, "订单盈利率  = ", order_ylv);
     if(order_ylv > 0.2){
        can_close = true;
     }

     return can_close;
}
 

bool FllowSAR::is_trend_up(){
     bool is_up = false;
     /*
		 1: 是否可以做多
		   1.1 前一根K线iSAR小于对应的收盘价
		   1.2 前一根K线的前一根K线的iSAR 大于收盘价
		   1.3 当前的K线iSAR 小于开盘价
     */
     double pre_k_sar   	 = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 1);
     double pre_of_pre_k_sar = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 2);
     double cur_k_sar        = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 0);
     double pre_of_pre_close_price = iClose( this.symbol, this.cur_period, 2);
     double pre_of_close_price = iClose( this.symbol, this.cur_period, 1);

     if(pre_k_sar < pre_of_close_price){
     	if(pre_of_pre_k_sar > pre_of_pre_close_price){
     		if(Ask > cur_k_sar){
     			is_up = true;
     		}
     	}
     }
     return is_up;
}


bool FllowSAR::is_trend_down(){
     bool is_down = false;

	/*
		1: 是否可以做多
		   1.1 前一根K线iSAR小于对应的收盘价
		   1.2 前一根K线的前一根K线的iSAR 大于收盘价
		   1.3 当前的K线iSAR 小于开盘价
     */
     double pre_k_sar   	 = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 1);
     double pre_of_pre_k_sar = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 2);
     double cur_k_sar        = iSAR( this.symbol, this.cur_period, 0.02, 0.2, 0);

     double pre_of_pre_close_price = iClose( this.symbol, this.cur_period, 2);
     double pre_of_close_price = iClose( this.symbol, this.cur_period, 1);

     if(pre_k_sar > pre_of_close_price){
     	if(pre_of_pre_k_sar < pre_of_pre_close_price){
     		if(Bid < cur_k_sar){
     			 is_down = true;
     		}
     	}
     }

     return is_down;
}

void FllowSAR::check_order(){
     bool had_same_symbol_order = false;
     int order_count = OrdersTotal();

     bool is_trend_up = this.is_trend_up();
     bool is_trend_down = this.is_trend_down();
     if(order_count > 0){
     	  for(int order_index = 0; order_index < order_count; order_index ++){
     	      OrderSelect( order_index, SELECT_BY_POS,MODE_TRADES);
     	      datetime order_open_time = OrderOpenTime();
            int order_bar_index = iBarShift(this.symbol, this.cur_period, order_open_time,false);
            double order_profit = OrderProfit();
            if(order_bar_index > 1){
            	 string order_symbol = OrderSymbol();
     	        if(order_symbol == this.symbol){
     	      	    had_same_symbol_order = true;
     	      	    int order_type = OrderType();
     	      	    if(order_type == OP_BUY){
     	   	  	       if(is_trend_down){
     	   	  	        int order_ticket = OrderTicket();
                   	  double order_lots = OrderLots();
                     //  OrderClose(order_ticket, order_lots,Bid, 100, Red);
                      had_same_symbol_order = false;
                      int magic_number = TimeSeconds(TimeCurrent());
     			            double min_lots = MarketInfo(this.symbol,  MODE_MINLOT);
                      double stoploss=NormalizeDouble(Ask + 5,Digits);
                      double takeprofit=NormalizeDouble(Ask - 5, Digits);
           		        OrderSend(this.symbol,OP_SELL ,min_lots, Bid, 3, stoploss, takeprofit ,"order_buy", magic_number, 0, Blue);
     	   	  	       }
                     if(this.buy_order_can_close()){
                        int order_ticket = OrderTicket();
                        double order_lots = OrderLots();
                        OrderClose(order_ticket, order_lots,Bid, 100, Red);
                     }
     	      	    }else if(order_type == OP_SELL){
		  	  	         if(is_trend_up){
     	   	           	   int order_ticket = OrderTicket();
                         double order_lots = OrderLots();
                         // OrderClose(order_ticket, order_lots,Ask, 100 , Blue);
                         had_same_symbol_order = false;
                         Print("关闭做空订单 下一个多单");
                         int magic_number = TimeSeconds(TimeCurrent());
     			               double min_lots = MarketInfo(this.symbol,  MODE_MINLOT);
                         double stoploss=NormalizeDouble(Ask + 5,Digits);
                         double takeprofit=NormalizeDouble(Ask - 5, Digits);
          	         	   OrderSend(this.symbol,OP_BUY, min_lots,  Ask, 4 ,stoploss, takeprofit,"order_sell", magic_number,0, Red);
     	   	           }
                     if(this.sell_order_can_close()){
                        int order_ticket = OrderTicket();
                        double order_lots = OrderLots();
                        OrderClose(order_ticket, order_lots,Bid, 100, Red);
                     }
     	            }
              }
            }
          }
     }else{
     // 如果不存在当前交易类别的订单 则开始检查趋势下单

     // if(had_same_symbol_order == false && order_count == 0){
     	int magic_number = TimeSeconds(TimeCurrent());
     	double min_lots = MarketInfo(this.symbol,  MODE_MINLOT);
     	if(is_trend_up){
     	   // 做多单
           Print("正常做了一个多单");
           double stoploss=NormalizeDouble(Ask - 5,Digits);
           double takeprofit=NormalizeDouble(Ask + 5, Digits);
           OrderSend(this.symbol, OP_BUY,min_lots, Ask, Point, stoploss, takeprofit, "正常做了一个多单", 120001, 0, Red );
     	}else if(is_trend_down){
     	   // 做空单
           Print("正常做了一个空单");
           double stoploss=NormalizeDouble(Ask + 5,Digits);
           double takeprofit=NormalizeDouble(Ask - 5, Digits);
           OrderSend(this.symbol, OP_SELL,min_lots, Bid, Point, stoploss,takeprofit, "正常做了一个空单", 120002, 0, Blue );
     	}
       // }
     }
}




