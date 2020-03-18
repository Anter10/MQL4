
//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


class Market{
	public:
	/**@description 当天的最低价 */
	static double Low(string symbol);
	/**@description 当天的最高价 */
	static double High(string symbol);
	/**@description 当天最后一次价格变更时间 */
    static double Time(string symbol);
	/**@description 上次出手(做空)的价格 */
	static double Bid(string symbol);
	/**@description 上次传入(做多)的价格 */
	static double Ask(string symbol);
	/**@description 报价货币的点数大小 */
	static double Point(string symbol);
	/**@description 符号价格中小数点后的位数 */
	static double Digits(string symbol);
	/**@description 当前的点差价值 */
	static double Spread(string symbol);
	/**@description 当前止损点 */
	static double StopLevel(string symbol);
	/**@description 基本货币的手数 */
	static double LotSize(string symbol);
	/**@description 存款货币的报价价格 */
	static double TickValue(string symbol);
	/**@description 刻度大小 */
	static double TickSize(string symbol);
	/**@description 买单互换 */
	static double SwapLong(string symbol);
	/**@description 卖买单互换 */
	static double SwapShort(string sumbol);
	/**@description 市场开始日期（通常用于期货） */
	static double Staring(string symbol);
	/**@description 市场到期日（通常用于期货） */
	static double Expiration(string symbol);
	/**@description 最低允许手数 */
	static double MinLot(string symbol);
	/**@description 换手步骤 */
	static double LotStep(string symbol);
	/**@description 最高允许数量 */
	static double MaxLot(string symbol);
	/**@description 掉期计算方法。0-积分；1-使用符号基础货币；2-按利息；3-保证金货币 */
	static double SwapType(string symbol);
	/**@description 利润计算模式 */
	static double ProfitCalcMode(string symbol);
	/**@description 保证金计算模式 */
	static double MaringCalcMode(string symbol);
	/**@description 1手的初始保证金要求 */
	static double MarginInit(string symbol);
	/**@description 维持按1手计算的未结订单保证金 */
	static double MarginMainTenance(string symbol);
	/**@description 计算1手的对冲保证金 */
	static double MarginHedged(string symbol);
	/**@description 开1手交易所需的可用保证金 */
	static double MarginRequired(string symbol);
	/**@description 以点为单位的冻结级别。如果执行价格在冻结级别定义的范围内，则无法修改，取消或关闭订单 */
	static double FreeZelevel(string symbol);
	/**@description  允许使用OrderCloseBy（）关闭指定交易品种上的相反订单 */
	static double CloseByAllowed(string symbol);

};

static double Market::Low(string symbol){
	return MarketInfo(symbol, MODE_LOW);
}

static double Market::High(string symbol){
	return MarketInfo(symbol, MODE_HIGH);
}

static double Market::Time(string symbol){
	return MarketInfo(symbol, MODE_TIME);
}

static double Market::Bid(string symbol){
	return MarketInfo(symbol, MODE_BID);
}

static double Market::Ask(string symbol){
	return MarketInfo(symbol, MODE_ASK);
}

static double Market::Point(string symbol){
	return MarketInfo(symbol, MODE_POINT);
}

static double Market::Digits(string symbol){
	return MarketInfo(symbol, MODE_DIGITS);
}

static double Market::Spread(string symbol){
	return MarketInfo(symbol, MODE_SPREAD);
}

static double Market::StopLevel(string symbol){
	return MarketInfo(symbol, MODE_STOPLEVEL);
}

static double Market::LotSize(string symbol){
	return MarketInfo(symbol, MODE_LOTSIZE);
}


static double Market::TickValue(string symbol){
	return MarketInfo(symbol,MODE_TICKVALUE);
}

static double Market::TickSize(string symbol){
	return MarketInfo(symbol,MODE_TICKSIZE);
}
static double Market::SwapLong(string symbol){
	return MarketInfo(symbol,MODE_SWAPLONG);
}
static double Market::SwapShort(string symbol){
	return MarketInfo(symbol,MODE_SWAPSHORT);
}
static double Market::Staring(string symbol){
	return MarketInfo(symbol,MODE_STARTING);
}
static double Market::Expiration(string symbol){
	return MarketInfo(symbol,MODE_EXPIRATION);
}
static double Market::MinLot(string symbol){
	return MarketInfo(symbol,MODE_MINLOT);
}
static double Market::LotStep(string symbol){
	return MarketInfo(symbol,MODE_LOTSTEP);
}
static double Market::MaxLot(string symbol){
	return MarketInfo(symbol,MODE_MAXLOT);
}
static double Market::SwapType(string symbol){
	return MarketInfo(symbol,MODE_SWAPTYPE);
}
static double Market::ProfitCalcMode(string symbol){
	return MarketInfo(symbol,MODE_PROFITCALCMODE);
}
static double Market::MaringCalcMode(string symbol){
	return MarketInfo(symbol,MODE_MARGINCALCMODE);
}
static double Market::MarginInit(string symbol){
	return MarketInfo(symbol,MODE_MARGININIT);
}
static double Market::MarginMainTenance(string symbol){
	return MarketInfo(symbol,MODE_MARGINMAINTENANCE);
}
static double Market::MarginHedged(string symbol){
	return MarketInfo(symbol,MODE_MARGINHEDGED);
}
static double Market::MarginRequired(string symbol){
	return MarketInfo(symbol,MODE_MARGINREQUIRED);
}
static double Market::FreeZelevel(string symbol){
	return MarketInfo(symbol,MODE_FREEZELEVEL);
}
static double Market::CloseByAllowed(string symbol){
	return MarketInfo(symbol,MODE_CLOSEBY_ALLOWED);
}












