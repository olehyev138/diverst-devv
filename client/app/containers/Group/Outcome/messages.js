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
  name: {
    id: `${scope}.form.input.name`,
  },
  pillars: {
    text: {
      id: `${scope}.Pillar.text`,
    },
    delete: {
      id: `${scope}.Pillar.form.button.delete`,
    },
    name: {
      id: `${scope}.Pillar.form.input.name`,
    },
    value: {
      id: `${scope}.Pillar.form.input.value`,
    },
  },
});
