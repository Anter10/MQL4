// Fllow 交易规则

/**
   1: 根据分钟线进行策略性交易

**/


class Fllow{
	  public:
	  // 移动均线的周期
	  int ima_move_period;
	  // 移动均线的shift数量
	  int ima_shift_count;

 	  // 下单的最小单位手数
	  float order_min_dot;
	  // 下单的交易类别
	  string symbol;
	  // 当前交易的K线的周期
	  ENUM_TIMEFRAMES cur_period;

	  public:
	  // 初始化交易跟踪交易
	  void init(float order_min_dot, const string symbol, ENUM_TIMEFRAMES cur_period);
	  // 检查开始交易
	  void check();
	  // 判断当前的K线是做多趋势
	  bool is_up_trend(double cur_ma_value);
	  // 判断当前的K线是做空趋势
	  bool is_down_trend(double cur_ma_value);
	  // 判断当前的订单是否止损
	  bool can_close_cur_order(double cur_ima_value);


	  public:
	  // 开始交易
	  static void trade();
	  // 订单的MADIC
	  static int order_magic_number;
};


static int Fllow::order_magic_number = 2020620;

// 开始EA交易
static void Fllow::trade(){

} 


void Fllow::init(float order_min_dot, const string symbol, ENUM_TIMEFRAMES cur_period){
	 this.order_min_dot = order_min_dot;
	 this.symbol = symbol;
	 this.cur_period = cur_period;
	 this.ima_move_period = 10;
	 this.ima_shift_count = 6;
}

void Fllow::check(){
	 Print( "Hello Fllow Init", this.order_min_dot,this.symbol);
     int order_total = OrdersTotal();
     bool had_this_symbol_order = false;

     double cur_ima_value = iMA( this.symbol, this.cur_period, this.ima_move_period, this.ima_shift_count, MODE_SMA,PRICE_CLOSE, 0);

     // 检查当前交易的订单中是否 存在当前跟随的交易类别 如果存在 判断是否需要关闭订单
     for(int i = 0; i < order_total; i ++){
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         string order_symbol = OrderSymbol();
         if(order_symbol == this.symbol){
         	bool can_close = this.can_close_cur_order(cur_ima_value);
         	if(can_close == true){
          	   int order_ticket = OrderTicket();
          	   double order_lots = OrderLots();
         	   if(OrderType() == OP_BUY ){
                  OrderClose(order_ticket, order_lots,Bid, 3, Red);
               }else if(OrderType() == OP_SELL ){
                  OrderClose(order_ticket, order_lots,Ask, 3, Blue);
               }
         	}
         	had_this_symbol_order = true;
            break;
         }
     }

     // 如果不存在当前的交易类别 判断是否这个交易类别是否可以下单
     if(had_this_symbol_order == false){
     	// 判断当前能否下单
     	bool is_up_trend = this.is_up_trend(cur_ima_value);
     	bool is_down_trend = this.is_down_trend(cur_ima_value);

     	double min_lots = MarketInfo(this.symbol,  MODE_MINLOT);
     	if(is_up_trend){
     	   // 做多单
           OrderSend(this.symbol,OP_BUY, min_lots,  Ask, 4 ,0, 0,"order_sell", Fllow::order_magic_number,0, Red);
     	   Fllow::order_magic_number = Fllow::order_magic_number + 1;
     	}else if(is_down_trend){
     	   // 做空单
           OrderSend(this.symbol,OP_SELL ,min_lots, Bid, 3, 0, 0 ,"order_buy", Fllow::order_magic_number, 0, Blue);
     	   Fllow::order_magic_number = Fllow::order_magic_number + 1;
     	}
     }
}

bool Fllow::is_up_trend(double cur_ma_value){
	 bool is_up = false;

	 double pre_close_value = iClose( this.symbol, this.cur_period, 1);
     double pre_open_value = iOpen( this.symbol, this.cur_period, 1);

	 if(Ask > cur_ma_value && (pre_open_value < cur_ma_value ) && pre_close_value > cur_ma_value){
	    is_up = true;
	 }

	 return is_up;
}



bool Fllow::is_down_trend(double cur_ma_value){
	 bool is_down = false;
	 double pre_close_value = iClose( this.symbol, this.cur_period, 1);
     double pre_open_value = iOpen( this.symbol, this.cur_period, 1);
	  if(Bid < cur_ma_value && (pre_open_value > cur_ma_value || pre_open_value < cur_ma_value) && pre_close_value < cur_ma_value){
	 	 	is_down = true;
	 }

	 return is_down;
}


bool Fllow::can_close_cur_order(double cur_ima_value){
	 bool can_close = false;
	 datetime order_open_time = OrderOpenTime();
     int order_bar_index = iBarShift(this.symbol, this.cur_period, order_open_time,false);
     double order_profit = OrderProfit();

     if(order_bar_index > 1){
     	if(order_profit > 0){
     	   // 判断当前的订单类型 根据订单类型判断当前的订单的关闭方式
     	   int order_type = OrderType();
     	   if(order_type == OP_BUY){
     	   	  /*
  				 1: 做多订单的止损方式
  				 	1.1 当前订单在ima的下方
  				 	1.2 当前订单的前一根K线是下降的K线 
  				 	1.3 当前的ASK值小于前一根K线的关闭价格
     	   	  */

     	   	  double pre_close_value = iClose( this.symbol, this.cur_period, 1);
     	   	  double pre_open_value = iOpen( this.symbol, this.cur_period, 1);
     	   	  if(pre_close_value < pre_open_value){
     	   	  	 if(Ask < pre_close_value){
     	   	  	    can_close = true;
     	   	  	 }
     	   	  }

     	   	  if(Ask < cur_ima_value){
     	   	  	 can_close = true;
     	   	  }
     	   }else if(order_type == OP_SELL){
     	   	  /*
   			    2: 做空订单的止损方式
   			       2.1 当前K线在ima上
   			       2.2 当前K线的前一根K线是上升K线
   			       2.3 当前K线BID值大于前一根K线的关闭价格
     	   	  */
     	   	  double pre_close_value = iClose( this.symbol, this.cur_period, 1);
     	   	  double pre_open_value = iOpen( this.symbol, this.cur_period, 1);
     	   	  if(pre_close_value > pre_open_value){
     	   	  	 if(Ask > pre_close_value){
     	   	  	 	can_close = true;
     	   	     }
     	   	  }
 			  if(Bid > cur_ima_value){
     	   	  	 can_close = true;
     	   	  }
     	   }
     	}
     }
     if(order_bar_index > 2){
     	// 如果没有盈利的话

     	int order_type = OrderType();
     	if(order_type == OP_BUY){
     		 bool is_down = is_down_trend(cur_ima_value);
     		if(is_down){
     	       can_close = true;
     	    }
     	}else if(order_type == OP_SELL){
     		 bool is_up = is_up_trend(cur_ima_value);

     		if(is_up){
     	      can_close = true;
     	    }
     	}
     }

     return can_close;
}




