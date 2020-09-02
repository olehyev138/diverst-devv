/*
 * Innovate
 *
 * This contains all the text for the Log containers/components.
 */

import { defineMessages } from 'react-intl';
import { scope } from '../Innovate/Campaign/messages';

export const snackbar = 'diverst.snackbars.Log';


export default defineMessages({
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
