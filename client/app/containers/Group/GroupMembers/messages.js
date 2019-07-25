/*
 * User Messages
 *
 * This contains all the text for the User lists containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.User';

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
    id: `${scope}.form.button.edit`,
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
});
