/*
 * Poll Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Poll';
export const snackbar = 'diverst,snackbars.Poll'

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
  createPublish: {
    id: `${scope}.form.button.createPublish`,
  },
  updatePublish: {
    id: `${scope}.form.button.updatePublish`,
  },
  createDraft: {
    id: `${scope}.form.button.createDraft`,
  },
  updateDraft: {
    id: `${scope}.form.button.updateDraft`,
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
  textual: {
    answer: {
      id: `${scope}.textual.table.answer`,
    },
    respondent: {
      id: `${scope}.textual.table.respondent`,
    },
    date: {
      id: `${scope}.textual.table.date`,
    },
    question: {
      id: `${scope}.textual.question`,
    },
  },
  snackbars: {
    errors: {
      polls: {
        id: `${snackbar}.errors.load.polls`
      },
      poll: {
        id: `${snackbar}.errors.load.poll`
      },
      create: {
        id: `${snackbar}.errors.create.poll`
      },
      delete: {
        id: `${snackbar}.errors.delete.poll`
      },
      update: {
        id: `${snackbar}.errors.update.poll`
      },
      create_publish: {
        id: `${snackbar}.errors.create.publish.poll`
      },
      update_publish: {
        id: `${snackbar}.errors.update.publish.poll`
      },
      publish: {
        id: `${snackbar}.errors.publish`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.poll`
      },
      delete: {
        id: `${snackbar}.success.delete.poll`
      },
      update: {
        id: `${snackbar}.success.update.poll`
      },
      create_publish: {
        id: `${snackbar}.success.create.publish.poll`
      },
      update_publish: {
        id: `${snackbar}.success.update.publish.poll`
      },
      publish: {
        id: `${snackbar}.success.publish`
      },
    },
  },
});
