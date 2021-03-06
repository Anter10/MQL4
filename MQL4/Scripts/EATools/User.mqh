 
#property link      "http://www.heisekeji.com"
#property creatime  "create by guoyouchao on 20181110"
#property strict

class User
{
      public:
      // 得到用户的账户结余
      static double getMoney(void);
      // 得到用户的类型盈亏
      static double getProfit(void);
      // 得到用户的名字
      static string getName(void);
      // 得到用户的ID
      static int getId();
      // 得到用户的服务器
      static string getServer();
      // 得到当前账号的货币类型
      static string getCurrency();
      // 得到用户注册的公司名称
      static string getCompany();
      // 得到用户的股本
      static string getEquity();
      // 得到用户可用预付款比例
      static double getCredit();
      // 得到用户剩余预付款
      static double getMargin();
      // 得到用户可用预付款
      static double getMarginFree();
      
 
};

double User::getMoney(){
   return AccountBalance();
}

double User::getProfit(){
   return AccountProfit();
}

string User::getName(){
   return AccountName();
}

int User::getId(){
   return AccountNumber();
}

string User::getServer(){
   return AccountServer();
}

string User::getCurrency(){
   return AccountCurrency();
}

string User::getCompany(){
   return AccountCompany();
}

string User::getEquity(){
   return AccountEquity();
}

double User::getCredit(){
   return AccountCredit();
}

double User::getMargin(){
   return AccountMargin();
}

double User::getMarginFree(){
   return AccountFreeMargin();
}