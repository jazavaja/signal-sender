<?php

class MetaServer
{
    function sendMessageTelegram($chatID, $messaggio, $token)
    {
        $url = "https://api.telegram.org/bot" . $token . "/sendMessage?chat_id=" . $chatID;
        $url = $url . "&text=" . urlencode($messaggio);
        $ch = curl_init();
        $optArray = array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true
        );
        curl_setopt_array($ch, $optArray);
        $result = curl_exec($ch);
        curl_close($ch);
        return $result;
    }
}

$s = new MetaServer();
header('Content-type: text/plain; charset=utf-8');
$token = "5642907029:AAHjgUjMppS1FLMHyWGjEr2YD2cg6yaMqt0";

$descriptionFarsi = "قبل از معامله حتما محتوا های اموزشی کانال  @forebex_learn_fa   مشاهده کنید";
$descriptionEng = "Please be sure to see the educational content of the @forebex_learn_en channel before trading";

$channel = $_GET['channel'];
$message = ($_GET['message']);
$lang = ($_GET['lang']);

if (!isset($lang)) {
    $lang = "fa";
}
//

$forLang = (explode(',', $lang));

$forChannel = (explode(',', $channel));

$boolCount = count($forLang) == count($forChannel);
//

for ($i = 0; $i < count($forLang); $i++) {

    $messageRes = $message;

    $messageRes = str_replace("@@", "\n", $messageRes);
    $messageRes = str_replace("^sell^", "📉", $messageRes);
    $messageRes = str_replace("^buy^", "📈", $messageRes);
    $messageRes = str_replace("^stop^", "🛡️", $messageRes);
    $messageRes = str_replace("^target^", "🎯", $messageRes);
    $messageRes = str_replace("^pending^", "⏳", $messageRes);
    $messageRes = str_replace("^update^", "🖍️", $messageRes);
    $messageRes = str_replace("^market^", "⚔️", $messageRes);
    $messageRes = str_replace("^new^", "🆕", $messageRes);
    $messageRes = str_replace("^symbol^", "💰", $messageRes);


    if ($forLang[$i] == "fa") {
        $NewDeal = "معامله جدید";
        $NewDealPending = " معامله جدید";
        $CloseDeal = "بستن دستی معامله";
        $RemoveDeal = "حذف معامله";
        $UpdatePendingOrder = "اپدیت معامله";
        $UpdateTP_Sl_Order = "اپدیت حد سود و ضرر معامله";
        $SellLimit = " فروش لیمیت اوردر";
        $SellMarket = "فروش مارکت اوردر";
        $SellStop = "فروش استاپ اوردر";
        $BuyLimit = "خرید لیمیت اوردر";
        $BuyMarket = "خرید مارکت اوردر";
        $BuyStop = "خرید استاپ اوردر";
        $PriceEntry = "قیمت ورود : ";
        $Tp = "حد سود ->";
        $SL = "حد ضرر ->";
        $Profit_Loss = "سود/ضرر معامله : ";
        $Tp_Order = "معامله تارگت خورد";
        $StopOrder = "معامله توقف یافت";
        $OrderType = "نوع معامله";

        $messageRes = str_replace("^description^", $descriptionFarsi, $messageRes);
        $messageRes = str_replace("^NewDeal^", $NewDeal, $messageRes);
        $messageRes = str_replace("^NewDealPending^", $NewDealPending, $messageRes);
        $messageRes = str_replace("^CloseDeal^", $CloseDeal, $messageRes);
        $messageRes = str_replace("^RemoveDeal^", $RemoveDeal, $messageRes);
        $messageRes = str_replace("^UpdatePendingOrder^", $UpdatePendingOrder, $messageRes);
        $messageRes = str_replace("^UpdateTP_Sl_Order^", $UpdateTP_Sl_Order, $messageRes);
        $messageRes = str_replace("^SellLimit^", $SellLimit, $messageRes);
        $messageRes = str_replace("^SellMarket^", $SellMarket, $messageRes);
        $messageRes = str_replace("^SellStop^", $SellStop, $messageRes);
        $messageRes = str_replace("^BuyLimit^", $BuyLimit, $messageRes);
        $messageRes = str_replace("^BuyMarket^", $BuyMarket, $messageRes);
        $messageRes = str_replace("^BuyStop^", $BuyStop, $messageRes);
        $messageRes = str_replace("^PriceEntry^", $PriceEntry, $messageRes);
        $messageRes = str_replace("^Tp^", $Tp, $messageRes);
        $messageRes = str_replace("^SL^", $SL, $messageRes);
        $messageRes = str_replace("^Profit_Loss^", $Profit_Loss, $messageRes);
        $messageRes = str_replace("^Tp_Order^", $Tp_Order, $messageRes);
        $messageRes = str_replace("^StopOrder^", $StopOrder, $messageRes);
        $messageRes = str_replace("^OrderType^", $OrderType, $messageRes);
    } else {

        $NewDeal = "New Deal";
        $NewDealPending = "New Pending Deal";
        $CloseDeal = "Close Deal";
        $RemoveDeal = "Remove Deal";
        $UpdatePendingOrder = "Update Pending Order";
        $UpdateTP_Sl_Order = "Update TP/SL order";
        $SellLimit = "Sell limit";
        $SellMarket = "Sell Market";
        $SellStop = "Sell Stop";
        $BuyLimit = "Buy limit";
        $BuyMarket = "Buy market";
        $BuyStop = "Buy stop";
        $PriceEntry = "Price Entry: ";
        $Tp = "TP -> ";
        $SL = "SL -> ";
        $Profit_Loss = " PNL deal : ";
        $Tp_Order = "Target Deal";
        $StopOrder = "Stop Deal";
        $OrderType = "Type order";

        $messageRes = str_replace("^NewDeal^", $NewDeal, $messageRes);
        $messageRes = str_replace("^NewDealPending^", $NewDealPending, $messageRes);
        $messageRes = str_replace("^CloseDeal^", $CloseDeal, $messageRes);
        $messageRes = str_replace("^RemoveDeal^", $RemoveDeal, $messageRes);
        $messageRes = str_replace("^UpdatePendingOrder^", $UpdatePendingOrder, $messageRes);
        $messageRes = str_replace("^UpdateTP_Sl_Order^", $UpdateTP_Sl_Order, $messageRes);
        $messageRes = str_replace("^SellLimit^", $SellLimit, $messageRes);
        $messageRes = str_replace("^SellMarket^", $SellMarket, $messageRes);
        $messageRes = str_replace("^SellStop^", $SellStop, $messageRes);
        $messageRes = str_replace("^BuyLimit^", $BuyLimit, $messageRes);
        $messageRes = str_replace("^BuyMarket^", $BuyMarket, $messageRes);
        $messageRes = str_replace("^BuyStop^", $BuyStop, $messageRes);
        $messageRes = str_replace("^PriceEntry^", $PriceEntry, $messageRes);
        $messageRes = str_replace("^Tp^", $Tp, $messageRes);
        $messageRes = str_replace("^SL^", $SL, $messageRes);
        $messageRes = str_replace("^Profit_Loss^", $Profit_Loss, $messageRes);
        $messageRes = str_replace("^Tp_Order^", $Tp_Order, $messageRes);
        $messageRes = str_replace("^StopOrder^", $StopOrder, $messageRes);
        $messageRes = str_replace("^OrderType^", $OrderType, $messageRes);
        $messageRes = str_replace("^description^", $descriptionEng, $messageRes);
    }
    if ($boolCount)
        $s->sendMessageTelegram($forChannel[$i], $messageRes, $token);

    $messageRes = null;


}



