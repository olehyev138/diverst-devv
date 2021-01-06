/*
 * Event Messages
 *
 * This contains all the text for the Event container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.EventExpenses';
export const snackbar = 'diverst.snackbars.Event.Expense';

export default defineMessages({
  columns: {
    description: {
      id: `${scope}.columns.description`,
    },
    amount: {
      id: `${scope}.columns.amount`,
    },
    createdAt: {
      id: `${scope}.columns.createdAt`,
    },
  },
  actions: {
    edit: {
      id: `${scope}.actions.edit`,
    },
    delete: {
      id: `${scope}.actions.delete`,
    },
  },
  buttons: {
    new: {
      id: `${scope}.buttons.new`,
    },
    close: {
      id: `${scope}.buttons.close`,
    },
    closeConfirm: {
      id: `${scope}.buttons.closeConfirm`,
    },
  },
  form: {
    description: {
      id: `${scope}.form.description`,
    },
    amount: {
      id: `${scope}.form.amount`,
    },
    budgetItem: {
      id: `${scope}.form.budgetItem`,
    },
    title: {
      id: `${scope}.form.title`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
    },
    create: {
      id: `${scope}.form.create`,
    },
    update: {
      id: `${scope}.form.update`,
    },
  },
  final: {
    id: `${scope}.final`,
  },
  total: {
    id: `${scope}.total`,
  },
  estimated: {
    id: `${scope}.estimated`,
  },
  free: {
    id: `${scope}.free`,
  },
  close: {
    id: `${scope}.close`,
  },
  title: {
    id: `${scope}.title`,
  },
  pressure: {
    id: `${scope}.pressure`,
  },
  snackbars: {
    errors: {
      expense: {
        id: `${snackbar}.errors.load.expense`
      },
      expenses: {
        id: `${snackbar}.errors.load.expenses`
      },
      create: {
        id: `${snackbar}.errors.create.expense`
      },
      update: {
        id: `${snackbar}.errors.update.expense`
      },
      delete: {
        id: `${snackbar}.errors.delete.expense`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.expense`
      },
      update: {
        id: `${snackbar}.success.update.expense`
      },
      delete: {
        id: `${snackbar}.success.delete.expense`
      },
    }
  }
});
