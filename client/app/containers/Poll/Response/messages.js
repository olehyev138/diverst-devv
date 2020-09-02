/*
 * Response
 *
 * This contains all the text for the Response containers/components.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Poll.Response';

export default defineMessages({
  snackbars: {
    errors: {
      response: {
        id: `${snackbar}.errors.load.response`
      },
      responses: {
        id: `${snackbar}.errors.load.responses`
      },
    },
  }
});
