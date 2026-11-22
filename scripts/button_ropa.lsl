// ============================================
// Botón de Ropa
// ============================================
float BUTTON_SIZE = 0.12;
float BUTTON_HEIGHT = 0.05;
vector BUTTON_COLOR = <0.8, 0.8, 0.8>;
vector BUTTON_COLOR_HOVER = <1.0, 1.0, 1.0>;
vector BUTTON_COLOR_CLICK = <0.6, 0.6, 0.6>;

string gButtonName = "Ropa";
string gButtonAction = "SELECT_TEXTURE";
integer gTextureIndex = 0;
string gCategory = "";
vector gOriginalColor = BUTTON_COLOR;
integer gButtonState = 0;

initButton() {
    llSetPrimitiveParams([
        PRIM_TYPE, PRIM_TYPE_BOX,
        PRIM_SIZE, <BUTTON_SIZE, BUTTON_SIZE, BUTTON_HEIGHT>
    ]);
    updateButtonAppearance();
    llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0);
}

setButtonName(string name) { gButtonName = name; llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0); }
setButtonAction(string action) { gButtonAction = action; }
setTextureIndex(string index) { gTextureIndex = (integer)index; updateIndexColor(); }
setCategory(string category) { gCategory = category; updateCategoryColor(); }

updateIndexColor() {
    float hue = (float)gTextureIndex / 20.0;
    gOriginalColor = <llSin(hue * PI * 2.0), llCos(hue * PI * 2.0), llSin(hue * PI)> * 0.7 + <0.3, 0.3, 0.3>;
    updateButtonAppearance();
}

updateCategoryColor() {
    if (gCategory == "Algodón") gOriginalColor = <0.8, 0.9, 0.8>;
    else if (gCategory == "Seda") gOriginalColor = <0.9, 0.8, 0.9>;
    else if (gCategory == "Cuero") gOriginalColor = <0.7, 0.6, 0.5>;
    else if (gCategory == "Poliéster") gOriginalColor = <0.7, 0.8, 0.9>;
    else if (gCategory == "Lino") gOriginalColor = <0.9, 0.9, 0.7>;
    else if (gCategory == "Encaje") gOriginalColor = <1.0, 0.8, 0.8>;
    else if (gCategory == "Piel") gOriginalColor = <0.8, 0.7, 0.6>;
    else if (gCategory == "Jeans") gOriginalColor = <0.5, 0.6, 0.8>;
    else if (gCategory == "Deportivo") gOriginalColor = <0.7, 0.9, 0.7>;
    else if (gCategory == "Formal") gOriginalColor = <0.9, 0.8, 0.7>;
    else gOriginalColor = BUTTON_COLOR;
    updateButtonAppearance();
}

updateButtonAppearance() {
    vector color;
    if (gButtonState == 0) color = gOriginalColor;
    else if (gButtonState == 1) color = BUTTON_COLOR_HOVER;
    else color = BUTTON_COLOR_CLICK;
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, color, 1.0]);
}

default {
    state_entry() { initButton(); }
    link_message(integer s, integer n, string str, key id) {
        if (str == "SET_NAME") setButtonName(id);
        else if (str == "SET_ACTION") setButtonAction(id);
        else if (str == "SET_INDEX") setTextureIndex(id);
        else if (str == "SET_CATEGORY") setCategory(id);
    }
    touch_start(integer num) { gButtonState = 1; updateButtonAppearance(); }
    touch(integer num) {
        gButtonState = 2; updateButtonAppearance();
        llMessageLinked(LINK_ROOT, 0, gButtonAction + "," + (string)gTextureIndex, llGetKey());
        llSleep(0.1); gButtonState = 0; updateButtonAppearance();
    }
    touch_end(integer num) { gButtonState = 0; updateButtonAppearance(); }
}
