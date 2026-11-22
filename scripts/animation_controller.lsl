// ============================================
// Animation Controller
// ============================================
integer DATA_CHANNEL = -1002;
key gCurrentAnimation;
float gSpeed = 1.0;
integer gPriority = 1;

startAnimation(string uuid) {
    llStopAnimation("all");
    gCurrentAnimation = uuid;
    llStartAnimation(gCurrentAnimation);
    llOwnerSay("Animación: " + uuid);
}

stopAnimation() {
    llStopAnimation("all");
    llOwnerSay("Animación detenida");
}

stopAllAnimations() {
    llStopAnimation("all");
}

setSpeed(float s) {
    gSpeed = llClamp(s, 0.1, 2.0);
    if (gCurrentAnimation != NULL_KEY) {
        llStopAnimation(gCurrentAnimation);
        llStartAnimation(gCurrentAnimation);
    }
}

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "START_ANIMATION") startAnimation(id);
            else if (str == "STOP_ANIMATION") stopAnimation();
            else if (str == "STOP_ALL_ANIMATIONS") stopAllAnimations();
            else if (str == "SET_SPEED") setSpeed((float)id);
        }
    }
}
