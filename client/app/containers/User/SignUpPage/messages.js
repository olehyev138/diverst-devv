/*
 * HomePage Messages
 *
 * This contains all the text for the HomePage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.SignUp';
export const snackbar = 'diverst.snackbars.SignUp';

export default defineMessages({
  invitation: {
    id: `${snackbar}.invitation`
  },
  activate: {
    id: `${scope}.activate`
  },
  group_select: {
    id: `${scope}.group_select`
  },
  password: {
    id: `${scope}.password`
  },
  passwordConfirmation: {
    id: `${scope}.passwordConfirmation`
  },
  consentTitle: {
    id: `${scope}.consentTitle`
  },
  consentAccept: {
    id: `${scope}.consentAccept`
  },
  token: {
    id: 'diverst.containers.App.texts.signup'
  }
});
