//+------------------------------------------------------------------+
//|                                              SignalIncidator.mq5 |
//|                                      Copyright 2022, JavadSarlak |
//|                                          https://www.teamtext.ir |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input string channel="@fxsod_learn";
input string ticketNum="#TKS_";
input urlMain="www.developerjavad.ir";
input string lang="fa";

string newDeal="^NewDeal^";
string newDealPending="^NewDealPending^";
string closeDeal="^CloseDeal^";
string removeDeal="^RemoveDeal^";
string updateDealPending="^UpdatePendingOrder^";
string updateDeal="^UpdateTP_Sl_Order^";
string sellLimit="^SellLimit^";
string sellMarket="^SellMarket^";
string sellStop="^SellStop^";
string buyLimit="^BuyLimit^";
string buyMarket="^BuyMarket^";
string buyStop="^BuyStop^";
string atPrice="^PriceEntry^";
string atTP="^Tp^";
string atSL="^SL^";
string profitOrLoss="^Profit_Loss^";
string dw="@@";
string dealResultSl="^StopOrder^";
string dealResultTP="^Tp_Order^";
string orderType="^OrderType^";
string urlMain="www.developerjavad.ir";
string descriptions="^description^";

double priceEntry;
double priceTrigger;
double priceSl=0;
double priceTp=0;
double profitDeal;
string buy="^buy^";
string sell="^sell^";
string stoploss="^stop^";
string target="^target^";
string pendingOrder="^pending^";
string updateOrder="^update^";
string marketOrder="^market^";
string newOrderSTK="^new^";
string symbolOrder="^symbol^";
string liner="----------------"+dw;


#include <internetlib.mqh>

string Server[]; // array of server names
double Long[], Short[]; // array of swap information
MqlNet INet; // instance the class for working

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SendData(string message,string file, string mode)
  {
   string smb=Symbol();
   string Head="Content-Type: application/x-www-form-urlencoded"; // header
   string Path="/api/meta.php";
   string Data="channel="+channel+"&message="+message;

   tagRequest req; // initialization of parameters
   if(mode=="GET")
      req.Init(mode, Path+"?"+Data, Head, "",  false, file, true);
   if(mode=="POST")
      req.Init(mode, Path,     Head, Data, false, file, true);

   return(INet.Request(req)); // send the request to the server
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sendPm(string message)
  {
   if(!INet.Open("www.developerjavad.ir", 80, "", "", INTERNET_SERVICE_HTTP))
      return ;

   string file=NULL;

   if(!SendData(message,file, "GET"))
     {
      Print("-err Send data");
      return ;
     } // send swaps
   INet.Close();

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {

   resultTrade(trans,request);

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resultTrade(const MqlTradeTransaction &trans,const MqlTradeRequest &request)
  {

   ulong newest_deal_ticket = trans.deal;
   HistoryDealSelect(newest_deal_ticket);

// Read deal properties
// List of Deal Properties: https://www.mql5.com/en/docs/constants/tradingconstants/dealproperties#enum_deal_property_integer
   static bool sentDeal=false;

   long position_ID           = HistoryDealGetInteger(newest_deal_ticket, DEAL_POSITION_ID);
   long order_ticket          = HistoryDealGetInteger(newest_deal_ticket, DEAL_ORDER);
   long deal_magic            = HistoryDealGetInteger(newest_deal_ticket, DEAL_MAGIC);
   int int_deal_magic         = (int)deal_magic;
   datetime transaction_time  = (datetime)HistoryDealGetInteger(newest_deal_ticket,DEAL_TIME);
   ulong deal_reason          = HistoryDealGetInteger(newest_deal_ticket, DEAL_REASON);
   ulong deal_type            = HistoryDealGetInteger(newest_deal_ticket, DEAL_TYPE);
   ulong deal_entry            = HistoryDealGetInteger(newest_deal_ticket, DEAL_ENTRY);
   double deal_price          = HistoryDealGetDouble(newest_deal_ticket, DEAL_PRICE);


   double deal_profit         = HistoryDealGetDouble(newest_deal_ticket, DEAL_PROFIT);

   string symbol              = HistoryDealGetString(newest_deal_ticket, DEAL_SYMBOL);
   double volume              = HistoryDealGetDouble(newest_deal_ticket, DEAL_VOLUME);
   double commission          = HistoryDealGetDouble(newest_deal_ticket, DEAL_COMMISSION);
   double swap                = HistoryDealGetDouble(newest_deal_ticket, DEAL_SWAP);




   if(trans.price!=0.0)
     {
      priceEntry=trans.price;
     }
   if(trans.price_sl!=0.0)
     {
      priceSl=trans.price_sl;
     }
   if(trans.price_tp!=0.0)
     {
      priceTp=trans.price_tp;
     }
   if(trans.type==TRADE_TRANSACTION_DEAL_ADD)
     {
      profitDeal=deal_profit;
     }
   if(trans.price_trigger!=0)
     {
      priceTrigger=trans.price_trigger;
     }

   static ulong ticket=0;
   ulong LatestTicket = PositionGetTicket(PositionsTotal()-1);


   
   if(trans.type==TRADE_TRANSACTION_POSITION || trans.type==TRADE_TRANSACTION_ORDER_UPDATE)
     {
      if(trans.price_tp==0.0)
        {
         priceTp=0.0;
        }
      if(trans.price_sl==0.0)
        {
         priceSl=0.0;
        }
     }

   if((deal_reason == DEAL_REASON_SL))
     {
      //--- Ticket is PositionID

      sendPm(
         stoploss+dealResultSl+stoploss+dw +liner
         +orderType+dw
         +orderTypeToSTR((request.type),true)+dw +liner
         +symbolOrder+symbol + request.symbol+symbolOrder+dw  +liner
         +atSL+priceSl+dw
         +atTP+priceTp+dw +liner
         +profitOrLoss+profitDeal+dw +liner
         +ticketNum+position_ID
         +dw+liner+descriptions
      );

     }
   else
      if((deal_reason == DEAL_REASON_TP))
        {
         sendPm(
            target+dealResultTP+target+dw +liner
            +orderType+dw
            +orderTypeToSTR((request.type),true)+dw +liner
            +symbolOrder+symbol + request.symbol+symbolOrder+dw  +liner
            +atSL+priceSl+dw
            +atTP+priceTp+dw +liner
            +profitOrLoss+profitDeal+dw +liner
            +ticketNum+position_ID
            +dw+liner+descriptions
         );

        }
      else
        {

         //--- Vaghti deal_ADD mishe etefagh miofte MARKET
         //--- Vaghti order_ADD mishe etefagh miofte limit

         switch(trans.type)
           {
            case TRADE_TRANSACTION_REQUEST:     // sending a trade request
               if(request.action==TRADE_ACTION_DEAL)
                 {
                  if(sentDeal)
                    {
                     if(request.position==0)
                       {

                        sendPm(

                           newOrderSTK+newDeal+newOrderSTK+dw +liner
                           +orderType+dw
                           +orderTypeToSTR((request.type),false)+dw +liner
                           +symbolOrder+request.symbol+symbolOrder+dw  +liner
                           +atPrice+priceEntry+dw
                           +atTP+priceTp+dw
                           +atSL+priceSl+dw +liner
                           +ticketNum+request.order
                           +dw+liner+descriptions
                        );
                       }
                     else
                       {


                        sendPm(
                           updateOrder+closeDeal+updateOrder+dw   +liner
                           +orderType+dw
                           +orderTypeToSTR((request.type),true)+dw +liner
                           +symbolOrder+request.symbol+symbolOrder+dw   +liner
                           +atPrice+priceEntry+dw
                           +atTP+priceTp+dw
                           +atSL+priceSl+dw +liner
                           +profitOrLoss+profitDeal +dw +liner
                           +ticketNum+request.position
                           +dw+liner+descriptions
                        );
                       }

                    }
                 }
               if(request.action==TRADE_ACTION_SLTP)
                 {

                  sendPm(
                     updateOrder+updateDeal+updateOrder+dw +liner
                     +orderType+dw
                     +orderTypeToSTR((request.type),false)+dw+liner
                     +symbolOrder+request.symbol+symbolOrder+dw +liner
                     +atPrice+priceEntry+dw
                     +atTP+priceTp+dw
                     +atSL+priceSl+dw +liner
                     +ticketNum+request.position
                     +dw+liner+descriptions
                  );
                 }
               if(request.action==TRADE_ACTION_MODIFY)
                 {

                  sendPm(
                     pendingOrder+updateOrder+updateDealPending+updateOrder+pendingOrder+dw +liner
                     +orderType+dw
                     +orderTypeToSTR((request.type),false)+dw +liner
                     +symbolOrder+request.symbol+symbolOrder+dw +liner
                     +atPrice+priceEntry+dw
                     +atTP+priceTp+dw
                     +atSL+priceSl+dw +liner
                     +ticketNum+request.order
                     +dw+liner+descriptions

                  );
                 }
               if(request.action==TRADE_ACTION_PENDING)
                 {

                  sendPm(
                     pendingOrder+newDealPending+pendingOrder+dw +liner
                     +orderType+dw
                     +orderTypeToSTR((request.type),false)+dw +liner
                     +symbolOrder+request.symbol+symbolOrder+dw  +liner
                     +atPrice+priceEntry+dw
                     +atTP+priceTp+dw
                     +atSL+priceSl+dw +liner
                     +ticketNum+request.order
                     +dw+liner+descriptions);
                 }
               if(request.action==TRADE_ACTION_REMOVE)
                 {

                  sendPm(
                     updateOrder+removeDeal+updateOrder+dw +liner
                     +orderType+dw
                     +orderTypeToSTR((request.type),false)+dw +liner
                     +ticketNum+request.order
                     +dw+liner+descriptions
                  );

                 }

               sentDeal=false;
               break;
            case TRADE_TRANSACTION_ORDER_ADD:    // adding a trade
              {
               ulong          lastDealID   =trans.deal;
               ENUM_DEAL_TYPE lastDealType =trans.deal_type;
               double        lastDealVolume=trans.volume;
               sentDeal=true;
               //Print("TRADE_TRANSACTION_ORDER_ADD");
              }
            break;
           }



        }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string orderTypeToSTR(int typeOrder,bool close)
  {
   if(close)
     {
      if(typeOrder==0)
        {
         return sell+sellMarket+sell;
        }
      if(typeOrder==1)
        {
         return buy+buyMarket+buy;
        }
     }
   switch(typeOrder)
     {
      case 0:
         return buy+buyMarket+buy;
      case 2:
         return buy+buyLimit+buy;
      case 4:
         return buy+buyStop+buy;
      case 1:
         return sell+sellMarket+sell;
      case 3:
         return sell+sellLimit+sell;
      case 5:
         return sell+sellStop+sell;
      default:
         return buy+buyLimit+buy;
     }


  }




//+------------------------------------------------------------------+
