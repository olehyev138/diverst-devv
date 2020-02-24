/*
 * User Messages
 *
 * This contains all the text for the UserRole containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.UserRole';

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
  role_name: {
    id: `${scope}.form.input.role_name`,
  },
  role_type: {
    id: `${scope}.form.input.role_type`,
  },
  priority: {
    id: `${scope}.form.input.priority`,
  },
  title: {
    id: `${scope}.list.title`,
  },
  role: {
    admin: {
      id: `${scope}.role.admin`
    },
    group: {
      id: `${scope}.role.group`
    },
    user: {
      id: `${scope}.role.user`
    },
  }

});
