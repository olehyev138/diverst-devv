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
        show: {
          id: `${scope}.group.plan.outcomes.show`
        },
      },
      events: {
        manage: {
          id: `${scope}.group.plan.events.manage`
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
      }
    }
  },

});
