/*
 * Branding Messages
 *
 * This contains all the text for the Branding containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Permissions';

export default defineMessages({
  layouts: {
    mentorship: {
      id: 'diverst.containers.Permissions.layouts.mentorshipLayout'
    },
    eventManage: {
      id: 'diverst.containers.Permissions.layouts.eventManageLayout'
    },
    group: {
      id: 'diverst.containers.Permissions.layouts.groupLayout'
    }
  },
  globalSettings: {
    email: {
      email: {
        indexPage: {
          id: 'diverst.containers.Permissions.globalSettings.email.email.emailsPage'
        },
        editPage: {
          id: 'diverst.containers.Permissions.globalSettings.email.email.emailEditPage'
        }
      },
      event: {
        editPage: {
          id: 'diverst.containers.Permissions.globalSettings.email.event.eventEditPage'
        },
        indexPage: {
          id: 'diverst.containers.Permissions.globalSettings.email.event.eventsPage'
        }
      }
    },
    field: {
      indexPage: {
        id: 'diverst.containers.Permissions.globalSettings.field.fieldsPage'
      }
    },
    SSOSettingsPage: {
      id: 'diverst.containers.Permissions.globalSettings.SSOSettingsPage'
    },
    customText: {
      editPage: {
        id: 'diverst.containers.Permissions.globalSettings.customText.customTextEditPage'
      }
    },
    enterpriseConfiguration: {
      showPage: {
        id: 'diverst.containers.Permissions.globalSettings.enterpriseConfiguration.enterpriseConfigurationPage'
      }
    }
  },
  group: {
    categorizePage: {
      id: 'diverst.containers.Permissions.group.groupCategorizePage'
    },
    outcome: {
      editPage: {
        id: 'diverst.containers.Permissions.group.outcome.outcomeEditPage'
      },
      indexPage: {
        id: 'diverst.containers.Permissions.group.outcome.outcomesPage'
      },
      createPage: {
        id: 'diverst.containers.Permissions.group.outcome.outcomeCreatePage'
      }
    },
    editPage: {
      id: 'diverst.containers.Permissions.group.groupEditPage'
    },
    groupManage: {
      groupLeaders: {
        editPage: {
          id: 'diverst.containers.Permissions.group.groupManage.groupLeaders.groupLeaderEditPage'
        },
        listPage: {
          id: 'diverst.containers.Permissions.group.groupManage.groupLeaders.groupLeadersListPage'
        },
        createPage: {
          id: 'diverst.containers.Permissions.group.groupManage.groupLeaders.groupLeaderCreatePage'
        }
      },
      groupSettingsPage: {
        id: 'diverst.containers.Permissions.group.groupManage.groupSettingsPage'
      }
    },
    createPage: {
      id: 'diverst.containers.Permissions.group.groupCreatePage'
    },
    groupCategories: {
      createPage: {
        id: 'diverst.containers.Permissions.group.groupCategories.groupCategoriesCreatePage'
      },
      indexPage: {
        id: 'diverst.containers.Permissions.group.groupCategories.groupCategoriesPage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.group.groupCategories.groupCategoriesEditPage'
      }
    },
    groupPlan: {
      annualBudget: {
        editPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.annualBudget.annualBudgetEditPage'
        },
        overviewPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.annualBudget.annualBudgetOverviewPage'
        },
        adminPlanPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.annualBudget.adminPlanAnnualBudgetPage'
        }
      },
      budget: {
        showPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.budget.budgetPage'
        },
        indexPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.budget.budgetsPage'
        },
        createPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.budget.budgetCreatePage'
        }
      },
      kPI: {
        updatePage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.updatePage'
        },
        updatesPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.updatesPage'
        },
        updateEditPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.updateEditPage'
        },
        kpiPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.kpiPage'
        },
        updateCreatePage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.updateCreatePage'
        },
        fieldsPage: {
          id: 'diverst.containers.Permissions.group.groupPlan.KPI.fieldsPage'
        }
      }
    },
    userListPage: {
      id: 'diverst.containers.Permissions.group.userGroupListPage'
    },
    groupMembers: {
      createPage: {
        id: 'diverst.containers.Permissions.group.groupMembers.groupMemberCreatePage'
      },
      listPage: {
        id: 'diverst.containers.Permissions.group.groupMembers.groupMemberListPage'
      }
    },
    adminListPage: {
      id: 'diverst.containers.Permissions.group.adminGroupListPage'
    }
  },
  analyze: {
    dashboards: {
      userPage: {
        id: 'diverst.containers.Permissions.analyze.dashboards.userDashboardPage'
      },
      metricsDashboard: {
        createPage: {
          id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.metricsDashboardCreatePage'
        },
        showPage: {
          id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.metricsDashboardPage'
        },
        customGraph: {
          createPage: {
            id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.customGraph.customGraphCreatePage'
          },
          editPage: {
            id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.customGraph.customGraphEditPage'
          }
        },
        listPage: {
          id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.metricsDashboardListPage'
        },
        editPage: {
          id: 'diverst.containers.Permissions.analyze.dashboards.metricsDashboard.metricsDashboardEditPage'
        }
      },
      groupPage: {
        id: 'diverst.containers.Permissions.analyze.dashboards.groupDashboardPage'
      }
    }
  },
  user: {
    userRole: {
      listPage: {
        id: 'diverst.containers.Permissions.user.userRole.userRoleListPage'
      },
      createPage: {
        id: 'diverst.containers.Permissions.user.userRole.userRoleCreatePage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.user.userRole.userRoleEditPage'
      }
    },
    importPage: {
      id: 'diverst.containers.Permissions.user.usersImportPage'
    },
    indexPage: {
      id: 'diverst.containers.Permissions.user.usersPage'
    },
    createPage: {
      id: 'diverst.containers.Permissions.user.userCreatePage'
    },
    eventsPage: {
      id: 'diverst.containers.Permissions.user.userEventsPage'
    },
    userPolicy: {
      policyTemplatesPage: {
        id: 'diverst.containers.Permissions.user.userPolicy.policyTemplatesPage'
      },
      policyTemplateEditPage: {
        id: 'diverst.containers.Permissions.user.userPolicy.policyTemplateEditPage'
      }
    },
    editPage: {
      id: 'diverst.containers.Permissions.user.userEditPage'
    },
    newsFeedPage: {
      id: 'diverst.containers.Permissions.user.userNewsFeedPage'
    }
  },
  event: {
    showPage: {
      id: 'diverst.containers.Permissions.event.eventPage'
    },
    editPage: {
      id: 'diverst.containers.Permissions.event.eventEditPage'
    },
    createPage: {
      id: 'diverst.containers.Permissions.event.eventCreatePage'
    },
    indexPage: {
      id: 'diverst.containers.Permissions.event.eventsPage'
    }
  },
  branding: {
    themePage: {
      id: 'diverst.containers.Permissions.branding.brandingThemePage'
    },
    homePage: {
      id: 'diverst.containers.Permissions.branding.brandingHomePage'
    },
    sponsor: {
      editPage: {
        id: 'diverst.containers.Permissions.branding.sponsor.sponsorEditPage'
      },
      createPage: {
        id: 'diverst.containers.Permissions.branding.sponsor.sponsorCreatePage'
      },
      listPage: {
        id: 'diverst.containers.Permissions.branding.sponsor.sponsorListPage'
      }
    }
  },
  segment: {
    listPage: {
      id: 'diverst.containers.Permissions.segment.segmentListPage'
    },
    showPage: {
      id: 'diverst.containers.Permissions.segment.segmentPage'
    }
  },
  innovate: {
    campaign: {
      editPage: {
        id: 'diverst.containers.Permissions.innovate.campaign.campaignEditPage'
      },
      listPage: {
        id: 'diverst.containers.Permissions.innovate.campaign.campaignListPage'
      },
      campaignQuestion: {
        showPage: {
          id: 'diverst.containers.Permissions.innovate.campaign.campaignQuestion.campaignQuestionShowPage'
        },
        createPage: {
          id: 'diverst.containers.Permissions.innovate.campaign.campaignQuestion.campaignQuestionCreatePage'
        },
        editPage: {
          id: 'diverst.containers.Permissions.innovate.campaign.campaignQuestion.campaignQuestionEditPage'
        }
      },
      showPage: {
        id: 'diverst.containers.Permissions.innovate.campaign.campaignShowPage'
      },
      createPage: {
        id: 'diverst.containers.Permissions.innovate.campaign.campaignCreatePage'
      }
    }
  },
  archive: {
    indexPage: {
      id: 'diverst.containers.Permissions.archive.archivesPage'
    }
  },
  resource: {
    groupResource: {
      resourceCreatePage: {
        id: 'diverst.containers.Permissions.resource.groupResource.resourceCreatePage'
      },
      resourceEditPage: {
        id: 'diverst.containers.Permissions.resource.groupResource.resourceEditPage'
      }
    },
    enterpriseFolder: {
      folderCreatePage: {
        id: 'diverst.containers.Permissions.resource.enterpriseFolder.folderCreatePage'
      },
      folderPage: {
        id: 'diverst.containers.Permissions.resource.enterpriseFolder.folderPage'
      },
      foldersPage: {
        id: 'diverst.containers.Permissions.resource.enterpriseFolder.foldersPage'
      },
      folderEditPage: {
        id: 'diverst.containers.Permissions.resource.enterpriseFolder.folderEditPage'
      }
    },
    groupFolder: {
      folderCreatePage: {
        id: 'diverst.containers.Permissions.resource.groupFolder.folderCreatePage'
      },
      folderPage: {
        id: 'diverst.containers.Permissions.resource.groupFolder.folderPage'
      },
      foldersPage: {
        id: 'diverst.containers.Permissions.resource.groupFolder.foldersPage'
      },
      folderEditPage: {
        id: 'diverst.containers.Permissions.resource.groupFolder.folderEditPage'
      }
    },
    enterpriseResource: {
      resourceCreatePage: {
        id: 'diverst.containers.Permissions.resource.enterpriseResource.resourceCreatePage'
      },
      resourceEditPage: {
        id: 'diverst.containers.Permissions.resource.enterpriseResource.resourceEditPage'
      }
    }
  },
  mentorship: {
    requests: {
      indexPage: {
        id: 'diverst.containers.Permissions.mentorship.requests.requestsPage'
      }
    },
    mentoring: {
      mentorsPage: {
        id: 'diverst.containers.Permissions.mentorship.mentoring.mentorsPage'
      }
    },
    editProfilePage: {
      id: 'diverst.containers.Permissions.mentorship.mentorshipEditProfilePage'
    },
    session: {
      indexPage: {
        id: 'diverst.containers.Permissions.mentorship.session.sessionsPage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.mentorship.session.sessionEditPage'
      },
      showPage: {
        id: 'diverst.containers.Permissions.mentorship.session.sessionPage'
      }
    }
  },
  news: {
    NewsFeedPage: {
      id: 'diverst.containers.Permissions.news.newsFeedPage'
    },
    socialLink: {
      createPage: {
        id: 'diverst.containers.Permissions.news.socialLink.socialLinkCreatePage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.news.socialLink.socialLinkEditPage'
      }
    },
    newsLink: {
      createPage: {
        id: 'diverst.containers.Permissions.news.newsLink.newsLinkCreatePage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.news.newsLink.newsLinkEditPage'
      },
      showPage: {
        id: 'diverst.containers.Permissions.news.newsLink.newsLinkPage'
      }
    },
    groupMessage: {
      createPage: {
        id: 'diverst.containers.Permissions.news.groupMessage.groupMessageCreatePage'
      },
      editPage: {
        id: 'diverst.containers.Permissions.news.groupMessage.groupMessageEditPage'
      },
      showPage: {
        id: 'diverst.containers.Permissions.news.groupMessage.groupMessagePage'
      }
    }
  }
});
