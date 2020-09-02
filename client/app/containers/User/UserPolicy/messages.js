/*
 * Custom Text Messages
 *
 * This contains all the text for the UserPolicy Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Policies';
export const snackbar = 'diverst.snackbars.User.Policy';

export default defineMessages({
  form: {
    update: {
      id: `${scope}.form.update`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
    },
  },
  snackbars: {
    errors: {
      policy: {
        id: `${snackbar}.errors.load.policy`
      },
      policies: {
        id: `${snackbar}.errors.load.policies`
      },
      create: {
        id: `${snackbar}.errors.create.policy`
      },
      delete: {
        id: `${snackbar}.errors.delete.policy`
      },
      update: {
        id: `${snackbar}.errors.update.policy`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.policy`
      },
      delete: {
        id: `${snackbar}.success.delete.policy`
      },
      update: {
        id: `${snackbar}.success.update.policy`
      },
    }
  }
});
