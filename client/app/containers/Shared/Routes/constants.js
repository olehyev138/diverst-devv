import messages from 'containers/Shared/Routes/messages';

// Routes structure
export const ROUTES = {
  // Session
  session: {
    login: {
      path: () => '/login',
    },
    forgotPassword: {
      path: () => '/forgot',
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
      sessions: {
        hosting: {
          path: (userId = ':user_id') => `/mentorship/${userId}/hostingSessions`,
          data: {
            titleMessage: messages.user.mentorship,
          },
        },
        participating: {
          path: (userId = ':user_id') => `/mentorship/${userId}/participatingSessions`,
          data: {
            titleMessage: messages.user.mentorship,
          },
        },
        schedule: {
          path: () => '/mentorship/sessions/schedule',
          data: {
            titleMessage: messages.user.mentorship,
          },
        },
        edit: {
          path: (sessionId = ':session_id') => `/mentorship/sessions/${sessionId}/edit`,
          data: {
            titleMessage: messages.user.mentorship,
          },
        },
        show: {
          path: (sessionId = ':session_id') => `/mentorship/sessions/${sessionId}`,
          data: {
            titleMessage: messages.user.mentorship,
          },
        },
      },
    },
  },

  group: {
    pathPrefix: '/groups',
    back: {
      data: {
        titleMessage: messages.groups.back,
      }
    },
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
      },
      news_links: {
        show: {
          path:
            (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/news_links/${itemId}`,
        },
        new: {
          path:
            (groupId = ':group_id') => `/groups/${groupId}/news/news_links/new`,
        },
        edit: {
          path: (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/news_links/${itemId}/edit`,
        },
      },
      social_links: {
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/news/social_links/new`,
        },
        edit: {
          path: (groupId = ':group_id', itemId = ':item_id') => `/groups/${groupId}/news/social_links/${itemId}/edit`,
        }
      }
    },
    plan: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/plan`,
        data: {
          pathPrefix: (groupId = ':group_id') => `/groups/${groupId}/plan`,
          titleMessage: messages.groups.plan.index
        },
      },
      outcomes: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/outcomes`,
          data: {
            titleMessage: messages.groups.plan.outcomes.index,
          }
        },
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/outcomes/new`,
          data: {
            titleMessage: messages.groups.plan.outcomes.new,
          }
        },
        edit: {
          path:
            (groupId = ':group_id', outcomeId = ':outcome_id') => `/groups/${groupId}/plan/outcomes/${outcomeId}/edit`,
          data: {
            titleMessage: messages.groups.plan.outcomes.edit
          }
        },
      },
      events: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/events`,
          data: {
            titleMessage: messages.groups.plan.events.index,
          }
        },
        manage: {
          index: {
            data: {
              pathPrefix: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage`,
              titleMessage: messages.groups.plan.events.manage.index
            },
          },
          metrics: {
            path:
              (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/metrics`,
            data: {
              titleMessage: messages.groups.plan.events.manage.metrics,
            },
          },
          fields: {
            path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/fields`,
            data: {
              titleMessage: messages.groups.plan.events.manage.fields,
            }
          },
          updates: {
            index: {
              path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/updates`,
              data: {
                titleMessage: messages.groups.plan.events.manage.updates.index,
              }
            },
            show: {
              path:
                (groupId = ':group_id', eventId = ':event_id', updateId = ':update_id') => `/groups/${groupId}/plan/events/${eventId}/manage/updates/${updateId}`,
              data: {
                titleMessage: messages.groups.plan.events.manage.updates.show,
              }
            },
            edit: {
              path:
                (groupId = ':group_id', eventId = ':event_id', updateId = ':update_id') => `/groups/${groupId}/plan/events/${eventId}/manage/updates/${updateId}/edit`,
              data: {
                titleMessage: messages.groups.plan.events.manage.updates.edit,
              }
            },
            new: {
              path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/updates/new`,
              data: {
                titleMessage: messages.groups.plan.events.manage.updates.new,
              }
            },
          },
          expenses: {
            index: {
              path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/expenses`,
              data: {
                titleMessage: messages.groups.plan.events.manage.expenses.index,
              }
            },
            edit: {
              path:
                (groupId = ':group_id', eventId = ':event_id', expensesId = ':expenses_id') => `/groups/${groupId}/plan/events/${eventId}/manage/expenses/${expensesId}/edit`,
              data: {
                titleMessage: messages.groups.plan.events.manage.expenses.edit,
              }
            },
            new: {
              path: (groupId = ':group_id', eventId = ':event_id') => `/groups/${groupId}/plan/events/${eventId}/manage/expenses/new`,
              data: {
                titleMessage: messages.groups.plan.events.manage.expenses.new,
              }
            }
          },
        },
      },
      kpi: {
        index: {
          data: {
            pathPrefix: (groupId = ':group_id') => `/groups/${groupId}/plan/kpi`,
            titleMessage: messages.groups.plan.kpi.index
          },
        },
        metrics: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/kpi/metrics`,
          data: {
            titleMessage: messages.groups.plan.kpi.metrics,
          }
        },
        fields: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/kpi/fields`,
          data: {
            titleMessage: messages.groups.plan.kpi.fields,
          }
        },
        updates: {
          index: {
            path: (groupId = ':group_id') => `/groups/${groupId}/plan/kpi/updates`,
            data: {
              titleMessage: messages.groups.plan.kpi.updates.index,
            }
          },
          show: {
            path: (groupId = ':group_id', updateId = ':update_id') => `/groups/${groupId}/plan/kpi/updates/${updateId}`,
            data: {
              titleMessage: messages.groups.plan.kpi.updates.show,
            }
          },
          edit: {
            path: (groupId = ':group_id', updateId = ':update_id') => `/groups/${groupId}/plan/kpi/updates/${updateId}/edit`,
            data: {
              titleMessage: messages.groups.plan.kpi.updates.edit,
            }
          },
          new: {
            path: (groupId = ':group_id') => `/groups/${groupId}/plan/kpi/updates/new`,
            data: {
              titleMessage: messages.groups.plan.kpi.updates.new,
            }
          }
        },
      },
      budget: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/budgeting`,
          data: {
            pathPrefix: (groupId = ':group_id') => `/groups/${groupId}/plan/budgeting`,
            titleMessage: messages.groups.plan.budget.index
          },
        },
        editAnnualBudget: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/budgeting/edit_annual_budget`,
          data: {
            titleMessage: messages.groups.plan.budget.editAnnualBudget,
          }
        },
        overview: {
          path: (groupId = ':group_id') => `/groups/${groupId}/plan/budgeting/overview`,
          data: {
            titleMessage: messages.groups.plan.budget.overview,
          }
        },
        budgets: {
          index: {
            path: (groupId = ':group_id', annualBudgetId = ':annual_budget_id') => `/groups/${groupId}/plan/budgeting/${annualBudgetId}/budgets`,
            data: {
              titleMessage: messages.groups.plan.budget.budgets.index,
            }
          },
          new: {
            path: (groupId = ':group_id', annualBudgetId = ':annual_budget_id') => `/groups/${groupId}/plan/budgeting/${annualBudgetId}/budgets/new`,
            data: {
              titleMessage: messages.groups.plan.budget.budgets.new,
            }
          },
          show: {
            path: (groupId = ':group_id', annualBudgetId = ':annual_budget_id', budgetId = ':budget_id') => `/groups/${groupId}/plan/budgeting/${annualBudgetId}/budgets/${budgetId}`,
            data: {
              titleMessage: messages.groups.plan.budget.budgets.show,
            }
          },
        },
      },
    },
    manage: {
      index: {
        path: (groupId = ':group_id') => `/groups/${groupId}/manage`,
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
      sponsors: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/sponsors`,
          data: {
            titleMessage: messages.groups.manage.sponsors.index
          }
        },
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/sponsors/new`,
          data: {
            titleMessage: messages.groups.manage.sponsors.new
          }
        },
        edit: {
          path: (groupId = ':group_id', groupSponsorId = ':group_sponsor_id') => `/groups/${groupId}/manage/sponsors/${groupSponsorId}/edit`,
          data: {
            titleMessage: messages.groups.manage.sponsors.edit
          }
        }
      },
      leaders: {
        index: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/leaders`,
          data: {
            titleMessage: messages.groups.manage.leaders.index
          }
        },
        new: {
          path: (groupId = ':group_id') => `/groups/${groupId}/manage/leaders/new`,
          data: {
            titleMessage: messages.groups.manage.leaders.new
          }
        },
        edit: {
          path: (groupId = ':group_id', groupLeaderId = ':group_leader_id') => `/groups/${groupId}/manage/leaders/${groupLeaderId}/edit`,
          data: {
            titleMessage: messages.groups.manage.leaders.edit
          }
        },
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
        categorize: {
          path: (groupId = ':group_id') => `/admin/manage/groups/${groupId}/categorize`,
        },
        categories: {
          pathPrefix: '/admin/manage/groups/categories',
          index: {
            path: () => '/admin/manage/groups/categories',
          },
          new: {
            path: () => '/admin/manage/groups/categories/new',
          },
          edit: {
            path: (groupCategoryTypeId = ':group_category_type_id') => `/admin/manage/groups/categories/${groupCategoryTypeId}/edit`,
          },
        },
        category_types: {
          edit: {
            path: () => '/admin/manage/groups/category_types/edit',
          },
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
        edit: {
          path: (segmentId = ':segment_id') => `/admin/manage/segments/${segmentId}/edit`,
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
      },
      archived: {
        index: {
          path: () => '/admin/manage/archived',
          data: {
            titleMessage: messages.admin.manage.archived,
          }
        }
      },
    },
    plan: {
      index: {
        data: {
          pathPrefix: '/admin/plan',
          titleMessage: messages.admin.plan.index
        }
      },
      budgeting: {
        pathPrefix: '/admin/plan/budgeting',
        index: {
          path: () => '/admin/plan/budgeting',
          data: {
            titleMessage: messages.admin.manage.groups,
          }
        },
      },
    },
    include: {
      index: {
        data: {
          titleMessage: messages.admin.include.index
        }
      }
    },
    mentorship: {
      index: {
        data: {
          titleMessage: messages.admin.mentorship.index
        }
      }
    },
    innovate: {
      index: {
        data: {
          pathPrefix: '/admin/innovate',
          titleMessage: messages.admin.innovate.index
        }
      },
      campaigns: {
        index: {
          path: () => '/admin/innovate/campaigns',
          data: {
            titleMessage: messages.admin.innovate.campaigns
          }
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
          },
          show: {
            path: (campaignId = ':campaign_id', questionId = ':question_id') => `/admin/innovate/campaigns/${campaignId}/questions/${questionId}`,
          },
        }
      },
      financials: {
        index: {
          path: () => '/admin/innovate/financials',
          data: {
            titleMessage: messages.admin.innovate.financials
          }
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
        import: {
          path: () => '/admin/system/users/import',
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
        },
        policy_templates: {
          index: {
            path: () => '/admin/system/users/policy_templates'
          },
          edit: {
            path: (policyId = ':policy_id') => `/admin/system/users/policy_templates/${policyId}/edit`
          },
        }
      },
      globalSettings: {
        pathPrefix: '/admin/system/settings',
        index: {
          path: () => '/admin/system/settings',
          titleMessage: messages.admin.system.globalSettings,
        },
        fields: {
          index: {
            path: () => '/admin/system/settings/fields',
            titleMessage: messages.admin.system.globalSettings,
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
        ssoSettings: {
          edit: {
            path: () => '/admin/system/settings/sso'
          },
        },
        emails: {
          index: {
            path: () => '/admin/system/settings/emailLayouts'
          },
          edit: {
            path: (emailId = ':email_id') => `/admin/system/settings/emailLayouts/${emailId}/edit`
          },
        },
        mailEvents: {
          index: {
            path: () => '/admin/system/settings/emailEvents'
          },
          edit: {
            path: (eventId = ':event_id') => `/admin/system/settings/emailEvents/${eventId}/edit`
          },
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
            path: (sponsorId = ':sponsor_id') => `/admin/system/branding/sponsors/${sponsorId}/edit`
          }
        }
      },
      logs: {
        index: {
          data: {
            titleMessage: messages.admin.system.logs,
          }
        },
      },
      diversity: {
        index: {
          data: {
            titleMessage: messages.admin.system.diversity,
          }
        },
      },
    }
  },
};
