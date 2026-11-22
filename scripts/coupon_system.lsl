// ============================================
// Coupon System
// ============================================
list COUPON_CODES = ["WELCOME10", "SUMMER20", "VIP25"];
list COUPON_DISCOUNTS = [10, 20, 25];
list COUPON_EXPIRY_DAYS = [30, 60, 90];
list COUPON_MAX_USES = [100, 50, 25];
list COUPON_MIN_PURCHASE = [0, 0, 1000];

list gCoupons = [];
list gUserCoupons = [];

string generateCouponCode(integer length) {
    string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    string code = "";
    integer i;
    for (i = 0; i < length; i++) {
        code += llGetSubString(chars, llFloor(llFrand(llStringLength(chars))), llFloor(llFrand(llStringLength(chars))));
    }
    return code;
}

integer validateCoupon(string code, string user_uuid, integer cart_total) {
    integer i;
    for (i = 0; i < llGetListLength(COUPON_CODES); i++) {
        if (llList2String(COUPON_CODES, i) == code) {
            integer discount = llList2Integer(COUPON_DISCOUNTS, i);
            integer minPurchase = llList2Integer(COUPON_MIN_PURCHASE, i);
            if (cart_total >= minPurchase) return discount;
            else return -4;
        }
    }
    return -1;
}

list applyCouponToCart(string code, string user_uuid, integer cart_total) {
    integer validation = validateCoupon(code, user_uuid, cart_total);
    if (validation < 0) {
        if (validation == -1) return [cart_total, 0, "", "ERROR: Cupón no encontrado"];
        if (validation == -4) return [cart_total, 0, "", "ERROR: Compra mínima no alcanzada"];
    }
    integer discountAmount = llFloor(cart_total * validation / 100.0);
    integer finalTotal = cart_total - discountAmount;
    return [finalTotal, discountAmount, code, "SUCCESS"];
}

default {
    state_entry() { llOwnerSay("Coupon System initialized"); }
}
