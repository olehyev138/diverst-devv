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
  groups: {
    home: {
      id: `${scope}.group.home`
    },
    members: {
      index: {
        id: `${scope}.group.members.index`
      }
    },
    events: {
      index: {
        id: `${scope}.group.events.index`
      }
    },
    news: {
      index: {
        id: `${scope}.group.news.index`
      }
    },
    outcomes: {
      index: {
        id: `${scope}.group.outcomes.index`
      }
    },
    resources: {
      id: `${scope}.group.resources.index`
    }
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
      },
      groups: {
        id: `${scope}.admin.analyze.groups`,
      }
    },
    manage: {
      index: {
        id: `${scope}.admin.manage.index`,
      },
      groups: {
        id: `${scope}.admin.manage.groups`,
      },
      segments: {
        id: `${scope}.admin.manage.segments`,
      },
    },
    system: {
      index: {
        id: `${scope}.admin.system.index`,
      },
      users: {
        id: `${scope}.admin.system.users`,
      }
    }
  }
});
