/*
 * Outcome Messages
 *
 * This contains all the text for the Outcomes containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group.Outcome';

export default defineMessages({
  new: {
    id: `${scope}.index.button.new`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  rows: {
    id: `${scope}.index.button.rows`,
  },
  page: {
    id: `${scope}.index.button.page`,
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.edit`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  inputs: {
    name: {
      id: `${scope}.form.input.name`,
    },
  },
  empty: {
    id: `${scope}.empty`,
  },
  editStructure: {
    id: `${scope}.structure.edit`
  },
  return: {
    id: `${scope}.index.return`
  },
  pillars: {
    text: {
      id: `${scope}.Pillar.text`,
    },
    delete: {
      id: `${scope}.Pillar.form.button.delete`,
    },
    empty: {
      id: `${scope}.Pillar.empty`,
    },
    inputs: {
      name: {
        id: `${scope}.Pillar.form.input.name`,
      },
      value: {
        id: `${scope}.Pillar.form.input.value`,
      },
    },
    events: {
      new: {
        id: `${scope}.Pillar.Event.button.new`
      },
      empty: {
        id: `${scope}.Pillar.Event.empty`
      }
    },
  },
});
