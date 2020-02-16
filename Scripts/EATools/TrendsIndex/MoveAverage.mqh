/**
移动均线的相关策略
1: 向上穿过均线 多头趋势
2: 向下刺破均线 空头趋势
3: 横盘震荡 就考虑空仓操作
*/


class MoveAverage{
      public:
      // 开始上升
      static bool isUP(int period, string symbol, int shiftNumber, double breakValue, int startShift, float offset);
      // 开始下降
      static bool isDown(int period, string symbol, int shiftNumber, double breakValue,int startShift, float offset);
};

/**
  判断均线是否向上
  判断依据
  1: 当前K线的前一根K线的收盘价格大于其平均值
  2: 当前K线开盘价格在均线之上
  3: 当前K线的前几根开线的收盘价格大部分都在均线之下（80% 以上）
  4: 当前K线的前面几根K线大部分都是开盘价格大于收盘价格(80% 以上)
*/

bool MoveAverage::isUP(int period, string symbol, int shiftNumber, double breakValue, int startShift, float offset){
    // 判断1
    double pre_close_price = iClose(symbol,period, startShift +PRICE_CLOSE 1);
    double ima_price = iMA(symbol, period, 13,8,MODE_SMMA, ,startShift + 1);
    bool pre_close_price_more_than_pre_ima = false;
    
    Print(startShift,"pre_close_price = ",pre_close_price, "ima_price ",ima_price );
    if(pre_close_price > ima_price){
        pre_close_price_more_than_pre_ima = true;
    }

    // 判断2
    double cur_open_price = iOpen(symbol, period, startShift);
    double cur_ima = iMA(symbol, period, 13,8,MODE_SMMA, PRICE_MEDIAN,startShift);
    bool cur_open_more_than_cur_ima = false;
    if(cur_open_price > cur_ima){
        cur_open_more_than_cur_ima = true;
    }

    int ma_line_low_count = 0;
    int c_m_t_o_count = 0;

    for(int i = 1; i < shiftNumber; i ++){
        double t_ima_price = iMA(symbol, period, 13,8,MODE_SMMA, PRICE_MEDIAN,startShift + i);
        double t_close_price = iClose(symbol, period, startShift + i);
        double t_open_price = iOpen(symbol, period,startShift + i);

        if(t_close_price < t_ima_price){
            ma_line_low_count ++;
        }

        if(t_close_price > t_open_price){
            c_m_t_o_count ++;
        }
    }


    // 判断3
    bool is_ima_bottom = (ma_line_low_count / shiftNumber) * 100 > offset ? true : false;

    // 判断4
    bool is_c_m_o = (c_m_t_o_count / shiftNumber) * 100 > offset ? true : false;

    Print(startShift," is up ",pre_close_price_more_than_pre_ima, " " ,cur_open_more_than_cur_ima , " " , is_ima_bottom , " " , is_c_m_o );
    return pre_close_price_more_than_pre_ima && cur_open_more_than_cur_ima && is_ima_bottom && is_c_m_o;

}

/**
   判断均线是否向下
   判断依据
   1: 当前K线的前一根K线的收盘价格小于开盘价格 
   2: 当前K线的前几根K线的收盘价格大部分都是都是在平均线之上(80% 以上) 
   3: 当前K线的值小于前一根K线的均线（刺破均线）
*/
bool MoveAverage::isDown(int period, string symbol, int shiftNumber, double breakValue,int startShift, float offset){
    double pre_close_price = iClose(symbol,period, startShift + 1);
    double pre_open_price = iOpen(symbol,period, startShift + 1);

    // 判断1
    bool pre_close_price_smaler_pre_open_price = false;
    if(pre_close_price < pre_open_price){
        pre_close_price_smaler_pre_open_price = true;
    }

    int ma_up_count = 0;

    for(int i = 1; i <= shiftNumber; i ++){
        double t_ima_price = iMA(symbol, period, 13,8,MODE_SMMA, PRICE_CLOSE,startShift + i);
        double t_close_price = iClose(symbol, period, startShift + i);
        Print("k 线的信息 = ",startShift + i, " ", t_close_price, "    ", t_ima_price );
        if(t_close_price > t_ima_price){
            ma_up_count = ma_up_count + 1;
        }
    }

    // 判断2
    double t_offset = (ma_up_count / shiftNumber ) * 100;
    bool is_up_ma = t_offset > offset ? true : false;

    double pre_ima_price = iMA(symbol, period, 13,8,MODE_SMMA, PRICE_MEDIAN,startShift + 1);
    // 判断3
    bool os_break_ma = false;
    if(Ask < pre_ima_price ){
        os_break_ma = true;
    }
    
    
    Print(t_offset," is down msg = ", pre_close_price_smaler_pre_open_price ,"  ", is_up_ma ," " , os_break_ma);
    
    return pre_close_price_smaler_pre_open_price && is_up_ma && os_break_ma;
    
}


