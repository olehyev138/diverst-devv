/*
 * Mentorship Messages
 *
 * This contains all the text for the Users containers/components.
 */

/*
  Outgoing Request(s)
  Incoming Request(s)

  First Name
  Last Name
  Notes
  Type
  Status

  Mentor
  Mentee

  Accepted
  Rejected
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.RequestList';

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
  }
});
