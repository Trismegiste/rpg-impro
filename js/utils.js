/*
 * some global functions
 */

function hashCode(str) {
    var hash = 0, i, chr;

    if (str.length === 0)
        return hash;

    for (i = 0; i < str.length; i++) {
        chr = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + chr;
        hash |= 0; // Convert to 32bit integer
    }

    return (hash >>> 0).toString(16)
}

function scrollTo(id) {
    var obj = document.getElementById(id)
    if (obj) {
        window.scrollTo(0, obj.offsetTop)
    }
}