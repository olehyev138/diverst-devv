/*
 * Requests Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.RequestList';
export const snackbar = 'diverst.snackbars.Mentorship.Requests';

export default defineMessages({
  columns: {
    notes: {
      id: `${scope}.column.notes`
    },
    type: {
      id: `${scope}.column.type`
    },
    status: {
      id: `${scope}.column.status`
    }
  },
  title: {
    outgoing: {
      id: `${scope}.title.outgoing`
    },
    incoming: {
      id: `${scope}.title.incoming`
    },
  },
  status: {
    pending: {
      id: `${scope}.status.pending`
    },
    accept: {
      id: `${scope}.status.accept`
    },
    reject: {
      id: `${scope}.status.reject`
    },
  },
  actions: {
    remove: {
      id: `${scope}.actions.remove`
    },
    approve: {
      id: `${scope}.actions.approve`
    },
    reject: {
      id: `${scope}.actions.reject`
    },
    viewProfile: {
      id: `${scope}.actions.viewProfile`
    },
    removeWarning: {
      id: `${scope}.actions.removeWarning`
    },
    approveWarning: {
      id: `${scope}.actions.approveWarning`
    },
    rejectWarning: {
      id: `${scope}.actions.rejectWarning`
    },
  },
  snackbars: {
    errors: {
      request: {
        id: `${snackbar}.errors.load.request`
      },
      proposal: {
        id: `${snackbar}.errors.load.proposal`
      },
      accept: {
        id: `${snackbar}.errors.accept.request`
      },
      reject: {
        id: `${snackbar}.errors.reject.request`
      },
      delete: {
        id: `${snackbar}.errors.delete.request`
      },
    },
    success: {
      accept: {
        id: `${snackbar}.success.accept.request`
      },
      reject: {
        id: `${snackbar}.success.reject.request`
      },
      delete: {
        id: `${snackbar}.success.delete.request`
      },
    }
  }
});
