/*
 * Field Messages
 *
 * This contains all the text for the Fields containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Update';
export const snackbar = 'diverst.snackbars.Shared.Update';

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
  deleteConfirmation: {
    id: `${scope}.index.button.deleteConfirmation`,
  },
  fields: {
    id: `${scope}.fields`,
  },
  preface: {
    id: `${scope}.preface`,
  },
  create_field: {
    id: `${scope}.create_field`,
  },
  fields_save: {
    id: `${scope}.fields_save`,
  },
  show: {
    previous: {
      id: `${scope}.show.previous`,
    },
    next: {
      id: `${scope}.show.next`,
    },
    variance: {
      id: `${scope}.show.variance`
    }
  },
  form: {
    dateOfUpdate: {
      id: `${scope}.index.form.dateOfUpdate`,
    },
    comments: {
      id: `${scope}.index.form.comments`,
    },
    button: {
      create: {
        id: `${scope}.index.form.button.create`,
      },
      update: {
        id: `${scope}.index.form.button.update`,
      },
      cancel: {
        id: `${scope}.index.form.button.cancel`,
      },
    },
  },
  snackbars: {
    errors: {
      get_update: {
        id: `${snackbar}.errors.load.update`
      },
      updates: {
        id: `${snackbar}.errors.load.updates`
      },
      prototype: {
        id: `${snackbar}.errors.load.prototype`
      },
      create: {
        id: `${snackbar}.errors.create.update`
      },
      update: {
        id: `${snackbar}.errors.update.update`
      },
      delete: {
        id: `${snackbar}.errors.delete.update`
      }
    },
    success: {
      create: {
        id: `${snackbar}.success.create.update`
      },
      update: {
        id: `${snackbar}.success.update.update`
      },
      delete: {
        id: `${snackbar}.success.delete.update`
      }
    }
  }
});
