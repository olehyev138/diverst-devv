/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Segment';

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
  delete_message: {
    id: `${scope}.index.text.delete_message`,
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
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  form: {
    name: {
      id: `${scope}.form.input.name`,
    },
    active_filter: {
      id: `${scope}.form.label.active_filter`,
    },
    field_rule: {
      id: `${scope}.form.label.field_rule`,
    },
    order_rule: {
      id: `${scope}.form.label.order_rule`,
    },
    scope_rule: {
      id: `${scope}.form.label.scope_rule`,
    },
  }
});
