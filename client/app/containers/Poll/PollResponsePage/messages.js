/*
 * HomePage Messages
 *
 * This contains all the text for the HomePage container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.PollResponse';

export default defineMessages({
  form: {
    anonymous: {
      id: `${scope}.form.anonymous`
    },
    submit: {
      id: `${scope}.form.submit`
    },
    submitConfirmation: {
      id: `${scope}.form.submitConfirmation`
    },
  },
  fields: {
    fields: {
      id: `${scope}.fields.fields`
    },
    preface: {
      id: `${scope}.fields.preface`
    },
    create_field: {
      id: `${scope}.fields.create_field`
    },
    fields_save: {
      id: `${scope}.fields.fields_save`
    },
  }
});
