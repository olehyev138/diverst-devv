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
  index: {
    emptySection: {
      id: `${scope}.index.empty`
    },
    loading: {
      id: `${scope}.index.loading`
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
    password_question: {
      id: `${scope}.form.input.password_question`,
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
    empty: {
      id: `${scope}.show.empty`
    }
  },
  authenticate: {
    label1: {
      id: `${scope}.authenticate.label1`,
    },
    label2: {
      id: `${scope}.authenticate.label2`,
    },
    password: {
      id: `${scope}.authenticate.password`,
    },
    button: {
      id: `${scope}.authenticate.button`,
    },
  }
});
