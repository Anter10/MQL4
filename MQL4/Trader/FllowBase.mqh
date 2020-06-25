/*
  根据SAR的值进行交易
*/

class FllowBase {
	public:
	// 当前的交易类别的名称
	string symbol;
	// 当前订单的实力
	double force;
	// 当前图标周期
	ENUM_TIMEFRAMES cur_period;
	// EA是否初始化过
	bool inited;
	public:
	// 初始化当前对的交易类别
	void init(string _symbol, ENUM_TIMEFRAMES _cur_period);
	// 检测订单状态
	virtual void check_order();

	public:
	// 上升趋势
	virtual bool is_trend_up();
	// 下降趋势
	virtual bool is_trend_down();
};



void FllowBase::init(string _symbol, ENUM_TIMEFRAMES _cur_period){
	this.symbol = _symbol;
	this.cur_period = _cur_period;
	Print("当前Fllow SAR 的交易类别名称 ", this.symbol);
	this.inited = true;
	this.force = 0;
}

