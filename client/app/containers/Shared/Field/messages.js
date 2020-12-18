/*
 * Field Messages
 *
 * This contains all the text for the Fields containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Field';
export const snackbar = 'diverst.snackbars.Shared.Field';

export default defineMessages({
  form: {
    hide: {
      id: `${scope}.form.hide`,
    },
    show: {
      id: `${scope}.form.show`,
    },
    required: {
      id: `${scope}.form.required`,
    },
    edit: {
      id: `${scope}.form.edit`,
    },
  },
  newTextField: {
    id: `${scope}.index.button.textField.new`,
  },
  newCheckBoxField: {
    id: `${scope}.index.button.checkboxField.new`,
  },
  newSelectField: {
    id: `${scope}.index.button.selectField.new`,
  },
  newDateField: {
    id: `${scope}.index.button.dateField.new`,
  },
  newNumericField: {
    id: `${scope}.index.button.numericField.new`,
  },
  textField: {
    id: `${scope}.index.button.textField`,
  },
  checkBoxField: {
    id: `${scope}.index.button.checkboxField`,
  },
  selectField: {
    id: `${scope}.index.button.selectField`,
  },
  dateField: {
    id: `${scope}.index.button.dateField`,
  },
  numericField: {
    id: `${scope}.index.button.numericField`,
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
  title: {
    id: `${scope}.form.input.title`,
  },
  options: {
    id: `${scope}.form.input.options`,
  },
  min: {
    id: `${scope}.form.input.min`,
  },
  max: {
    id: `${scope}.form.input.max`,
  },
  header: {
    id: `${scope}.form.header`,
  },
  change_order: {
    id: 'diverst.containers.Group.index.button.change_order',
  },
  set_order: {
    id: 'diverst.containers.Group.index.button.set_order',
  },
  snackbars: {
    errors: {
      field: {
        id: `${snackbar}.errors.load.field`
      },
      fields: {
        id: `${snackbar}.errors.load.fields`
      },
      create: {
        id: `${snackbar}.errors.create.field`
      },
      update: {
        id: `${snackbar}.errors.update.field`
      },
      delete: {
        id: `${snackbar}.errors.delete.field`
      },
      position: {
        id: `${snackbar}.errors.position.field`
      }
    },
    success: {
      create: {
        id: `${snackbar}.success.create.field`
      },
      update: {
        id: `${snackbar}.success.update.field`
      },
      delete: {
        id: `${snackbar}.success.delete.field`
      },
      position: {
        id: `${snackbar}.success.position.field`
      }
    }
  }
});
