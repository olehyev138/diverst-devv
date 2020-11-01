/*
 * User Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.User';
export const snackbar = 'diverst.snackbars.User';

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
  first_name: {
    id: `${scope}.form.input.first_name`,
  },
  last_name: {
    id: `${scope}.form.input.last_name`,
  },
  email: {
    id: `${scope}.form.input.email`,
  },
  avatar: {
    id: `${scope}.form.input.avatar`,
  },
  biography: {
    id: `${scope}.form.input.biography`,
  },
  time_zone: {
    id: `${scope}.form.input.time_zone`,
  },
  active: {
    id: `${scope}.form.input.active`,
  },
  user_role: {
    id: `${scope}.form.input.user_role`,
  },
  generalTab: {
    id: `${scope}.form.tab.general`,
  },
  fieldTab: {
    id: `${scope}.form.tab.field`,
  },
  email_warning: {
    id: `${scope}.form.email.warning`
  },
  fields: {
    id: `${scope}.profile.fields`
  },
  preface: {
    id: `${scope}.profile.privacy`
  },
  fields_save: {
    id: `${scope}.profile.fields.form.save`
  },
  admin_fields: {
    id: `${scope}.profile.form.admin_fields`
  },
  scopes: {
    all: {
      id: `${scope}.scope.all`,
    },
    inactive: {
      id: `${scope}.scope.inactive`
    },
    invitation_sent: {
      id: `${scope}.scope.invitation_sent`
    },
    saml: {
      id: `${scope}.scope.saml`
    },
  },
  imports: {
    title: {
      id: `${scope}.import.title`,
    },
    importInstructionsTitle: {
      id: `${scope}.import.importInstructionsTitle`,
    },
    importInstructions: {
      id: `${scope}.import.importInstructions`,
    },
    columnInstructionsTitle: {
      id: `${scope}.import.columnInstructionsTitle`,
    },
    columnInstructions: {
      id: `${scope}.import.columnInstructions`,
    },
    rowsInstructionsTitle: {
      id: `${scope}.import.rowsInstructionsTitle`,
    },
    rowsInstructions: {
      id: `${scope}.import.rowsInstructions`,
    },
    SampleInstructionsTitle: {
      id: `${scope}.import.SampleInstructionsTitle`,
    },
    SampleInstructions: {
      id: `${scope}.import.SampleInstructions`,
    },
  },
  downloads: {
    title: {
      id: `${scope}.downloads.title`
    },
    empty: {
      id: `${scope}.downloads.empty`
    },
    expireInfo: {
      id: `${scope}.downloads.expireInfo`
    },
    downloadButton: {
      id: `${scope}.downloads.downloadButton`
    },
  },
  tab: {
    users: {
      id: `${scope}.tab.users`
    },
    roles: {
      id: `${scope}.tab.roles`
    },
    policy: {
      id: `${scope}.tab.policy`
    }
  },
  members: {
    id: `${scope}.list.members`
  },
  tooltip: {
    edit: {
      id: `${scope}.tooltip.edit`
    },
    delete: {
      id: `${scope}.tooltip.delete`
    },
  },
  snackbars: {
    errors: {
      user: {
        id: `${snackbar}.errors.load.user`
      },
      users: {
        id: `${snackbar}.errors.load.users`
      },
      posts: {
        id: `${snackbar}.errors.load.posts`
      },
      events: {
        id: `${snackbar}.errors.load.events`
      },
      downloads: {
        id: `${snackbar}.errors.load.downloads`
      },
      create: {
        id: `${snackbar}.errors.create.user`
      },
      delete: {
        id: `${snackbar}.errors.delete.user`
      },
      update: {
        id: `${snackbar}.errors.update.user`
      },
      fields: {
        id: `${snackbar}.errors.fields`
      },
      export: {
        id: `${snackbar}.errors.export`
      },
      import: {
        id: `${snackbar}.errors.import`
      },
      user_data: {
        id: `${snackbar}.errors.user_data`
      },
      prototype: {
        id: `${snackbar}.errors.prototype`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.user`
      },
      delete: {
        id: `${snackbar}.success.delete.user`
      },
      update: {
        id: `${snackbar}.success.update.user`
      },
      fields: {
        id: `${snackbar}.success.fields`
      },
      export: {
        id: `${snackbar}.success.export`
      },
    }
  }
});
