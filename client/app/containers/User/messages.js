/*
 * User Messages
 *
 * This contains all the text for the Users containers/components.
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
  fields: {
    id: `${scope}.profile.fields`
  },
  preface: {
    id: `${scope}.profile.privacy`
  },
  fields_save: {
    id: `${scope}.profile.fields.form.save`
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
});
