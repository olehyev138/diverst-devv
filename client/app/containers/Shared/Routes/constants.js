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
    show: {
      path: (userId = ':user_id') => `/user/${userId}`,
      data: {
        titleMessage: messages.user.profile,
      }
    },
    edit: {
      path: (userId = ':user_id') => `/user/${userId}/edit`,
      data: {
        titleMessage: messages.user.edit,
      }
    },
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
      data: {
        titleMessage: messages.user.mentorship,
      },
      home: {
        path: () => '/mentorship',
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      show: {
        path: (userId = ':user_id') => `/mentorship/${userId}`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      edit: {
        path: (userId = ':user_id') => `/mentorship/${userId}/edit`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      mentors: {
        path: (userId = ':user_id') => `/mentorship/${userId}/mentors`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      mentees: {
        path: (userId = ':user_id') => `/mentorship/${userId}/mentees`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      proposals: {
        path: (userId = ':user_id') => `/mentorship/${userId}/proposals`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
      requests: {
        path: (userId = ':user_id') => `/mentorship/${userId}/requests`,
        data: {
          titleMessage: messages.user.mentorship,
        },
      },
    }
    ,
  },

  group: {
    pathPrefix: '/groups',
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
        path: (groupId = ':group_id') => `/groups/${groupId}/members/new`,
        data: {
          titleMessage: messages.groups.members.new,
        },
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
        data: {
          titleMessage: messages.groups.events.show,
        }
      },
      new: {
        path: (groupId = ':group_id') => `/groups/${groupId}/events/new`,
        data: {
          titleMessage: messages.groups.events.new,
        }
      },
      edit: {
        path:
          (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/events/${eventId}/edit`,
        data: {
          titleMessage: messages.groups.events.edit,
        }
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
        show: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/messages/${itemId}`,
          data: {
            titleMessage: messages.groups.news.messages.show,
          }
        },
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/news/messages/new`,
          data: {
            titleMessage: messages.groups.news.messages.new
          }
        },
        edit: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/messages/${itemId}/edit`,
          data: {
            titleMessage: messages.groups.news.messages.edit
          }
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
        path: (groupId = ':group_id') => `/groups/${groupId}/outcomes/new`,
        data: {
          titleMessage: messages.groups.outcomes.new,
        }
      },
      edit: {
        path:
          (groupId = ':group_id', outcomeId = ':outcome_id') => `/groups/${groupId}/outcomes/${outcomeId}/edit`,
        data: {
          titleMessage: messages.groups.outcomes.edit
        }
      },
    },
    manage: {
      index: {
        data: {
          pathPrefix: (groupId = ':group_id') => `/groups/${groupId}/manage`,
          titleMessage: messages.groups.manage.index
        },
      },
      settings: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/settings`,
          data: {
            titleMessage: messages.groups.manage.settings.index
          }
        }
      },
      leaders: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/leaders`,
          data: {
            titleMessage: messages.groups.manage.leaders.index
          }
        }
      }
    },
    resources: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/folders`,
        data: {
          titleMessage: messages.groups.resources.index,
        }
      },
      new: {
        path: (groupId = ':group_id', folderId = ':folder_id') => `/groups/${groupId}/folders/${folderId}/resources/new`,
        data: {
          titleMessage: messages.groups.resources.new,
        }
      },
      edit: {
        path: (groupId = ':group_id', folderId = ':folder_id', itemId = ':item_id') => `/groups/${groupId}/folders/${folderId}/resources/${itemId}/edit`,
        data: {
          titleMessage: messages.groups.resources.edit,
        }
      },
      folders: {
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/folders/new`,
          data: {
            titleMessage: messages.groups.resources.folders.new,
          }
        },
        show: {
          path: (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/folders/${itemId}`,
          data: {
            titleMessage: messages.groups.resources.folders.show,
          }
        },
        edit: {
          path: (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/folders/${itemId}/edit`,
          data: {
            titleMessage: messages.groups.resources.folders.edit,
          }
        },
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
      resources: {
        index: {
          path: () => '/admin/manage/folders',
          data: {
            titleMessage: messages.admin.manage.resources,
          }
        },
        new: {
          path: (folderId = ':folder_id') => `/admin/manage/folders/${folderId}/resources/new`,
          data: {
            titleMessage: messages.groups.resources.new
          }
        },
        edit: {
          path: (folderId = ':folder_id', itemId = ':item_id') => `/admin/manage/folders/${folderId}/resources/${itemId}/edit`,
          data: {
            titleMessage: messages.groups.resources.edit
          }
        },
        folders: {
          new: {
            path: () => '/admin/manage/folders/new',
            data: {
              titleMessage: messages.groups.resources.folders.new
            }
          },
          show: {
            path: (itemId = ':item_id') => `/admin/manage/folders/${itemId}`,
            data: {
              titleMessage: messages.groups.resources.folders.show
            }
          },
          edit: {
            path: (itemId = ':item_id') => `/admin/manage/folders/${itemId}/edit`,
            data: {
              titleMessage: messages.groups.resources.folders.edit
            }
          },
        },
      }
    },
    innovate: {
      index: {
        data: {
          pathPrefix: '/admin/innovate',
        }
      },
      campaigns: {
        index: {
          path: () => '/admin/innovate/campaigns'
        },
        new: {
          path: () => '/admin/innovate/campaigns/new'
        },
        edit: {
          path: (campaignId = ':campaign_id') => `/admin/innovate/campaigns/${campaignId}/edit`,
        },
        show: {
          path: (campaignId = ':campaign_id') => `/admin/innovate/campaigns/${campaignId}`,
        },
        questions: {
          new: {
            path: (campaignId = ':campaign_id') => `/admin/innovate/campaigns/${campaignId}/questions/new`,
          },
          edit: {
            path: (campaignId = ':campaign_id', questionId = ':question_id') => `/admin/innovate/campaigns/${campaignId}/questions/${questionId}/edit`,
          }
        }
      },
      financials: {
        index: {
          path: () => '/admin/innovate/financials'
        }
      },
    },
    system: {
      index: {
        data: {
          pathPrefix: '/admin/system',
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
        roles: {
          index: {
            path: () => '/admin/system/users/roles',
          },
          new: {
            path: () => '/admin/system/users/roles/new',
          },
          edit: {
            path: (roleId = ':role_id') => `/admin/system/users/roles/${roleId}/edit`,
          },
        }
      },
      globalSettings: {
        pathPrefix: '/admin/system/settings',
        fields: {
          index: {
            path: () => '/admin/system/settings/fields'
          }
        },
        customText: {
          edit: {
            path: () => '/admin/system/settings/custom_texts'
          }
        },
        enterpriseConfiguration: {
          index: {
            path: () => '/admin/system/settings/configuration'
          }
        },
      },
      branding: {
        index: {
          path: () => '/admin/system/branding/theme',
          data: {
            pathPrefix: '/system/branding',
            titleMessage: messages.admin.system.branding,
          }
        },
        theme: {
          path: () => '/admin/system/branding/theme'
        },
        home: {
          path: () => '/admin/system/branding/home'
        },
        sponsors: {
          index: {
            path: () => '/admin/system/branding/sponsors'
          },
          new: {
            path: () => '/admin/system/branding/sponsors/new'
          },
          edit: {
            path: (sponsorId = ':sponsor_id') => `/admin/system/branding/sponsors/${sponsorId}/edit`,
          },
        }
      }
    }
  },
};
