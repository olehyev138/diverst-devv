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
      id: `${scope}.layouts.mentorshipLayout`
    },
    eventManage: {
      id: `${scope}.layouts.eventManageLayout`
    },
    group: {
      id: `${scope}.layouts.groupLayout`
    }
  },
  globalSettings: {
    email: {
      email: {
        indexPage: {
          id: `${scope}.globalSettings.email.email.emailsPage`
        },
        editPage: {
          id: `${scope}.globalSettings.email.email.emailEditPage`
        }
      },
      event: {
        editPage: {
          id: `${scope}.globalSettings.email.event.eventEditPage`
        },
        indexPage: {
          id: `${scope}.globalSettings.email.event.eventsPage`
        }
      }
    },
    field: {
      indexPage: {
        id: `${scope}.globalSettings.field.fieldsPage`
      }
    },
    SSOSettingsPage: {
      id: `${scope}.globalSettings.SSOSettingsPage`
    },
    customText: {
      editPage: {
        id: `${scope}.globalSettings.customText.customTextEditPage`
      }
    },
    enterpriseConfiguration: {
      showPage: {
        id: `${scope}.globalSettings.enterpriseConfiguration.enterpriseConfigurationPage`
      }
    }
  },
  group: {
    categorizePage: {
      id: `${scope}.group.groupCategorizePage`
    },
    outcome: {
      editPage: {
        id: `${scope}.group.outcome.outcomeEditPage`
      },
      indexPage: {
        id: `${scope}.group.outcome.outcomesPage`
      },
      createPage: {
        id: `${scope}.group.outcome.outcomeCreatePage`
      }
    },
    editPage: {
      id: `${scope}.group.groupEditPage`
    },
    groupManage: {
      groupLeaders: {
        editPage: {
          id: `${scope}.group.groupManage.groupLeaders.groupLeaderEditPage`
        },
        listPage: {
          id: `${scope}.group.groupManage.groupLeaders.groupLeadersListPage`
        },
        createPage: {
          id: `${scope}.group.groupManage.groupLeaders.groupLeaderCreatePage`
        }
      },
      groupSettingsPage: {
        id: `${scope}.group.groupManage.groupSettingsPage`
      }
    },
    createPage: {
      id: `${scope}.group.groupCreatePage`
    },
    groupCategories: {
      createPage: {
        id: `${scope}.group.groupCategories.groupCategoriesCreatePage`
      },
      indexPage: {
        id: `${scope}.group.groupCategories.groupCategoriesPage`
      },
      editPage: {
        id: `${scope}.group.groupCategories.groupCategoriesEditPage`
      }
    },
    groupPlan: {
      annualBudget: {
        editPage: {
          id: `${scope}.group.groupPlan.annualBudget.annualBudgetEditPage`
        },
        overviewPage: {
          id: `${scope}.group.groupPlan.annualBudget.annualBudgetOverviewPage`
        },
        adminPlanPage: {
          id: `${scope}.group.groupPlan.annualBudget.adminPlanAnnualBudgetPage`
        }
      },
      budget: {
        showPage: {
          id: `${scope}.group.groupPlan.budget.budgetPage`
        },
        indexPage: {
          id: `${scope}.group.groupPlan.budget.budgetsPage`
        },
        createPage: {
          id: `${scope}.group.groupPlan.budget.budgetCreatePage`
        }
      },
      KPI: {
        updatePage: {
          id: `${scope}.group.groupPlan.KPI.updatePage`
        },
        updatesPage: {
          id: `${scope}.group.groupPlan.KPI.updatesPage`
        },
        updateEditPage: {
          id: `${scope}.group.groupPlan.KPI.updateEditPage`
        },
        kpiPage: {
          id: `${scope}.group.groupPlan.KPI.kpiPage`
        },
        updateCreatePage: {
          id: `${scope}.group.groupPlan.KPI.updateCreatePage`
        },
        fieldsPage: {
          id: `${scope}.group.groupPlan.KPI.fieldsPage`
        }
      },
      eventList: {
        id: `${scope}.group.groupPlan.eventsList`
      }
    },
    userListPage: {
      id: `${scope}.group.userGroupListPage`
    },
    groupMembers: {
      createPage: {
        id: `${scope}.group.groupMembers.groupMemberCreatePage`
      },
      listPage: {
        id: `${scope}.group.groupMembers.groupMemberListPage`
      }
    },
    adminListPage: {
      id: `${scope}.group.adminGroupListPage`
    }
  },
  analyze: {
    dashboards: {
      userPage: {
        id: `${scope}.analyze.dashboards.userDashboardPage`
      },
      metricsDashboard: {
        createPage: {
          id: `${scope}.analyze.dashboards.metricsDashboard.metricsDashboardCreatePage`
        },
        showPage: {
          id: `${scope}.analyze.dashboards.metricsDashboard.metricsDashboardPage`
        },
        customGraph: {
          createPage: {
            id: `${scope}.analyze.dashboards.metricsDashboard.customGraph.customGraphCreatePage`
          },
          editPage: {
            id: `${scope}.analyze.dashboards.metricsDashboard.customGraph.customGraphEditPage`
          }
        },
        listPage: {
          id: `${scope}.analyze.dashboards.metricsDashboard.metricsDashboardListPage`
        },
        editPage: {
          id: `${scope}.analyze.dashboards.metricsDashboard.metricsDashboardEditPage`
        }
      },
      groupPage: {
        id: `${scope}.analyze.dashboards.groupDashboardPage`
      }
    }
  },
  user: {
    userRole: {
      listPage: {
        id: `${scope}.user.userRole.userRoleListPage`
      },
      createPage: {
        id: `${scope}.user.userRole.userRoleCreatePage`
      },
      editPage: {
        id: `${scope}.user.userRole.userRoleEditPage`
      }
    },
    importPage: {
      id: `${scope}.user.usersImportPage`
    },
    indexPage: {
      id: `${scope}.user.usersPage`
    },
    createPage: {
      id: `${scope}.user.userCreatePage`
    },
    eventsPage: {
      id: `${scope}.user.userEventsPage`
    },
    userPolicy: {
      policyTemplatesPage: {
        id: `${scope}.user.userPolicy.policyTemplatesPage`
      },
      policyTemplateEditPage: {
        id: `${scope}.user.userPolicy.policyTemplateEditPage`
      }
    },
    editPage: {
      id: `${scope}.user.userEditPage`
    },
    newsFeedPage: {
      id: `${scope}.user.userNewsFeedPage`
    }
  },
  event: {
    showPage: {
      id: `${scope}.event.eventPage`
    },
    editPage: {
      id: `${scope}.event.eventEditPage`
    },
    createPage: {
      id: `${scope}.event.eventCreatePage`
    },
    indexPage: {
      id: `${scope}.event.eventsPage`
    }
  },
  branding: {
    themePage: {
      id: `${scope}.branding.brandingThemePage`
    },
    homePage: {
      id: `${scope}.branding.brandingHomePage`
    },
    sponsor: {
      editPage: {
        id: `${scope}.branding.sponsor.sponsorEditPage`
      },
      createPage: {
        id: `${scope}.branding.sponsor.sponsorCreatePage`
      },
      listPage: {
        id: `${scope}.branding.sponsor.sponsorListPage`
      }
    }
  },
  segment: {
    listPage: {
      id: `${scope}.segment.segmentListPage`
    },
    showPage: {
      id: `${scope}.segment.segmentPage`
    }
  },
  innovate: {
    campaign: {
      editPage: {
        id: `${scope}.innovate.campaign.campaignEditPage`
      },
      listPage: {
        id: `${scope}.innovate.campaign.campaignListPage`
      },
      campaignQuestion: {
        showPage: {
          id: `${scope}.innovate.campaign.campaignQuestion.campaignQuestionShowPage`
        },
        createPage: {
          id: `${scope}.innovate.campaign.campaignQuestion.campaignQuestionCreatePage`
        },
        editPage: {
          id: `${scope}.innovate.campaign.campaignQuestion.campaignQuestionEditPage`
        }
      },
      showPage: {
        id: `${scope}.innovate.campaign.campaignShowPage`
      },
      createPage: {
        id: `${scope}.innovate.campaign.campaignCreatePage`
      }
    }
  },
  archive: {
    indexPage: {
      id: `${scope}.archive.archivesPage`
    }
  },
  resource: {
    groupResource: {
      resourceCreatePage: {
        id: `${scope}.resource.groupResource.resourceCreatePage`
      },
      resourceEditPage: {
        id: `${scope}.resource.groupResource.resourceEditPage`
      }
    },
    enterpriseFolder: {
      folderCreatePage: {
        id: `${scope}.resource.enterpriseFolder.folderCreatePage`
      },
      folderPage: {
        id: `${scope}.resource.enterpriseFolder.folderPage`
      },
      foldersPage: {
        id: `${scope}.resource.enterpriseFolder.foldersPage`
      },
      folderEditPage: {
        id: `${scope}.resource.enterpriseFolder.folderEditPage`
      }
    },
    groupFolder: {
      folderCreatePage: {
        id: `${scope}.resource.groupFolder.folderCreatePage`
      },
      folderPage: {
        id: `${scope}.resource.groupFolder.folderPage`
      },
      foldersPage: {
        id: `${scope}.resource.groupFolder.foldersPage`
      },
      folderEditPage: {
        id: `${scope}.resource.groupFolder.folderEditPage`
      }
    },
    enterpriseResource: {
      resourceCreatePage: {
        id: `${scope}.resource.enterpriseResource.resourceCreatePage`
      },
      resourceEditPage: {
        id: `${scope}.resource.enterpriseResource.resourceEditPage`
      }
    }
  },
  mentorship: {
    requests: {
      indexPage: {
        id: `${scope}.mentorship.requests.requestsPage`
      }
    },
    mentoring: {
      mentorsPage: {
        id: `${scope}.mentorship.mentoring.mentorsPage`
      }
    },
    editProfilePage: {
      id: `${scope}.mentorship.mentorshipEditProfilePage`
    },
    session: {
      indexPage: {
        id: `${scope}.mentorship.session.sessionsPage`
      },
      editPage: {
        id: `${scope}.mentorship.session.sessionEditPage`
      },
      showPage: {
        id: `${scope}.mentorship.session.sessionPage`
      }
    }
  },
  news: {
    NewsFeedPage: {
      id: `${scope}.news.newsFeedPage`
    },
    socialLink: {
      createPage: {
        id: `${scope}.news.socialLink.socialLinkCreatePage`
      },
      editPage: {
        id: `${scope}.news.socialLink.socialLinkEditPage`
      }
    },
    newsLink: {
      createPage: {
        id: `${scope}.news.newsLink.newsLinkCreatePage`
      },
      editPage: {
        id: `${scope}.news.newsLink.newsLinkEditPage`
      },
      showPage: {
        id: `${scope}.news.newsLink.newsLinkPage`
      }
    },
    groupMessage: {
      createPage: {
        id: `${scope}.news.groupMessage.groupMessageCreatePage`
      },
      editPage: {
        id: `${scope}.news.groupMessage.groupMessageEditPage`
      },
      showPage: {
        id: `${scope}.news.groupMessage.groupMessagePage`
      }
    }
  }
});
