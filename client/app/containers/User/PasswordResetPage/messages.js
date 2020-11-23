/*
 * Password Reset Messages
 *
 * This contains all the text for the HomePage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.PasswordReset';
export const snackbar = 'diverst.snackbars.PasswordReset';

export default defineMessages({
  invalidToken: {
    id: `${snackbar}.invalid_token`
  },
  changePassword: {
    id: `${scope}.changePassword`
  },
  password: {
    id: `${scope}.password`
  },
  passwordConfirmation: {
    id: `${scope}.passwordConfirmation`
  },
});
