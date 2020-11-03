/*
 * Region Leader Messages
 *
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Region.Leaders';
export const snackbar = 'diverst.snackbars.Region.Leaders';

export default defineMessages({
  create: {
    id: `${scope}.create`
  },
  update: {
    id: `${scope}.update`
  },
  new: {
    id: `${scope}.new`
  },
  edit: {
    id: `${scope}.edit`
  },
  delete: {
    id: `${scope}.delete`
  },
  form: {
    select: {
      id: `${scope}.form.select`
    },
    role: {
      id: `${scope}.form.role`
    },
    position: {
      id: `${scope}.form.position`
    },
  },
  table: {
    title: {
      id: `${scope}.table.title`
    },
    column_name: {
      id: `${scope}.table.column_name`,
    },
    column_position: {
      id: `${scope}.table.column_position`,
    },
  },
  snackbars: {
    errors: {
      leaders: {
        id: `${snackbar}.errors.leaders`
      },
      leader: {
        id: `${snackbar}.errors.leader`
      },
      create: {
        id: `${snackbar}.errors.create`
      },
      delete: {
        id: `${snackbar}.errors.delete`
      },
      update: {
        id: `${snackbar}.errors.update`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create`
      },
      delete: {
        id: `${snackbar}.success.delete`
      },
      update: {
        id: `${snackbar}.success.update`
      },
    }
  }
});
