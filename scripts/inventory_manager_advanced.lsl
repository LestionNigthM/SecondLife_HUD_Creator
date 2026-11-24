// ============================================
// Advanced Inventory Manager v1.2
// Módulo de inventario para el HUD Creator.
// Cada producto tiene 7 datos: nombre, textura UUID, precio, categoría,
// stock, valoración, descripción.
// Pega las UUID reales de tus texturas en el segundo dato de cada
// producto (ahora están vacías a propósito: nunca uses UUID falsas).
// Se comunica con los demás scripts por mensajes de enlace (número 0).
// Comandos que recibe (link_message, num 0):
//   INV_SEARCH|texto|categoria|precioMax -> responde INV_RESULTS|n|nombre1,nombre2...
//   INV_FIND|nombre                      -> responde INV_FOUND|nombre|precio|stock|descripcion o INV_NOTFOUND
//   INV_SOLD|nombre                      -> descuenta 1 del stock, responde INV_SOLD_OK|nombre|stock o INV_SOLD_ERROR
//   INV_STATUS                           -> responde INV_STATUS|nProductos
// Categoría -1 = todas, precio máximo -1 = sin límite.
// ============================================
list INVENTORY_CATEGORIES = ["Tops", "Bottoms", "Dresses", "Shoes", "Accessories"];
list gInventoryItems = [
    "Cotton T-Shirt", "", 250, 0, 100, 4, "Basic white t-shirt",
    "Silk Blouse", "", 500, 0, 50, 5, "Elegant silk blouse",
    "Jeans", "", 350, 1, 75, 4, "Classic blue jeans"
];

list findTextureByName(string name)
{
    list matches = [];
    integer i;
    for (i = 0; i < llGetListLength(gInventoryItems); i += 7)
    {
        if (llSubStringIndex(llList2String(gInventoryItems, i), name) != -1)
        {
            matches += llList2List(gInventoryItems, i, i + 6);
        }
    }
    return matches;
}

list searchTextures(string query, integer category, integer max_price)
{
    list results = [];
    integer i;
    for (i = 0; i < llGetListLength(gInventoryItems); i += 7)
    {
        string name = llList2String(gInventoryItems, i);
        string desc = llList2String(gInventoryItems, i + 6);
        integer cat = llList2Integer(gInventoryItems, i + 3);
        integer price = llList2Integer(gInventoryItems, i + 2);
        if ((category == -1 || cat == category) && (max_price == -1 || price <= max_price) &&
            (llSubStringIndex(name, query) != -1 || llSubStringIndex(desc, query) != -1))
        {
            results += llList2List(gInventoryItems, i, i + 6);
        }
    }
    return results;
}

integer sellItem(string name)
{
    integer i;
    for (i = 0; i < llGetListLength(gInventoryItems); i += 7)
    {
        if (llList2String(gInventoryItems, i) == name)
        {
            integer stock = llList2Integer(gInventoryItems, i + 4);
            if (stock <= 0) return -1;
            gInventoryItems = llListReplaceList(gInventoryItems, [stock - 1], i + 4, i + 4);
            return stock - 1;
        }
    }
    return -2;
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
        if (cmd == "INV_SEARCH")
        {
            string query = llList2String(parts, 1);
            integer category = llList2Integer(parts, 2);
            integer maxPrice = llList2Integer(parts, 3);
            list results = searchTextures(query, category, maxPrice);
            integer count = llGetListLength(results) / 7;
            string names = "";
            integer i;
            for (i = 0; i < llGetListLength(results); i += 7)
            {
                if (names != "") names += ",";
                names += llList2String(results, i);
            }
            llMessageLinked(LINK_SET, 0, "INV_RESULTS|" + (string)count + "|" + names, "");
        }
        else if (cmd == "INV_FIND")
        {
            string name = llList2String(parts, 1);
            list found = findTextureByName(name);
            if (llGetListLength(found) == 0)
            {
                llMessageLinked(LINK_SET, 0, "INV_NOTFOUND", "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "INV_FOUND|" + llList2String(found, 0) + "|" + (string)llList2Integer(found, 2) + "|" + (string)llList2Integer(found, 4) + "|" + llList2String(found, 6), "");
            }
        }
        else if (cmd == "INV_SOLD")
        {
            string name = llList2String(parts, 1);
            integer res = sellItem(name);
            if (res >= 0)
            {
                llMessageLinked(LINK_SET, 0, "INV_SOLD_OK|" + name + "|" + (string)res, "");
            }
            else if (res == -1)
            {
                llMessageLinked(LINK_SET, 0, "INV_SOLD_ERROR|Sin stock", "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "INV_SOLD_ERROR|Producto no encontrado", "");
            }
        }
        else if (cmd == "INV_STATUS")
        {
            llMessageLinked(LINK_SET, 0, "INV_STATUS|" + (string)(llGetListLength(gInventoryItems) / 7), "");
        }
    }
}
