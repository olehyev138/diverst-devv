/*
 *
 * LanguageProvider actions
 *
 */

import { CHANGE_PRIMARY, CHANGE_SECONDARY } from "./constants";

export function changePrimary(color) {
    return {
        type: CHANGE_PRIMARY,
        color: color,
    };
}

export function changeSecondary(color) {
    return {
        type: CHANGE_SECONDARY,
        color: color,
    };
}
