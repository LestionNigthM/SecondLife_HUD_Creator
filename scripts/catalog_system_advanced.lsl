// ============================================
// Advanced Catalog System
// ============================================
integer CATALOG_ITEMS_PER_PAGE = 12;
integer gCurrentPage = 0;
list gCatalogItems = [
    ["uuid-001", "Cotton T-Shirt", 0, 250, "texture-uuid-001", 4, "Basic white t-shirt"],
    ["uuid-002", "Silk Blouse", 0, 500, "texture-uuid-002", 5, "Elegant silk blouse"],
    ["uuid-003", "Jeans", 1, 350, "texture-uuid-003", 4, "Classic blue jeans"]
];

integer getTotalPages() {
    integer total = llGetListLength(gCatalogItems) / 8;
    if (llGetListLength(gCatalogItems) % 8 > 0) total++;
    return total;
}

list getPageItems(integer page) {
    integer start = page * CATALOG_ITEMS_PER_PAGE * 8;
    integer end = start + (CATALOG_ITEMS_PER_PAGE * 8);
    if (end > llGetListLength(gCatalogItems)) end = llGetListLength(gCatalogItems);
    return llList2List(gCatalogItems, start, end - 1);
}

default {
    state_entry() { llOwnerSay("Catalog System initialized"); }
}
