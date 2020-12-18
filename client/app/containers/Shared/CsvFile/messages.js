/*
 * csv Messages
 *
 * This contains all the text for the csv saga.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Shared.csv';

export default defineMessages({
  snackbars: {
    errors: {
      create: {
        id: `${snackbar}.errors.create`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create`
      },
      upload: {
        id: `${snackbar}.success.upload`
      },
    },
  }
});
