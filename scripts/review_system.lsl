// ============================================
// Review System v1.2
// Módulo de reseñas para el HUD Creator.
// Cada reseña aprobada tiene 6 datos: usuario, producto, valoración,
// texto, fecha, aprobada. Las pendientes tienen 5 datos (sin aprobada).
// Se comunica con los demás scripts por mensajes de enlace (número 0).
// Comandos que recibe (link_message, num 0):
//   REV_ADD|usuario|producto|valoracion|texto -> responde REV_ADDED o REV_ERROR|motivo
//   REV_AVG|producto                          -> responde REV_AVG|producto|media|nReseñas
//   REV_APPROVE|n                             -> aprueba la reseña pendiente n, responde REV_APPROVED|n o REV_ERROR
//   REV_REJECT|n                              -> rechaza la reseña pendiente n, responde REV_REJECTED|n o REV_ERROR
//   REV_PENDING                               -> responde REV_PENDING|n
//   REV_COUNT|producto                        -> responde REV_COUNT|producto|n
// ============================================
integer MAX_RATING = 5;
integer MIN_REVIEW_LENGTH = 10;
integer REVIEW_APPROVAL_REQUIRED = TRUE;
list gReviews = [];
list gPendingReviews = [];

integer addReview(key user_uuid, string item_uuid, integer rating, string review_text)
{
    if (rating < 1 || rating > MAX_RATING) return FALSE;
    if (llStringLength(review_text) < MIN_REVIEW_LENGTH) return FALSE;
    if (REVIEW_APPROVAL_REQUIRED)
    {
        gPendingReviews += [user_uuid, item_uuid, rating, review_text, llGetUnixTime()];
        llOwnerSay("Reseña enviada para aprobación");
    }
    else
    {
        gReviews += [user_uuid, item_uuid, rating, review_text, llGetUnixTime(), TRUE];
        llOwnerSay("Reseña añadida");
    }
    return TRUE;
}

integer approveReview(integer rec)
{
    integer start = rec * 5;
    if (start < 0 || start + 4 >= llGetListLength(gPendingReviews)) return FALSE;
    list r = llList2List(gPendingReviews, start, start + 4);
    gReviews += r + [TRUE];
    gPendingReviews = llDeleteSubList(gPendingReviews, start, start + 4);
    return TRUE;
}

integer rejectReview(integer rec)
{
    integer start = rec * 5;
    if (start < 0 || start + 4 >= llGetListLength(gPendingReviews)) return FALSE;
    gPendingReviews = llDeleteSubList(gPendingReviews, start, start + 4);
    return TRUE;
}

float getAverageRating(string item_uuid)
{
    integer total = 0;
    integer count = 0;
    integer i;
    for (i = 0; i < llGetListLength(gReviews); i += 6)
    {
        if (llList2String(gReviews, i + 1) == item_uuid && llList2Integer(gReviews, i + 5) == TRUE)
        {
            total += llList2Integer(gReviews, i + 2);
            count++;
        }
    }
    if (count == 0) return 0.0;
    return (float)total / (float)count;
}

integer countReviews(string item_uuid)
{
    integer count = 0;
    integer i;
    for (i = 0; i < llGetListLength(gReviews); i += 6)
    {
        if (llList2String(gReviews, i + 1) == item_uuid && llList2Integer(gReviews, i + 5) == TRUE)
        {
            count++;
        }
    }
    return count;
}

default
{
    state_entry()
    {
    }

    link_message(integer sender, integer num, string msg, key id)
    {
        if (num != 0) return;
        list parts = llParseString2List(msg, ["|"], []);
        string cmd = llList2String(parts, 0);
        if (cmd == "REV_ADD")
        {
            key user = (key)llList2String(parts, 1);
            string item = llList2String(parts, 2);
            integer rating = llList2Integer(parts, 3);
            string text = llList2String(parts, 4);
            if (addReview(user, item, rating, text))
            {
                llMessageLinked(LINK_SET, 0, "REV_ADDED", "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "REV_ERROR|Valoración 1-5 y texto de 10 caracteres mínimo", "");
            }
        }
        else if (cmd == "REV_AVG")
        {
            string item = llList2String(parts, 1);
            llMessageLinked(LINK_SET, 0, "REV_AVG|" + item + "|" + (string)getAverageRating(item) + "|" + (string)countReviews(item), "");
        }
        else if (cmd == "REV_APPROVE")
        {
            integer rec = llList2Integer(parts, 1);
            if (approveReview(rec))
            {
                llMessageLinked(LINK_SET, 0, "REV_APPROVED|" + (string)rec, "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "REV_ERROR|Reseña pendiente no encontrada", "");
            }
        }
        else if (cmd == "REV_REJECT")
        {
            integer rec = llList2Integer(parts, 1);
            if (rejectReview(rec))
            {
                llMessageLinked(LINK_SET, 0, "REV_REJECTED|" + (string)rec, "");
            }
            else
            {
                llMessageLinked(LINK_SET, 0, "REV_ERROR|Reseña pendiente no encontrada", "");
            }
        }
        else if (cmd == "REV_PENDING")
        {
            llMessageLinked(LINK_SET, 0, "REV_PENDING|" + (string)(llGetListLength(gPendingReviews) / 5), "");
        }
        else if (cmd == "REV_COUNT")
        {
            string item = llList2String(parts, 1);
            llMessageLinked(LINK_SET, 0, "REV_COUNT|" + item + "|" + (string)countReviews(item), "");
        }
    }
}
