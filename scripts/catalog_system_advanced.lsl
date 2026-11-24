// ============================================
// Advanced Catalog System v1.2
// Módulo de catálogo para el HUD Creator.
// Cada producto tiene 7 datos: UUID, nombre, categoría, precio,
// textura UUID, valoración, descripción.
// Pega las UUID reales de tus productos y texturas (ahora están vacías
// a propósito: nunca uses UUID falsas).
// Se comunica con los demás scripts por mensajes de enlace (número 0).
// Comandos que recibe (link_message, num 0):
//   CAT_PAGE|pagina     -> responde CAT_PAGE|pagina|totalPaginas|nombre1,nombre2...
//   CAT_PAGES           -> responde CAT_PAGES|totalPaginas
//   CAT_COUNT           -> responde CAT_COUNT|nProductos
// ============================================
integer CATALOG_ITEMS_PER_PAGE = 12;
integer gCurrentPage = 0;
list gCatalogItems = [
    "", "Cotton T-Shirt", 0, 250, "", 4, "Basic white t-shirt",
    "", "Silk Blouse", 0, 500, "", 5, "Elegant silk blouse",
    "", "Jeans", 1, 350, "", 4, "Classic blue jeans"
];

integer getTotalPages()
{
    integer items = llGetListLength(gCatalogItems) / 7;
    integer pages = (items + CATALOG_ITEMS_PER_PAGE - 1) / CATALOG_ITEMS_PER_PAGE;
    if (pages < 1) pages = 1;
    return pages;
}

list getPageItems(integer page)
{
    integer total = getTotalPages();
    if (page < 0) page = 0;
    if (page >= total) page = total - 1;
    integer start = page * CATALOG_ITEMS_PER_PAGE * 7;
    integer end = start + CATALOG_ITEMS_PER_PAGE * 7;
    if (end > llGetListLength(gCatalogItems)) end = llGetListLength(gCatalogItems);
    return llList2List(gCatalogItems, start, end - 1);
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
        if (cmd == "CAT_PAGE")
        {
            integer page = llList2Integer(parts, 1);
            integer total = getTotalPages();
            if (page < 0) page = 0;
            if (page >= total) page = total - 1;
            gCurrentPage = page;
            list items = getPageItems(page);
            string names = "";
            integer i;
            for (i = 0; i < llGetListLength(items); i += 7)
            {
                if (names != "") names += ",";
                names += llList2String(items, i + 1);
            }
            llMessageLinked(LINK_SET, 0, "CAT_PAGE|" + (string)page + "|" + (string)total + "|" + names, "");
        }
        else if (cmd == "CAT_PAGES")
        {
            llMessageLinked(LINK_SET, 0, "CAT_PAGES|" + (string)getTotalPages(), "");
        }
        else if (cmd == "CAT_COUNT")
        {
            llMessageLinked(LINK_SET, 0, "CAT_COUNT|" + (string)(llGetListLength(gCatalogItems) / 7), "");
        }
    }
}
