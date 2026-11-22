// ============================================
// Sound Manager
// ============================================
integer DATA_CHANNEL = -1002;
key gCurrentSound;
float gVolume = 1.0;
float gRadius = 10.0;
float gFalloff = 1.0;
integer gLoop = FALSE;

playSound(string uuid) {
    llStopSound();
    gCurrentSound = uuid;
    llPlaySound(gCurrentSound, gVolume);
    llSetSoundRadius(gRadius);
    llSetSoundFalloff(gFalloff);
    llOwnerSay("Sonido: " + uuid);
}

stopSound() {
    llStopSound();
    llOwnerSay("Sonido detenido");
}

setVolume(float v) {
    gVolume = llClamp(v, 0.0, 1.0);
    if (gCurrentSound != NULL_KEY) llPlaySound(gCurrentSound, gVolume);
    llOwnerSay("Volumen: " + (string)gVolume);
}

setRadius(float r) { gRadius = r; llSetSoundRadius(gRadius); }
setFalloff(float f) { gFalloff = f; llSetSoundFalloff(gFalloff); }

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "PLAY_SOUND") playSound(id);
            else if (str == "STOP_SOUND") stopSound();
            else if (str == "SET_VOLUME") setVolume((float)id);
            else if (str == "SET_RADIUS") setRadius((float)id);
            else if (str == "SET_FALLOFF") setFalloff((float)id);
        }
    }
}
