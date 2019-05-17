/*
 * LoginPage Messages
 *
 * This contains all the text for the LoginPage component.
 */
import { defineMessages } from "react-intl";

export const scope = "diverst.containers.Login";

export default defineMessages({
    login: {
        id: `${scope}.button.login`,
    },
    signup: {
        id: `${scope}.button.signup`,
    },
    email: {
        id: `${scope}.input.email`,
    },
    password: {
        id: `${scope}.input.password`,
    },
    forgotPassword: {
        id: `${scope}.links.forgotPassword`,
    },
    findCompany: {
        id: `${scope}.links.findCompany`
    }
});
