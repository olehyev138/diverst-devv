/*
 * Field Messages
 *
 * This contains all the text for the Fields containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Field';

export default defineMessages({
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
});
