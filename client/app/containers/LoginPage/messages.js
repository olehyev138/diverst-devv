/*
 * LoginPage Messages
 *
 * This contains all the text for the LoginPage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Login';

export default defineMessages({
  email: {
    id: `${scope}.input.email`,
  },
  invalidEmail: {
    id: `${scope}.input.email.invalid`,
  },
  findEnterprise: {
    id: `${scope}.links.findEnterprise`
  },
  login: {
    id: `${scope}.button.login`,
  },
  signup: {
    id: `${scope}.button.signup`,
  },
  password: {
    id: `${scope}.input.password`,
  },
  forgotPassword: {
    id: `${scope}.links.forgotPassword`,
  },
  invalidPassword: {
    id: `${scope}.input.password.invalid`,
  },
});
