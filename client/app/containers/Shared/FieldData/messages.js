/*
 * field data Messages
 *
 * This contains all the text for the field data saga.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Shared.fielddata';

export default defineMessages({
  snackbars: {
    errors: {
      update: {
        id: `${snackbar}.errors.update`
      },
    },
    success: {
      update: {
        id: `${snackbar}.success.update`
      },
    },
  }
});
