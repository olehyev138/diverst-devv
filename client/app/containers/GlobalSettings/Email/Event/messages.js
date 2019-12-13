/*
 * Custom Text Messages
 *
 * This contains all the text for the Custom Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.GlobalSettings.EmailEvents';

export default defineMessages({
  everyday: {
    id: `${scope}.everyday`
  },
  form: {
    name: {
      id: `${scope}.form.name`,
    },
    disabled: {
      id: `${scope}.form.disabled`,
    },
    at: {
      id: `${scope}.form.at`,
    },
    tz: {
      id: `${scope}.form.tz`,
    },
    day: {
      id: `${scope}.form.day`,
    },
    update: {
      id: `${scope}.form.update`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
    },
  },
  index: {
    empty: {
      id: `${scope}.index.empty`,
    },
  },
});
