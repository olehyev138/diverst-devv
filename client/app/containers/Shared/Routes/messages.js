/*
 * Route Messages
 *
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Routes';

export default defineMessages({
  user: {
    home: {
      id: `${scope}.user.home`,
    },
    innovate: {
      id: `${scope}.user.innovate`,
    },
    news: {
      id: `${scope}.user.news`,
    },
    events: {
      id: `${scope}.user.events`,
    },
    groups: {
      id: `${scope}.user.groups`,
    },
    downloads: {
      id: `${scope}.user.downloads`,
    },
    mentorship: {
      id: `${scope}.user.mentorship`,
    },
  },
  admin: {
    analyze: {
      index: {
        id: `${scope}.admin.analyze.index`,
      },
      overview: {
        id: `${scope}.admin.analyze.overview`,
      },
      users: {
        id: `${scope}.admin.analyze.users`,
      }
    },
    manage: {
      index: {
        id: `${scope}.admin.manage.index`,
      },
      groups: {
        id: `${scope}.admin.manage.groups`,
      },
    },
    system: {
      index: {
        id: `${scope}.admin.system.index`,
      }
    }
  }
});
