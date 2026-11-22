// ============================================
// Advanced Payment System
// ============================================
integer PAYMENT_TIMEOUT = 60;
float TAX_RATE = 0.10;
string CURRENCY = "L$";
list gShoppingCart = [];
list gPurchaseHistory = [];

integer addToCart(string item_uuid, string item_name, integer price, integer quantity) {
    gShoppingCart += [item_uuid, item_name, price, quantity];
    llOwnerSay("Añadido al carrito: " + item_name);
    return TRUE;
}

list calculateCartTotal() {
    integer subtotal = 0;
    integer i;
    for (i = 0; i < llGetListLength(gShoppingCart); i += 4) {
        subtotal += llList2Integer(gShoppingCart, i + 2) * llList2Integer(gShoppingCart, i + 3);
    }
    integer tax = llFloor(subtotal * TAX_RATE);
    integer total = subtotal + tax;
    return [subtotal, tax, total];
}

integer processPayment(key customer_uuid, integer amount) {
    if (!(llGetPermissions() & PERM_DEBIT)) {
        llOwnerSay("ERROR: Sin permisos de débito");
        return FALSE;
    }
    if (llGetBalance() < amount) {
        llOwnerSay("ERROR: Fondos insuficientes");
        return FALSE;
    }
    llGiveMoney(customer_uuid, amount);
    gPurchaseHistory += [customer_uuid, gShoppingCart, amount, llGetUnixTime(), "COMPLETED"];
    gShoppingCart = [];
    llOwnerSay("Pago exitoso: L$" + (string)amount);
    return TRUE;
}

default {
    state_entry() { llOwnerSay("Payment System initialized"); }
    money(key giver, integer amount) {
        llOwnerSay("Dinero recibido: L$" + (string)amount);
        processPayment(giver, amount);
    }
}
