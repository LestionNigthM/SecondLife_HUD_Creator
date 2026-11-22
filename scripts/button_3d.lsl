// ============================================
// 3D Button
// ============================================
float BUTTON_SIZE = 0.12;
float BUTTON_HEIGHT = 0.05;
vector BUTTON_COLOR = <0.7, 0.7, 0.7>;
vector BUTTON_COLOR_HOVER = <0.9, 0.9, 0.9>;
vector BUTTON_COLOR_CLICK = <0.5, 0.5, 0.5>;

string gButtonName = "Button";
string gButtonAction = "";
string gButtonParameter = "";
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
setButtonParameter(string param) { gButtonParameter = param; }

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
        else if (str == "SET_PARAMETER") setButtonParameter(id);
    }
    touch_start(integer num) { gButtonState = 1; updateButtonAppearance(); }
    touch(integer num) {
        gButtonState = 2; updateButtonAppearance();
        llMessageLinked(LINK_ROOT, 0, gButtonAction + "," + gButtonParameter, llGetKey());
        llSleep(0.1); gButtonState = 0; updateButtonAppearance();
    }
    touch_end(integer num) { gButtonState = 0; updateButtonAppearance(); }
}
