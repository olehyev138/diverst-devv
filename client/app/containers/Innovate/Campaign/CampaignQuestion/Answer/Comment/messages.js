/*
 * Messages
 *
 * This contains all the text for the User lists containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Members';
export const snackbar = 'diverst.snackbars.Analyze.Comment';

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
  snackbars: {
    errors: {
      comment: {
        id: `${snackbar}.errors.load.comment`
      },
      comments: {
        id: `${snackbar}.errors.load.comments`
      },
      create: {
        id: `${snackbar}.errors.create.comment`
      },
      update: {
        id: `${snackbar}.errors.update.comment`
      },
      delete: {
        id: `${snackbar}.errors.delete.comment`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.comment`
      },
      update: {
        id: `${snackbar}.success.update.comment`
      },
      delete: {
        id: `${snackbar}.success.delete.comment`
      },
    }
  }
});
