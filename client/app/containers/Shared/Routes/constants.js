import messages from 'containers/Shared/Routes/messages';

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
      path: '/campaigns',
      titleMessage: messages.user.innovate,
    },
    news: {
      path: '/news',
      titleMessage: messages.user.news,
    },
    events: {
      path: '/events',
      titleMessage: messages.user.events,
    },
    groups: {
      path: '/groups',
      titleMessage: messages.user.groups,
    },
    downloads: {
      path: '/downloads',
      titleMessage: messages.user.downloads,
    },
    mentorship: {
      path: '/mentorship',
      titleMessage: messages.user.mentorship,
    },
  },

  // Admin
  admin: {
    get root() { return this.analyze.overview; },
    pathPrefix: '/admin',
    analyze: {
      pathPrefix: '/admin/analyze',
      overview: {
        path: '/admin/analyze',
        titleMessage: messages.admin.analyze.overview,
      },
      users: {
        path: '/admin/analyze/users',
        titleMessage: messages.admin.analyze.users,
      },
    },
    manage: {
      pathPrefix: '/admin/manage',
      groups: {
        index: {
          path: '/admin/manage/groups',
          titleMessage: messages.admin.manage.groups,
        },
        new: {
          path: '/admin/manage/groups/new',
        },
        edit: {
          path: '/admin/manage/groups/edit',
        },
        delete: {
          path: '/admin/manage/groups/delete',
        },
      }
    },
  },
};
