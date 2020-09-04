/*
 * Custom Text Messages
 *
 * This contains all the text for the Custom Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.GlobalSettings.Emails';
export const snackbar = 'diverst.snackbars.GlobalSettings.Email';

export default defineMessages({
  form: {
    title: {
      id: `${scope}.form.title`,
    },
    subject: {
      id: `${scope}.form.subject`,
    },
    content: {
      id: `${scope}.form.content`,
    },
    update: {
      id: `${scope}.form.update`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
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
  index: {
    empty: {
      id: `${scope}.index.empty`,
    },
  },
  snackbars: {
    errors: {
      email: {
        id: `${snackbar}.errors.load.email`
      },
      emails: {
        id: `${snackbar}.errors.load.emails`
      },
      update: {
        id: `${snackbar}.errors.update.email`
      },
    },
    success: {
      update: {
        id: `${snackbar}.success.email`
      },
    }
  }
});
