/*
 * Region Messages
 *
 * This contains all the text for the Regions containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Region';
export const snackbar = 'diverst.snackbars.Region';

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
  change_order: {
    id: `${scope}.index.button.change_order`,
  },
  set_order: {
    id: `${scope}.index.button.set_order`,
  },
  children_collapse: {
    id: `${scope}.index.button.children_collapse`,
  },
  children_expand: {
    id: `${scope}.index.button.children_expand`,
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
  name: {
    id: `${scope}.form.input.name`,
  },
  private: {
    id: `${scope}.form.input.private`,
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
  welcome: {
    id: `${scope}.home.span.welcome`,
  },
  family: {
    showMore: {
      id: `${scope}.family.showMore`,
    },
    showLess: {
      id: `${scope}.family.showLess`,
    },
    areMember: {
      id: `${scope}.family.areMember`,
    },
    notMember: {
      id: `${scope}.family.notMember`,
    }
  },
  snackbars: {
    errors: {
      group: {
        id: `${snackbar}.errors.region`
      },
      groups: {
        id: `${snackbar}.errors.regions`
      },
      create: {
        id: `${snackbar}.errors.create.region`
      },
      delete: {
        id: `${snackbar}.errors.delete.region`
      },
      update: {
        id: `${snackbar}.errors.update.region`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.region`
      },
      delete: {
        id: `${snackbar}.success.delete.region`
      },
      update: {
        id: `${snackbar}.success.update.region`
      },
    }
  }
});
