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
    profile: {
      id: `${scope}.user.profile`,
    },
    edit: {
      id: `${scope}.user.edit`,
    },
  },
  groups: {
    back: {
      id: `${scope}.group.back`
    },
    home: {
      id: `${scope}.group.home`
    },
    members: {
      index: {
        id: `${scope}.group.members.index`
      },
      new: {
        id: `${scope}.group.members.new`
      },
    },
    events: {
      index: {
        id: `${scope}.group.events.index`
      },
      show: {
        id: `${scope}.group.events.show`
      },
      new: {
        id: `${scope}.group.events.new`
      },
      edit: {
        id: `${scope}.group.events.edit`
      },
    },
    resources: {
      index: {
        id: `${scope}.group.resources.index`
      },
      new: {
        id: `${scope}.group.resources.new`
      },
      edit: {
        id: `${scope}.group.resources.edit`
      },
      folders: {
        new: {
          id: `${scope}.group.resources.folders.new`
        },
        edit: {
          id: `${scope}.group.resources.folders.edit`
        },
        show: {
          id: `${scope}.group.resources.folders.show`
        },
      },
    },
    news: {
      index: {
        id: `${scope}.group.news.index`
      },
      messages: {
        show: {
          id: `${scope}.group.news.messages.show`
        },
        new: {
          id: `${scope}.group.news.messages.new`
        },
        edit: {
          id: `${scope}.group.news.messages.edit`
        }
      },
    },
    plan: {
      index: {
        id: `${scope}.group.plan.index`
      },
      outcomes: {
        index: {
          id: `${scope}.group.plan.outcomes.index`
        },
        new: {
          id: `${scope}.group.plan.outcomes.new`
        },
        edit: {
          id: `${scope}.group.plan.outcomes.edit`
        },
      },
      events: {
        index: {
          id: `${scope}.group.plan.events.index`
        },
        manage: {
          index: {
            id: `${scope}.group.plan.events.manage.index`
          },
          metrics: {
            id: `${scope}.group.plan.events.manage.metrics`
          },
          fields: {
            id: `${scope}.group.plan.events.manage.fields`
          },
          updates: {
            index: {
              id: `${scope}.group.plan.events.manage.updates.index`
            },
            show: {
              id: `${scope}.group.plan.events.manage.updates.show`
            },
            edit: {
              id: `${scope}.group.plan.events.manage.updates.edit`
            },
            new: {
              id: `${scope}.group.plan.events.manage.updates.new`
            },
          },
        },
      },
      kpi: {
        index: {
          id: `${scope}.group.plan.kpi.index`
        },
        metrics: {
          id: `${scope}.group.plan.kpi.metrics`
        },
        fields: {
          id: `${scope}.group.plan.kpi.fields`
        },
        updates: {
          index: {
            id: `${scope}.group.plan.kpi.updates.index`
          },
          show: {
            id: `${scope}.group.plan.kpi.updates.show`
          },
          edit: {
            id: `${scope}.group.plan.kpi.updates.edit`
          },
          new: {
            id: `${scope}.group.plan.kpi.updates.new`
          },
        },
      },
    },
    manage: {
      index: {
        id: `${scope}.group.manage.index`
      },
      settings: {
        index: {
          id: `${scope}.group.manage.settings.index`,
        }
      },
      leaders: {
        index: {
          id: `${scope}.group.manage.leaders.index`,
        },
        new: {
          id: `${scope}.group.manage.leaders.new`,
        },
        edit: {
          id: `${scope}.group.manage.leaders.edit`,
        }
      },
    },
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
      },
      custom: {
        id: `${scope}.admin.analyze.custom`,
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
      resources: {
        id: `${scope}.admin.manage.resources.index`
      }
    },
    system: {
      index: {
        id: `${scope}.admin.system.index`,
      },
      users: {
        id: `${scope}.admin.system.users`,
      },
      branding: {
        id: `${scope}.admin.system.branding`,
      },
      globalSettings: {
        id: `${scope}.admin.system.globalSettings`,
      },
      logs: {
        id: `${scope}.admin.system.logs`,
      },
      diversity: {
        id: `${scope}.admin.system.diversity`,
      },
    },
    innovate: {
      index: {
        id: `${scope}.admin.innovate.index`,
      },
      campaigns: {
        id: `${scope}.admin.innovate.campaigns`,
      },
      financials: {
        id: `${scope}.admin.innovate.financials`,
      }
    },
    plan: {
      index: {
        id: `${scope}.admin.plan.index`,
      },
    },
    include: {
      index: {
        id: `${scope}.admin.include.index`,
      },
    },
    mentorship: {
      index: {
        id: `${scope}.admin.mentorship.index`,
      },
    },
  },

});
