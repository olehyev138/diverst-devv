/*
 * Group Leader Messages
 *
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Group.Leaders';

export default defineMessages({
  snackbars: {
    errors: {
      leaders: {
        id: `${snackbar}.errors.load.leaders`
      },
      leader: {
        id: `${snackbar}.errors.load.leader`
      },
      create: {
        id: `${snackbar}.errors.create.leader`
      },
      delete: {
        id: `${snackbar}.errors.delete.leader`
      },
      update: {
        id: `${snackbar}.errors.update.leader`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.leader`
      },
      delete: {
        id: `${snackbar}.success.delete.leader`
      },
      update: {
        id: `${snackbar}.success.update.leader`
      },
    }
  }
});
