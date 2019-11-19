/*
 * User Messages
 *
 * This contains all the text for the UserRole containers/components.
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
  first_name: {
    id: `${scope}.form.input.first_name`,
  },
  last_name: {
    id: `${scope}.form.input.last_name`,
  },
  biography: {
    id: `${scope}.form.input.biography`,
  },
  time_zone: {
    id: `${scope}.form.input.time_zone`,
  },
  fields: {
    id: `${scope}.profile.fields`
  },
  privacy: {
    id: `${scope}.profile.privacy`
  },
  fields_save: {
    id: `${scope}.profile.fields.form.save`
  },
});
