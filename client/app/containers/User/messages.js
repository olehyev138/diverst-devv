/*
 * User Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.PollResponse';

export default defineMessages({
  form: {
    anonymous: {
      id: `${scope}.anonymous`
    },
    submit: {
      id: `${scope}.submit`
    },
  }
});
