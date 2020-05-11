/*
 * Resource Messages
 *
 * This contains all the text for the Resource container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Resource';

export default defineMessages({
  resources: {
    id: `${scope}.resources`
  },
  new: {
    id: `${scope}.index.button.new`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  confirm_delete: {
    id: `${scope}.index.button.confirm_delete`,
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
  archive: {
    id: `${scope}.index.button.archive`,
  },
  form: {
    title: {
      id: `${scope}.form.input.title`,
    },
    folder: {
      id: `${scope}.form.input.folder`,
    },
    url: {
      id: `${scope}.form.input.url`,
    },
    file: {
      id: `${scope}.form.input.file`,
    },
  },
});
