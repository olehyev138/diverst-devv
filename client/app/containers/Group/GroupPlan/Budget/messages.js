/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Budget';
export const snackbar = 'diverst.snackbars.Group.Budget';

export default defineMessages({
  columns: {
    requested: {
      id: `${scope}.index.columns.requested`,
    },
    available: {
      id: `${scope}.index.columns.available`,
    },
    status: {
      id: `${scope}.index.columns.status`,
    },
    requestedAt: {
      id: `${scope}.index.columns.requestedAt`,
    },
    number: {
      id: `${scope}.index.columns.number`,
    },
    description: {
      id: `${scope}.index.columns.description`,
    },
  },
  actions: {
    details: {
      id: `${scope}.index.actions.details`,
    },
    delete: {
      id: `${scope}.index.actions.delete`,
    },
  },
  buttons: {
    new: {
      id: `${scope}.index.buttons.new`,
    },
    back: {
      id: `${scope}.index.buttons.back`,
    },
  },
  tableTitle: {
    id: `${scope}.index.tableTitle`,
  },
  snackbars: {
    errors: {
      budget: {
        id: `${snackbar}.errors.load.budget`
      },
      budgets: {
        id: `${snackbar}.errors.load.budgets`
      },
      budget_request: {
        id: `${snackbar}.errors.create.budget_request`
      },
      decline: {
        id: `${snackbar}.errors.decline.budget`
      },
      approve: {
        id: `${snackbar}.errors.approve.budget`
      },
      delete: {
        id: `${snackbar}.errors.delete.budget`
      },
    },
    success: {
      budget_request: {
        id: `${snackbar}.success.create.budget_request`
      },
      decline: {
        id: `${snackbar}.success.decline.budget`
      },
      approve: {
        id: `${snackbar}.success.approve.budget`
      },
      delete: {
        id: `${snackbar}.success.delete.budget`
      },
    }
  }
});
