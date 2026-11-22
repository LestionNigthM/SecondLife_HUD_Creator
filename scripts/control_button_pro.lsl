// ============================================
// Control Button Pro
// ============================================
float BUTTON_SIZE = 0.12;
float BUTTON_HEIGHT = 0.05;
vector BUTTON_COLOR = <0.6, 0.6, 0.6>;
vector BUTTON_COLOR_HOVER = <0.8, 0.8, 0.8>;
vector BUTTON_COLOR_CLICK = <0.4, 0.4, 0.4>;

string gButtonName = "Control";
string gButtonAction = "";
vector gOriginalColor = BUTTON_COLOR;
integer gButtonState = 0;

initControlButton() {
    llSetPrimitiveParams([
        PRIM_TYPE, PRIM_TYPE_BOX,
        PRIM_SIZE, <BUTTON_SIZE, BUTTON_SIZE, BUTTON_HEIGHT>
    ]);
    updateButtonAppearance();
    llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0);
}

setButtonName(string name) {
    gButtonName = name;
    llSetText(gButtonName, <1.0, 1.0, 1.0>, 1.0);
    if (name == "Select") gOriginalColor = <0.5, 0.9, 0.5>;
    else if (name == "Face+" || name == "Face-") gOriginalColor = <0.9, 0.7, 0.5>;
    else if (name == "Mode") gOriginalColor = <0.7, 0.5, 0.9>;
    else if (name == "Save") gOriginalColor = <0.5, 0.7, 0.9>;
    else if (name == "Load") gOriginalColor = <0.9, 0.9, 0.5>;
    else if (name == "Delete") gOriginalColor = <0.9, 0.5, 0.5>;
    else if (name == "Exit") gOriginalColor = <0.7, 0.7, 0.7>;
    else gOriginalColor = BUTTON_COLOR;
    updateButtonAppearance();
}

setButtonAction(string action) { gButtonAction = action; }

updateButtonAppearance() {
    vector color;
    if (gButtonState == 0) color = gOriginalColor;
    else if (gButtonState == 1) color = BUTTON_COLOR_HOVER;
    else color = BUTTON_COLOR_CLICK;
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, color, 1.0]);
}

default {
    state_entry() { initControlButton(); }
    link_message(integer s, integer n, string str, key id) {
        if (str == "SET_NAME") setButtonName(id);
        else if (str == "SET_ACTION") setButtonAction(id);
    }
    touch_start(integer num) { gButtonState = 1; updateButtonAppearance(); }
    touch(integer num) {
        gButtonState = 2; updateButtonAppearance();
        llMessageLinked(LINK_ROOT, 0, gButtonAction + ",", llGetKey());
        llSleep(0.1); gButtonState = 0; updateButtonAppearance();
    }
    touch_end(integer num) { gButtonState = 0; updateButtonAppearance(); }
}
