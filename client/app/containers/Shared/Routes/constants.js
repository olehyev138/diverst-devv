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
      path: (groupId = ':group_id') => `/groups/${groupId}`
    },
    events: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/events`
      },
      show: {
        path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/events/${eventId}`
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/events/new`
      },
      edit: {
        path:
          (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/events/${eventId}/edit`
      },
    },
    news: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/news`
      },
      messages: {
        index: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/messages/${itemId}`
        },
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/news/messages/new`
        },
        edit: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/messages/${itemId}/edit`
        },
      }
    },
    members: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/members`
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/members/new`
      }
    },
    outcomes: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/outcomes`
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/outcomes/new`
      },
      edit: {
        path:
          (groupId = ':group_id', outcomeId = ':outcome_id') => `/groups/${groupId}/outcomes/${outcomeId}/edit`
      },
    },
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
      },
      segments: {
        pathPrefix: '/admin/manage/segments',
        index: {
          path: () => '/admin/manage/segments',
          data: {
            permission: 'segments_index',
            titleMessage: messages.admin.manage.segments,
          }
        },
        new: {
          path: () => '/admin/manage/segments/new',
        },
        show: {
          path: (segmentId = ':segment_id') => `/admin/manage/segments/${segmentId}`,
        },
      },
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
          data: {
            pathPrefix: '/system/users',
            titleMessage: messages.admin.system.users,
          }
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
