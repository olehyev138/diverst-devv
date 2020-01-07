/*
 * Field Messages
 *
 * This contains all the text for the Fields containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Update';

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
  form: {
    dateOfUpdate: {
      id: `${scope}.index.form.dateOfUpdate`,
    },
    comments: {
      id: `${scope}.index.form.comments`,
    },
  }
});
