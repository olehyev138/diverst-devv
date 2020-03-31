/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Budget';

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
});
