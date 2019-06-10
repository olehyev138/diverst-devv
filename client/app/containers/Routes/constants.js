import messages from './messages';

// Routes structure (WIP)
export const ROUTES = {
  // Session
  session: {
    login: {
      path: '/login',
    },
  },

  // User
  user: {
    get root() { return this.home; },
    home: {
      path: '/',
      titleMessage: messages.user.home,
    },
    innovate: {
      path: '/user/campaigns',
      titleMessage: messages.user.innovate,
    },
    news: {
      path: '/user/news',
      titleMessage: messages.user.news,
    },
    events: {
      path: '/user/events',
      titleMessage: messages.user.events,
    },
    groups: {
      path: '/user/groups',
      titleMessage: messages.user.groups,
    },
    downloads: {
      path: '/user/downloads',
      titleMessage: messages.user.downloads,
    },
    mentorship: {
      path: '/user/mentorship',
      titleMessage: messages.user.mentorship,
    },
  },

  // Group
  group: {
    get root() { return this.home; },
    home: {
      path: '/group',
    },
  },

  // Admin
  admin: {
    get root() { return this.analytics.overview; },
    pathPrefix: '/admin',
    analytics: {
      pathPrefix: '/admin/analytics',
      overview: {
        path: '/admin/analytics',
      },
      users: {
        path: '/admin/analytics/users',
      },
    },
  },
};
