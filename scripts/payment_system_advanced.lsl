// ============================================
// Advanced Payment System v1.2
// Módulo de pagos para el HUD Creator.
// Se comunica con los demás scripts por mensajes de enlace (número 0).
// Comandos que recibe (link_message, num 0):
//   CART_ADD|uuid|nombre|precio|cantidad  -> responde CART_ADDED|nombre o CART_ERROR|motivo
//   CART_TOTAL                             -> responde CART_TOTAL|subtotal|impuesto|total
//   CART_COUNT                             -> responde CART_COUNT|n
//   CART_CLEAR                             -> responde CART_CLEARED
//   PAY_REFUND|cliente|monto              -> reembolso (solo el dueño, necesita permiso de débito)
// Cuando un cliente paga, el evento money registra la venta y vacía el
// carrito. El dinero NO se devuelve solo: el reembolso solo se hace con
// PAY_REFUND. Si el pago es menor que el total del carrito, se avisa al
// dueño y se devuelve solo si el objeto tiene permiso de débito.
// ============================================
float TAX_RATE = 0.10;
string CURRENCY = "L$";
list gShoppingCart = [];
list gPurchaseHistory = [];

integer addToCart(string item_uuid, string item_name, integer price, integer quantity)
{
    if (price < 0 || quantity < 1) return FALSE;
    gShoppingCart += [item_uuid, item_name, price, quantity];
    return TRUE;
}

list calculateCartTotal()
{
    integer subtotal = 0;
    integer i;
    for (i = 0; i < llGetListLength(gShoppingCart); i += 4)
    {
        subtotal += llList2Integer(gShoppingCart, i + 2) * llList2Integer(gShoppingCart, i + 3);
    }
    integer tax = llFloor(subtotal * TAX_RATE);
    integer total = subtotal + tax;
    return [subtotal, tax, total];
}

integer recordSale(key customer_uuid, integer amount)
{
    integer items = llGetListLength(gShoppingCart) / 4;
    gPurchaseHistory += [customer_uuid, amount, llGetUnixTime(), "COMPLETED", items, llDumpList2String(gShoppingCart, ";")];
    gShoppingCart = [];
    return TRUE;
}

integer refundPayment(key customer_uuid, integer amount)
{
    if (amount <= 0) return FALSE;
    if (!(llGetPermissions() & PERM_DEBIT))
    {
        llOwnerSay("ERROR: Sin permisos de débito. Activa el permiso de débito del objeto para reembolsar.");
        return FALSE;
    }
    llGiveMoney(customer_uuid, amount);
    llOwnerSay("Reembolso enviado: " + CURRENCY + (string)amount);
    return TRUE;
}

default
{
    state_entry()
    {
    }

    link_message(integer sender, integer num, string msg, key id)
    {
        if (num != 0) return;
        list parts = llParseString2List(msg, ["|"], []);
        string cmd = llList2String(parts, 0);
        if (cmd == "CART_ADD")
        {
            string uuid = llList2String(parts, 1);
            string name = llList2String(parts, 2);
            integer price = llList2Integer(parts, 3);
            integer qty = llList2Integer(parts, 4);
            if (addToCart(uuid, name, price, qty))
            {
                llMessageLinked(LINK_SET, 0, "CART_ADDED|" + name, "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "CART_ERROR|Precio o cantidad no válidos", "");
            }
        }
        else if (cmd == "CART_TOTAL")
        {
            list t = calculateCartTotal();
            llMessageLinked(LINK_SET, 0, "CART_TOTAL|" + (string)llList2Integer(t, 0) + "|" + (string)llList2Integer(t, 1) + "|" + (string)llList2Integer(t, 2), "");
        }
        else if (cmd == "CART_COUNT")
        {
            llMessageLinked(LINK_SET, 0, "CART_COUNT|" + (string)(llGetListLength(gShoppingCart) / 4), "");
        }
        else if (cmd == "CART_CLEAR")
        {
            gShoppingCart = [];
            llMessageLinked(LINK_SET, 0, "CART_CLEARED", "");
        }
        else if (cmd == "PAY_REFUND")
        {
            key customer = (key)llList2String(parts, 1);
            integer amount = llList2Integer(parts, 2);
            refundPayment(customer, amount);
        }
    }

    money(key giver, integer amount)
    {
        list totals = calculateCartTotal();
        integer total = llList2Integer(totals, 2);
        if (llGetListLength(gShoppingCart) > 0 && amount < total)
        {
            if (llGetPermissions() & PERM_DEBIT)
            {
                llGiveMoney(giver, amount);
                llOwnerSay("Pago insuficiente de " + (string)giver + ": " + CURRENCY + (string)amount + " (total " + CURRENCY + (string)total + "). Pago devuelto.");
            }
            else
            {
                llOwnerSay("Pago insuficiente de " + (string)giver + ": " + CURRENCY + (string)amount + " (total " + CURRENCY + (string)total + "). Activa el permiso de débito para devolverlo.");
            }
            return;
        }
        recordSale(giver, amount);
        llOwnerSay("Venta registrada: " + CURRENCY + (string)amount + " de " + (string)giver);
    }
}
