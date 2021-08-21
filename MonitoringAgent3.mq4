//+------------------------------------------------------------------+
//|                                             MonitoringAgent3.mq4 |
//|                                                          Linh Vu |
//|           https://www.upwork.com/freelancers/~0170542db0d0988a35 |
//+------------------------------------------------------------------+
#property copyright "Linh Vu"
#property link      "https://www.upwork.com/freelancers/~0170542db0d0988a35"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int INTERVAL_NOTICE_MIN = 15;
int OnInit() {
  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  if (TimeCurrent() <= nextSend) {
    return;
  }
  nextSend = TimeCurrent() + INTERVAL_NOTICE_MIN * 60;

  string msg = StringConcatenate("Equity ", AccountEquity(),
                                 ". Balance ", AccountBalance(),
                                 ". Profit ", AccountProfit(),
                                 ". Total ", OrdersTotal(),
                                 " orders. Free margin ", AccountFreeMargin(),
                                 ". Margin level ", NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2), "%");

  SendNotification(msg);
  Print(msg);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static datetime nextSend = TimeCurrent();
//+------------------------------------------------------------------+
