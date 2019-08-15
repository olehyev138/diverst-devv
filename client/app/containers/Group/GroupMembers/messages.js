/*
 * User Messages
 *
 * This contains all the text for the User lists containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Members';

export default defineMessages({
  new: {
    id: `${scope}.index.button.new`,
  },
  export: {
    id: `${scope}.index.button.export`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
});
