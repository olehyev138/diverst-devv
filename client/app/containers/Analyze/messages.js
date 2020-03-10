/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group';

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
  children_collapse: {
    id: `${scope}.index.button.children_collapse`,
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
  name: {
    id: `${scope}.form.input.name`,
  },
  short_description: {
    id: `${scope}.form.input.short_description`,
  },
  description: {
    id: `${scope}.form.input.description`,
  },
  children: {
    id: `${scope}.form.input.children`,
  },
  parent: {
    id: `${scope}.form.input.parent`,
  },
  groupselect: {
    id: `${scope}.form.title`,
  },
  refresh: {
    id: `${scope}.form.button.refresh`,
  },
  delete_confirm: {
    id: `${scope}.customgraph.delete_confirm`,
  },
  selector: {
    one_month: {
      id: `${scope}.selector.button.one_month`,
    },
    three_month: {
      id: `${scope}.selector.button.three_month`,
    },
    six_month: {
      id: `${scope}.selector.button.six_month`,
    },
    YTD: {
      id: `${scope}.selector.button.YTD`,
    },
    one_year: {
      id: `${scope}.selector.button.one_year`,
    },
    from: {
      id: `${scope}.selector.text.from`,
    },
    to: {
      id: `${scope}.selector.text.to`,
    },
  }
});
