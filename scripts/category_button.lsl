// ============================================
// Botón de Categoría
// ============================================
float BUTTON_SIZE = 0.12;
float BUTTON_HEIGHT = 0.05;
string gButtonName = "Categoría";
string gButtonAction = "SELECT_CATEGORY";
integer gCategoryIndex = 0;
vector gOriginalColor = <0.5, 0.7, 0.9>;
integer gButtonState = 0;

initCategoryButton() {
    llSetPrimitiveParams([
        PRIM_TYPE, PRIM_TYPE_BOX,
        PRIM_SIZE, <BUTTON_SIZE, BUTTON_SIZE, BUTTON_HEIGHT>
    ]);
    updateButtonAppearance();
    llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0);
}

setButtonName(string name) { gButtonName = name; llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0); }
setCategoryIndex(string index) {
    gCategoryIndex = (integer)index;
    list categoryColors = [
        <1.0, 0.7, 0.7>, <0.7, 0.7, 1.0>, <0.7, 0.5, 0.4>, <0.7, 0.8, 0.9>,
        <0.9, 0.9, 0.7>, <1.0, 0.7, 0.8>, <0.8, 0.7, 0.6>, <0.5, 0.6, 0.8>,
        <0.7, 0.9, 0.7>, <0.9, 0.8, 0.7>
    ];
    if (gCategoryIndex >= 0 && gCategoryIndex < llGetListLength(categoryColors)) {
        gOriginalColor = llList2Vector(categoryColors, gCategoryIndex);
    }
    updateButtonAppearance();
}

updateButtonAppearance() {
    vector color;
    if (gButtonState == 0) color = gOriginalColor;
    else if (gButtonState == 1) color = gOriginalColor * 1.2;
    else color = gOriginalColor * 0.7;
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, color, 1.0]);
}

default {
    state_entry() { initCategoryButton(); }
    link_message(integer s, integer n, string str, key id) {
        if (str == "SET_NAME") setButtonName(id);
        else if (str == "SET_INDEX") setCategoryIndex(id);
    }
    touch_start(integer num) { gButtonState = 1; updateButtonAppearance(); }
    touch(integer num) {
        gButtonState = 2; updateButtonAppearance();
        llMessageLinked(LINK_ROOT, 0, gButtonAction + "," + (string)gCategoryIndex, llGetKey());
        llSleep(0.1); gButtonState = 0; updateButtonAppearance();
    }
    touch_end(integer num) { gButtonState = 0; updateButtonAppearance(); }
}
