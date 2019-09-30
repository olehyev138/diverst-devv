/*
 * Folder Messages
 *
 * This contains all the text for the Folder container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Folder';

export default defineMessages({
  folders: {
    id: `${scope}.folders`
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
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  index: {
    emptySection: {
      id: `${scope}.index.empty`
    },
  },
  form: {
    name: {
      id: `${scope}.form.input.name`,
    },
    parent: {
      id: `${scope}.form.input.folder`,
    },
    protected: {
      id: `${scope}.form.input.protected`,
    },
    password: {
      id: `${scope}.form.input.password`,
    },
  },
  show: {
    addFolder: {
      id: `${scope}.show.addFolder`,
    },
    addResource: {
      id: `${scope}.show.addResource`,
    },
    parent: {
      id: `${scope}.show.parentFolder`
    },
  },
});
