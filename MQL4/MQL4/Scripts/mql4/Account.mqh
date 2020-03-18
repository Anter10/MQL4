//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


class Account{
      public:
	  /**@description 账号当前的盈利 */
      static double Profit();
	  /**@description 账号的余额（就是 profit 与 净值的和值） */
      static double Balance();
	  /**@description 当前账户的净值 */
      static double Equity();
	  /**@description 当前账户的保证金 */
      static double Margin();
	  /**@description 当前账户的可用保证金 */
      static double FreeMargin();
      /**@decription 保证金水平（账户净值 / 已用保证金）* 100 */
      static double MarginLevel();
      /**@decription 追加保证金水平 */
      static double MarginSoCall();
      /**@decription 保证金止损水平 */
      static double MarginSoSo();
      /**@decription 信用 */
      static double Credit();

      public:
      /**@decription 账号 */
      static int Number();
      /**@decription 账户登陆账号 */
      static int Login();
      /**@decription 账户杠杆数 */
      static int Leverage();
      /**@decription 止损价位的计算模式 */
      static int StopoutMode();
      /**@decription 止损价位的值 */
      static int StopoutLevel();

      public:
      /**@decription 账户所属的公司 */
      static string Company();
      /**@decription 账户货币类型 */
      static string Currency();
      /**@decription 账户名称 */
      static string Name();
      /**@decription 账户服务器名称 */
      static string Server();

      public:
      /**@decription 允许交易 */
      static bool TradeAllowed();
      /**@decription 允许EA交易 */
      static bool TradeExpert();
      /**@decription 是否是模拟账号 */
      static bool IsDemo();
      /**@decription 是否是真实账号 */
      static bool IsReal();
      /**@decription 是否是竞争账号 */
      static bool IsContest();


      public:
      static ENUM_ACCOUNT_TRADE_MODE TradeMode();
 
};

// _______________________ double _________________
static double Account::Profit(){
	return AccountProfit();
}

static double Account::Balance(){
	return AccountBalance();
}

static double Account::Equity(){
	return AccountEquity();
}

static double Account::Margin(){
	return AccountMargin();
}

static double Account::FreeMargin(){
	return AccountFreeMargin();
}

static double Account::MarginLevel(){
	return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
}

static double Account::MarginSoCall(){
	return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
}

static double Account::MarginSoSo(){
	return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
}

static double Account::Credit(){
	return AccountCredit();
}

// _______________________ integer _________________
static int Account::Number(){
	return AccountNumber();
}

static int Account::Login(){
	return AccountInfoInteger(ACCOUNT_LOGIN);
}

static int Account::Leverage(){
	return AccountLeverage();
}

static int Account::StopoutMode(){
	return AccountStopoutMode();
}

static int Account::StopoutLevel(){
	return AccountStopoutLevel();
}

// _______________________ string _________________

static string Account::Name(){
	return AccountName();
}

static string Account::Company(){
	return AccountCompany();
}

static string Account::Currency(){
	return AccountCurrency();
}

static string Account::Server(){
	return AccountServer();
}

// _______________________ bool _________________
static bool Account::TradeAllowed(){
	return AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);
}

static bool Account::TradeExpert(){
	return AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
}

static bool Account::IsDemo(){
	return Account::TradeMode() == ACCOUNT_TRADE_MODE_DEMO;
}

static bool Account::IsReal(){
	return Account::TradeMode() == ACCOUNT_TRADE_MODE_REAL;
}

static bool Account::IsContest(){
	return Account::TradeMode() == ACCOUNT_TRADE_MODE_CONTEST;
}

// _______________________ ENUM_ACCOUN_TRADE_MODE _________________

static ENUM_ACCOUNT_TRADE_MODE Account::TradeMode(){
	return (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
}
