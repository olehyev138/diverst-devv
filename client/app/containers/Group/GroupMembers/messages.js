/*
 * User Messages
 *
 * This contains all the text for the User lists containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Members';

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
  changeScope: {
    id: `${scope}.index.label.changeScope`,
  },
  scopes: {
    accepted_users: {
      id: `${scope}.scopes.accepted_users`,
    },
    pending: {
      id: `${scope}.scopes.pending`,
    },
    inactive: {
      id: `${scope}.scopes.inactive`,
    },
    all: {
      id: `${scope}.scopes.all`,
    },
  },
  status: {
    active: {
      id: `${scope}.status.active`,
    },
    inactive: {
      id: `${scope}.status.inactive`,
    },
    pending: {
      id: `${scope}.status.pending`,
    },
  },
  filter: {
    from: {
      id: `${scope}.filter.from`,
    },
    to: {
      id: `${scope}.filter.to`,
    },
    fromMax: {
      id: `${scope}.filter.fromMax`,
    },
    toMax: {
      id: `${scope}.filter.toMax`,
    },
    toMin: {
      id: `${scope}.filter.toMin`,
    },
    segments: {
      id: `${scope}.filter.segments`,
    },
    submit: {
      id: `${scope}.filter.submit`,
    }
  },
  newmembers: {
    id: `${scope}.form.newmembers`,
  },
  members: {
    id: `${scope}.form.members`,
  },
  tooltip: {
    delete: {
      id: `${scope}.tooltip.delete`,
    }
  },
  columns: {
    givenName: {
      id: `${scope}.columns.givenName`,
    },
    familyName: {
      id: `${scope}.columns.familyName`,
    },
    status: {
      id: `${scope}.columns.status`,
    },
    actions: {
      id: `${scope}.columns.actions`,
    },
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
});
