/*
 * Messages
 *
 * This contains all the text for the Answer containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Innovate';
export const snackbar = 'diverst.snackbars.Analyze.Answer';

export default defineMessages({
  create: {
    id: `${scope}.answer.button.create`,
  },
  snackbars: {
    errors: {
      answer: {
        id: `${snackbar}.errors.load.answer`
      },
      answers: {
        id: `${snackbar}.errors.load.answers`
      },
      create: {
        id: `${snackbar}.errors.create.answer`
      },
      update: {
        id: `${snackbar}.errors.update.answer`
      },
      delete: {
        id: `${snackbar}.errors.delete.answer`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.answer`
      },
      update: {
        id: `${snackbar}.success.update.answer`
      },
      delete: {
        id: `${snackbar}.success.delete.answer`
      },
    }
  }
});
