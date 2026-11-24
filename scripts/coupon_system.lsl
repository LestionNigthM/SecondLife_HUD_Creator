// ============================================
// Coupon System v1.2
// Módulo de cupones para el HUD Creator.
// Se comunica con los demás scripts por mensajes de enlace (número 0).
// Comandos que recibe (link_message, num 0):
//   COUPON_APPLY|codigo|total        -> responde COUPON_RESULT|totalFinal|descuento|codigo|estado
//   COUPON_GENERATE|longitud         -> responde COUPON_CODE|codigo
//   COUPON_STATUS                    -> responde COUPON_STATUS|nCupones|usosTotales
// Códigos de error: -1 no existe, -2 usos agotados, -3 caducado,
// -4 compra mínima no alcanzada.
// La caducidad cuenta desde que arranca el script (un reinicio reinicia
// el plazo). Los usos se guardan mientras el script no se reinicie.
// ============================================
list COUPON_CODES = ["WELCOME10", "SUMMER20", "VIP25"];
list COUPON_DISCOUNTS = [10, 20, 25];
list COUPON_EXPIRY_DAYS = [30, 60, 90];
list COUPON_MAX_USES = [100, 50, 25];
list COUPON_MIN_PURCHASE = [0, 0, 1000];

list gCouponUses = [];
list gCouponCreated = [];

initCoupons()
{
    integer i;
    gCouponUses = [];
    gCouponCreated = [];
    integer now = llGetUnixTime();
    for (i = 0; i < llGetListLength(COUPON_CODES); i++)
    {
        gCouponUses += 0;
        gCouponCreated += now;
    }
}

string generateCouponCode(integer length)
{
    string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    string code = "";
    integer i;
    for (i = 0; i < length; i++)
    {
        integer idx = llFloor(llFrand(llStringLength(chars)));
        code += llGetSubString(chars, idx, idx);
    }
    return code;
}

integer validateCoupon(string code, integer cart_total)
{
    integer i;
    for (i = 0; i < llGetListLength(COUPON_CODES); i++)
    {
        if (llList2String(COUPON_CODES, i) == code)
        {
            integer discount = llList2Integer(COUPON_DISCOUNTS, i);
            integer minPurchase = llList2Integer(COUPON_MIN_PURCHASE, i);
            integer maxUses = llList2Integer(COUPON_MAX_USES, i);
            integer expiryDays = llList2Integer(COUPON_EXPIRY_DAYS, i);
            if (cart_total < minPurchase) return -4;
            if (llList2Integer(gCouponUses, i) >= maxUses) return -2;
            if (llGetUnixTime() - llList2Integer(gCouponCreated, i) > expiryDays * 86400) return -3;
            return discount;
        }
    }
    return -1;
}

list applyCouponToCart(string code, integer cart_total)
{
    integer validation = validateCoupon(code, cart_total);
    if (validation < 0)
    {
        if (validation == -1) return [cart_total, 0, code, "ERROR: Cupón no encontrado"];
        if (validation == -2) return [cart_total, 0, code, "ERROR: Cupón agotado (usos máximos)"];
        if (validation == -3) return [cart_total, 0, code, "ERROR: Cupón caducado"];
        if (validation == -4) return [cart_total, 0, code, "ERROR: Compra mínima no alcanzada"];
    }
    integer i;
    for (i = 0; i < llGetListLength(COUPON_CODES); i++)
    {
        if (llList2String(COUPON_CODES, i) == code)
        {
            gCouponUses = llListReplaceList(gCouponUses, [llList2Integer(gCouponUses, i) + 1], i, i);
        }
    }
    integer discountAmount = llFloor(cart_total * validation / 100.0);
    integer finalTotal = cart_total - discountAmount;
    return [finalTotal, discountAmount, code, "SUCCESS"];
}

default
{
    state_entry()
    {
        initCoupons();
    }

    link_message(integer sender, integer num, string msg, key id)
    {
        if (num != 0) return;
        list parts = llParseString2List(msg, ["|"], []);
        string cmd = llList2String(parts, 0);
        if (cmd == "COUPON_APPLY")
        {
            string code = llList2String(parts, 1);
            integer total = llList2Integer(parts, 2);
            list res = applyCouponToCart(code, total);
            llMessageLinked(LINK_SET, 0, "COUPON_RESULT|" + (string)llList2Integer(res, 0) + "|" + (string)llList2Integer(res, 1) + "|" + llList2String(res, 2) + "|" + llList2String(res, 3), "");
        }
        else if (cmd == "COUPON_GENERATE")
        {
            integer len = llList2Integer(parts, 1);
            if (len < 4) len = 4;
            if (len > 16) len = 16;
            llMessageLinked(LINK_SET, 0, "COUPON_CODE|" + generateCouponCode(len), "");
        }
        else if (cmd == "COUPON_STATUS")
        {
            integer used = 0;
            integer i;
            for (i = 0; i < llGetListLength(gCouponUses); i++) used += llList2Integer(gCouponUses, i);
            llMessageLinked(LINK_SET, 0, "COUPON_STATUS|" + (string)llGetListLength(COUPON_CODES) + "|" + (string)used, "");
        }
    }
}
