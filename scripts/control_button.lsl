// ============================================
// Botón de Control
// ============================================
float BUTTON_SIZE = 0.12;
float BUTTON_HEIGHT = 0.05;
string gButtonName = "Control";
string gButtonAction = "";
vector gOriginalColor = <0.6, 0.6, 0.6>;
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
    if (name == "Select" || name == "Seleccionar") gOriginalColor = <0.5, 0.9, 0.5>;
    else if (name == "Face+" || name == "Face-" || name == "Cara+" || name == "Cara-") gOriginalColor = <0.9, 0.7, 0.5>;
    else if (name == "Mode" || name == "Modo") gOriginalColor = <0.7, 0.5, 0.9>;
    else if (name == "Save" || name == "Guardar") gOriginalColor = <0.5, 0.7, 0.9>;
    else if (name == "Load" || name == "Cargar") gOriginalColor = <0.9, 0.9, 0.5>;
    else if (name == "Delete" || name == "Eliminar") gOriginalColor = <0.9, 0.5, 0.5>;
    else if (name == "Exit" || name == "Salir") gOriginalColor = <0.7, 0.7, 0.7>;
    else gOriginalColor = <0.6, 0.6, 0.6>;
    updateButtonAppearance();
}

setButtonAction(string action) { gButtonAction = action; }

updateButtonAppearance() {
    vector color;
    if (gButtonState == 0) color = gOriginalColor;
    else if (gButtonState == 1) color = gOriginalColor * 1.3;
    else color = gOriginalColor * 0.6;
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
