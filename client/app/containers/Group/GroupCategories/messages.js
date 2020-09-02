/*
 * Group Category Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group.Categories';
export const snackbar = 'diverst.snackbars.Group.Categories';

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
  delete_confirm: {
    id: `${scope}.index.button.delete_confirm`,
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
  labels: {
    id: `${scope}.form.input.labels`,
  },
  add_button: {
    id: `${scope}.form.button.add_button`,
  },
  add: {
    id: `${scope}.form.button.add`,
  },
  remove: {
    id: `${scope}.form.button.remove`,
  },
  nocategories: {
    id: `${scope}.list.nocategories`,
  },
  snackbars: {
    errors: {
      categories: {
        id: `${snackbar}.errors.load.categories`
      },
      category: {
        id: `${snackbar}.errors.load.category`
      },
      create: {
        id: `${snackbar}.errors.create.category`
      },
      delete: {
        id: `${snackbar}.errors.delete.category`
      },
      update: {
        id: `${snackbar}.errors.update.category`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.category`
      },
      delete: {
        id: `${snackbar}.success.delete.category`
      },
      update: {
        id: `${snackbar}.success.update.category`
      },
    }
  }
});
