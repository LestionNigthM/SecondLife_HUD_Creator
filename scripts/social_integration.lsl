// ============================================
// Social Integration
// ============================================
string SL_GROUP_NAME = "My Store Customers";
string SL_GROUP_UUID = "";
boolean AUTO_INVITE_TO_GROUP = TRUE;
boolean SHARE_PURCHASES = TRUE;
list gPurchaseHistory = [];

inviteToGroup(key user_uuid) {
    if (AUTO_INVITE_TO_GROUP && SL_GROUP_UUID != "") {
        llGroupInvite(user_uuid, SL_GROUP_UUID);
        llOwnerSay("Invitación enviada a grupo");
    }
}

sendGroupMessage(string message) {
    if (SL_GROUP_UUID != "") {
        llGroupMessage(SL_GROUP_UUID, message);
    }
}

sharePurchase(key user_uuid, string item_name, integer price) {
    if (SHARE_PURCHASES) {
        string msg = "Compré " + item_name + " por L$" + (string)price;
        llInstantMessage(user_uuid, msg);
        sendGroupMessage(msg);
        gPurchaseHistory += [user_uuid, item_name, price, llGetUnixTime()];
    }
}

default {
    state_entry() { llOwnerSay("Social Integration initialized"); }
}
