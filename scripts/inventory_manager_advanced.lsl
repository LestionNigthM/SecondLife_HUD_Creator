// ============================================
// Advanced Inventory Manager
// ============================================
list INVENTORY_CATEGORIES = ["Tops", "Bottoms", "Dresses", "Shoes", "Accessories"];
list INVENTORY_ITEMS = [
    "Cotton T-Shirt", "texture-uuid-001", 250, 0, 100, 4, "Basic white t-shirt",
    "Silk Blouse", "texture-uuid-002", 500, 0, 50, 5, "Elegant silk blouse",
    "Jeans", "texture-uuid-003", 350, 1, 75, 4, "Classic blue jeans"
];

list findTextureByName(string name) {
    list matches = [];
    integer i;
    for (i = 0; i < llGetListLength(INVENTORY_ITEMS); i += 7) {
        if (llSubStringIndex(llList2String(INVENTORY_ITEMS, i), name) != -1) {
            matches += llList2List(INVENTORY_ITEMS, i, i + 6);
        }
    }
    return matches;
}

list searchTextures(string query, integer category, integer max_price) {
    list results = [];
    integer i;
    for (i = 0; i < llGetListLength(INVENTORY_ITEMS); i += 7) {
        string name = llList2String(INVENTORY_ITEMS, i);
        string desc = llList2String(INVENTORY_ITEMS, i + 6);
        integer cat = llList2Integer(INVENTORY_ITEMS, i + 3);
        integer price = llList2Integer(INVENTORY_ITEMS, i + 2);
        if ((category == -1 || cat == category) && (max_price == -1 || price <= max_price) &&
            (llSubStringIndex(name, query) != -1 || llSubStringIndex(desc, query) != -1)) {
            results += llList2List(INVENTORY_ITEMS, i, i + 6);
        }
    }
    return results;
}

default {
    state_entry() { llOwnerSay("Inventory Manager initialized"); }
}
