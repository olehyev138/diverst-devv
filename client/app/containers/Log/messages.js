/*
 * Innovate
 *
 * This contains all the text for the Log containers/components.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Log';
export const scope = 'diverst.containers.Log';

export default defineMessages({
  from: {
    id: `${scope}.from`
  },
  to: {
    id: `${scope}.to`
  },
  filter: {
    id: `${scope}.filter`
  },
  snackbars: {
    errors: {
      logs: {
        id: `${snackbar}.errors.load.logs`
      },
      export: {
        id: `${snackbar}.errors.export.logs`
      },
    },
    success: {
      export: {
        id: `${snackbar}.success.export.logs`
      },
    }
  }
});
