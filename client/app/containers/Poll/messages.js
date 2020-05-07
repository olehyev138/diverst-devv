/*
 * Poll Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Poll';

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
  delete_confirm: {
    id: `${scope}.index.text.delete_confirm`,
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
    header: {
      create: {
        id: `${scope}.form.header.create`,
      },
      edit: {
        id: `${scope}.form.header.edit`,
      },
    },
    fieldHeader: {
      id: `${scope}.form.fieldHeader`,
    },
    title: {
      id: `${scope}.form.input.title`,
    },
    description: {
      id: `${scope}.form.input.description`,
    },
    groups: {
      id: `${scope}.form.input.groups`,
    },
    segments: {
      id: `${scope}.form.input.segments`,
    },
  },
  list: {
    name: {
      id: `${scope}.list.column.title`,
    },
    questions: {
      id: `${scope}.list.column.questions`,
    },
    responses: {
      id: `${scope}.list.column.responses`,
    },
    creationDate: {
      id: `${scope}.list.column.creationDate`,
    },
    status: {
      id: `${scope}.list.column.status`,
    },
    title: {
      id: `${scope}.list.title`,
    },
    edit: {
      id: `${scope}.list.tooltip.edit`,
    },
    delete: {
      id: `${scope}.list.tooltip.delete`,
    },
  },
  responses: {
    respondent: {
      id: `${scope}.responses.table.respondent`,
    },
    date: {
      id: `${scope}.responses.table.date`,
    },
    show: {
      id: `${scope}.responses.tooltip.show`,
    },
    title: {
      id: `${scope}.responses.title`,
    },
  },
});
