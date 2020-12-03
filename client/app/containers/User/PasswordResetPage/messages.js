/*
 * Password Reset Messages
 *
 * This contains all the text for the HomePage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.PasswordReset';
export const snackbar = 'diverst.snackbars.PasswordReset';

export default defineMessages({
  changePassword: {
    id: `${scope}.changePassword`
  },
  password: {
    id: `${scope}.password`
  },
  passwordConfirmation: {
    id: `${scope}.passwordConfirmation`
  },
  emailSent: {
    id: `${snackbar}.email_sent`
  },
  invalidToken: {
    id: `${snackbar}.invalid_token`
  },
  passwordChange: {
    id: `${snackbar}.password_change`
  },
});
