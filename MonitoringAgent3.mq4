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
input string MONITOR_SYMBOLS = "USTEC_US500";


string symbols[];               // An array to get strings
int num_symbols = 0;
int OnInit() {
  num_symbols = StringSplit(MONITOR_SYMBOLS, StringGetCharacter("_", 0), symbols);

  if (num_symbols > 0) {
    for (int i = 0; i < num_symbols; i++) {
      Print("Added ", symbols[i], " to the monitor list");
    }
  }
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

  string msg = StringConcatenate(AccountProfit()<0?"!!! ":"### ","Equity ", AccountEquity(),
                                 ". Balance ", AccountBalance(),
                                 ". Profit ", AccountProfit(),
                                 ". Total ", OrdersTotal(),
                                 " orders. Free margin ", AccountFreeMargin(),
                                 ". Margin level ", NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), 2), "%");

  notify(msg);
  if (num_symbols > 0) {
    for (int i = 0; i < num_symbols; i++) {
      Sleep(i * 1000);
      msg =  StringConcatenate("- ", symbols[i],
                               " ask ", MarketInfo(symbols[i], MODE_ASK),
                               "\nH-1 ", iClose(symbols[i], PERIOD_H1, 1) > iOpen(symbols[i], PERIOD_H1, 1) ? "up" : "down", 
                                    " (d=", iHigh(symbols[i], PERIOD_H1, 1) - iLow(symbols[i], PERIOD_H1, 1), 
                                    ") High ", iHigh(symbols[i], PERIOD_H1, 1), 
                                    " low ", iLow(symbols[i], PERIOD_H1, 1),
                               "\nH-2 ", iClose(symbols[i], PERIOD_H1, 2) > iOpen(symbols[i], PERIOD_H1, 2) ? "up" : "down", 
                                    " (d=", iHigh(symbols[i], PERIOD_H1, 2) - iLow(symbols[i], PERIOD_H1, 2), 
                                    ") High ", iHigh(symbols[i], PERIOD_H1, 2), 
                                    " low ", iLow(symbols[i], PERIOD_H1, 2));
      notify(msg);
    }
  }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static datetime nextSend = TimeCurrent();
//+------------------------------------------------------------------+
void notify(string msg) {
  SendNotification(msg);
  Print(msg);
}
//+------------------------------------------------------------------+
