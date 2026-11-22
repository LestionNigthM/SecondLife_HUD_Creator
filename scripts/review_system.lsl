// ============================================
// Review System
// ============================================
integer MAX_RATING = 5;
integer MIN_REVIEW_LENGTH = 10;
integer REVIEW_APPROVAL_REQUIRED = TRUE;
list gReviews = [];
list gPendingReviews = [];

integer addReview(key user_uuid, string item_uuid, integer rating, string review_text) {
    if (rating < 1 || rating > MAX_RATING) return FALSE;
    if (llStringLength(review_text) < MIN_REVIEW_LENGTH) return FALSE;
    if (REVIEW_APPROVAL_REQUIRED) {
        gPendingReviews += [user_uuid, item_uuid, rating, review_text, llGetUnixTime()];
        llOwnerSay("Reseña enviada para aprobación");
    } else {
        gReviews += [user_uuid, item_uuid, rating, review_text, llGetUnixTime(), TRUE];
        llOwnerSay("Reseña añadida");
    }
    return TRUE;
}

float getAverageRating(string item_uuid) {
    integer total = 0;
    integer count = 0;
    integer i;
    for (i = 0; i < llGetListLength(gReviews); i += 6) {
        if (llList2String(gReviews, i + 1) == item_uuid && llList2Integer(gReviews, i + 5) == TRUE) {
            total += llList2Integer(gReviews, i + 2);
            count++;
        }
    }
    if (count == 0) return 0.0;
    return (float)total / (float)count;
}

default {
    state_entry() { llOwnerSay("Review System initialized"); }
}
