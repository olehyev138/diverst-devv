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
      path: (groupId = ':group_id') => `/groups/${groupId}`,
      data: {
        titleMessage: messages.groups.home,
      }
    },
    members: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/members`,
        data: {
          titleMessage: messages.groups.members.index,
        }
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/members/new`
      }
    },
    events: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/events`,
        data: {
          titleMessage: messages.groups.events.index,
        }
      },
      show: {
        path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/events/${eventId}`,
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
        path: (groupId = ':group_id') => `/groups/${groupId}/news`,
        data: {
          titleMessage: messages.groups.news.index,
        }
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
    outcomes: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/outcomes`,
        data: {
          titleMessage: messages.groups.outcomes.index,
        }
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/outcomes/new`
      },
      edit: {
        path:
          (groupId = ':group_id', outcomeId = ':outcome_id') => `/groups/${groupId}/outcomes/${outcomeId}/edit`
      },
    },
    manage: {
      settings: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/settings`,
          data: {
            titleMessage: 'todo'
          }
        }
      },
      leaders: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/leaders`,
          data: {
            titleMessage: 'todo'
          }
        }
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
      groups: {
        path: () => '/admin/analyze/groups',
        data: {
          titleMessage: messages.admin.analyze.groups,
        }
      },
      custom: {
        index: {
          path: () => '/admin/analyze/custom',
          data: {
            titleMessage: messages.admin.analyze.custom,
          },
        },
        new: {
          path: () => '/admin/analyze/custom/new',
        },
        edit: {
          path: (metricsDashboardId = ':metrics_dashboard_id') => `/admin/analyze/custom/${metricsDashboardId}/edit`,
        },
        show: {
          path: (metricsDashboardId = ':metrics_dashboard_id') => `/admin/analyze/custom/${metricsDashboardId}`,
        },
        graphs: {
          new: {
            path: (metricsDashboardId = ':metrics_dashboard_id') => `/admin/analyze/custom/${metricsDashboardId}/graphs/new`,
          },
          edit: {
            path: (metricsDashboardId = ':metrics_dashboard_id', graphId = ':graph_id') => (
              `/admin/analyze/custom/${metricsDashboardId}/graphs/${graphId}/edit`)
          },
        },
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
        },
        customText: {
          edit: {
            path: () => '/admin/system/settings/custom_text'
          }
        }
      }
    }
  },
};
