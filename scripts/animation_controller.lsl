// ============================================
// Animation Controller — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal:
// - Nunca pedía PERMISSION_TRIGGER_ANIMATION. Sin ese permiso, un HUD
//   no puede reproducir animaciones en quien lo lleva.
// - Usaba llStopAnimation("all"). "all" no existe en LSL: hay que
//   detener la animación por su UUID, una por una. Ahora el script
//   recuerda cuál está sonando y detiene solo esa.
// - SET_SPEED solo reiniciaba la animación sin avisar: LSL no tiene
//   control de velocidad de animaciones, y ahora el comentario lo dice.
//
// Comandos (por llMessageLinked, número 0):
//   START_ANIMATION "uuid" | STOP_ANIMATION | STOP_ALL_ANIMATIONS
//   SET_SPEED "0.1-2.0" (solo reinicia la animación actual)
// La animación debe estar en el inventario del objeto para poder sonar.

key gCurrentAnimation;
float gSpeed = 1.0;
integer gPriority = 1;
integer gPermGranted = FALSE;

startAnimation(string uuid) {
    if (!gPermGranted) {
        llOwnerSay("Aún no tengo permiso de animación. Acéptalo cuando te lo pida el visor.");
        return;
    }
    if (uuid == "" || (key)uuid == NULL_KEY) {
        llOwnerSay("Falta el UUID de la animación.");
        return;
    }
    if (gCurrentAnimation != NULL_KEY) llStopAnimation((string)gCurrentAnimation);
    gCurrentAnimation = (key)uuid;
    llStartAnimation((string)gCurrentAnimation);
    llOwnerSay("Animación: " + uuid);
}

stopAnimation() {
    if (gCurrentAnimation != NULL_KEY) llStopAnimation((string)gCurrentAnimation);
    gCurrentAnimation = NULL_KEY;
    llOwnerSay("Animación detenida");
}

stopAllAnimations() {
    stopAnimation();
}

setSpeed(float s) {
    // LSL no tiene control de velocidad: lo único que se puede hacer
    // es reiniciar la animación actual.
    gSpeed = llClamp(s, 0.1, 2.0);
    if (gCurrentAnimation != NULL_KEY) {
        llStopAnimation((string)gCurrentAnimation);
        llStartAnimation((string)gCurrentAnimation);
    }
}

default {
    state_entry() {
        // El permiso se pide al arrancar; la primera vez el visor te
        // preguntará si lo aceptas.
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    run_time_permissions(integer perm) {
        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            gPermGranted = TRUE;
            llOwnerSay("Permiso de animación concedido.");
        } else {
            llOwnerSay("Sin permiso de animación: las animaciones no se reproducirán.");
        }
    }

    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "START_ANIMATION") startAnimation((string)id);
            else if (str == "STOP_ANIMATION") stopAnimation();
            else if (str == "STOP_ALL_ANIMATIONS") stopAllAnimations();
            else if (str == "SET_SPEED") setSpeed((float)id);
        }
    }
}
