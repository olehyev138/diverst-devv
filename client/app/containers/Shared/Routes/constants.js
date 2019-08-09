import messages from 'containers/Shared/Routes/messages';

// Routes structure
export const ROUTES = {
  // Session
  session: {
    login: {
      path: () => '/login',
    },
  },

  // User
  user: {
    get root() { return this.home; },
    home: {
      path: () => '/',
      data: {
        titleMessage: messages.user.home,
      }
    },
    innovate: {
      path: () => '/campaigns',
      data: {
        titleMessage: messages.user.innovate,
        permission: 'campaigns_index',
      }
    },
    news: {
      path: () => '/news',
      data: {
        titleMessage: messages.user.news,
      }
    },
    events: {
      path: () => '/events',
      data: {
        titleMessage: messages.user.events,
      }
    },
    groups: {
      path: () => '/groups',
      data: {
        titleMessage: messages.user.groups,
      }
    },
    downloads: {
      path: () => '/downloads',
      data: {
        titleMessage: messages.user.downloads,
      }
    },
    mentorship: {
      path: () => '/mentorship',
      data: {
        titleMessage: messages.user.mentorship,
      }
    },
  },

  group: {
    pathPrefix: '/group',
    home: {
      path: (groupId = ':group_id') => `/group/${groupId}/`
    },
    news: {
      index: {
        path: (groupId = ':group_id') => `/group/${groupId}/news`
      },
      messages: {
        index: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/group/${groupId}/news/message/${itemId}`
        },
        new: {
          path: (groupId = ':group_id') => `/group/${groupId}/news/message/new`
        },
        edit: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/group/${groupId}/news/message/${itemId}/edit`
        },
      }
    },
    members: {
      index: {
        path: (groupId = ':group_id') => `/group/${groupId}/members`
      },
      new: {
        path: (groupId = ':group_id') => `/group/${groupId}/members/new`
      }
    }
  },

  // Admin
  admin: {
    get root() { return this.analyze.overview; },
    pathPrefix: '/admin',
    analyze: {
      index: {
        data: {
          pathPrefix: '/admin/analyze',
          titleMessage: messages.admin.analyze.index
        },
      },
      overview: {
        path: () => '/admin/analyze',
        data: {
          titleMessage: messages.admin.analyze.overview,
        }
      },
      users: {
        path: () => '/admin/analyze/users',
        data: {
          titleMessage: messages.admin.analyze.users,
        }
      },
    },
    manage: {
      index: {
        data: {
          pathPrefix: '/admin/manage',
          titleMessage: messages.admin.manage.index
        }
      },
      groups: {
        pathPrefix: '/admin/manage/groups',
        index: {
          path: () => '/admin/manage/groups',
          data: {
            permission: 'groups_index',
            titleMessage: messages.admin.manage.groups,
          }
        },
        new: {
          path: () => '/admin/manage/groups/new',
        },
        edit: {
          path: (groupId = ':group_id') => `/admin/manage/groups/${groupId}/edit`,
        },
      }
    },
    system: {
      index: {
        data: {
          pathPrefix: '/system',
          titleMessage: messages.admin.system.index,
        }
      },
      users: {
        index: {
          path: () => '/admin/system/users',
        },
        new: {
          path: () => '/admin/system/users/new',
        },
        edit: {
          path: (userId = ':user_id') => `/admin/system/users/${userId}/edit`,
        },
      },
      globalSettings: {
        fields: {
          index: {
            path: () => '/admin/system/settings/fields'
          }
        }
      }
    }
  },
};
