/*
 * Custom Text Messages
 *
 * This contains all the text for the Custom Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.GlobalSettings.EmailEvents';

export default defineMessages({
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
    update: {
      id: `${scope}.form.update`,
    },
  },
  preview: {
    title: {
      id: `${scope}.preview.title`,
    },
    subTitle: {
      id: `${scope}.preview.subTitle`,
    },
    subject: {
      id: `${scope}.preview.subject`,
    },
    body: {
      id: `${scope}.preview.body`,
    },
  },
  variables: {
    title: {
      id: `${scope}.variables.title`,
    },
    subTitle: {
      id: `${scope}.variables.subTitle`,
    },
  },
});
