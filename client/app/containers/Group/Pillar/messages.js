/*
 * Pillar Messages
 *
 * This contains all the text for the Pillar containers/components.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Group.Pillar';

export default defineMessages({
  snackbars: {
    errors: {
      pillars: {
        id: `${snackbar}.errors.load.pillars`
      },
      pillar: {
        id: `${snackbar}.errors.load.pillar`
      },
      create: {
        id: `${snackbar}.errors.create.pillar`
      },
      delete: {
        id: `${snackbar}.errors.delete.pillar`
      },
      update: {
        id: `${snackbar}.errors.update.pillar`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.pillar`
      },
      delete: {
        id: `${snackbar}.success.delete.pillar`
      },
      update: {
        id: `${snackbar}.success.update.pillar`
      },
    },
  },
});
