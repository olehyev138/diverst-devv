/*
 * Custom Text Messages
 *
 * This contains all the text for the UserPolicy Text containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Policies';
export const snackbar = 'diverst.snackbars.User.Policy';

export default defineMessages({
  type: {
    enterprise: {
      id: `${scope}.type.enterprise`,
    },
    general: {
      id: `${scope}.type.general`,
    },
    group: {
      id: `${scope}.type.group`,
    },
  },
  form: {
    update: {
      id: `${scope}.form.update`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
    },
  },
  permissions: {
    view: {
      id: `${scope}.permissions.view`,
    },
    manage: {
      id: `${scope}.permissions.manage`,
    },
    create: {
      id: `${scope}.permissions.create`,
    },
    auto_archive: {
      id: `${scope}.permissions.auto_archive`,
    },
    enterprise: {
      id: `${scope}.permissions.enterprise`,
    },
    insights: {
      id: `${scope}.permissions.insights`,
    },
    layouts: {
      id: `${scope}.permissions.layouts`,
    },
    settings: {
      id: `${scope}.permissions.settings`,
    },
    request: {
      id: `${scope}.permissions.request`,
    },
    approval: {
      id: `${scope}.permissions.approval`,
    },
    social_link: {
      id: `${scope}.permissions.social_link`,
    },
    news_link: {
      id: `${scope}.permissions.news_link`,
    },
    message: {
      id: `${scope}.permissions.message`,
    },
  },
  enterprise_policies: {
    logs: {
      id: `${scope}.enterprise.logs`,
    },
    permissions: {
      id: `${scope}.enterprise.permissions`,
    },
    sso: {
      id: `${scope}.enterprise.sso`,
    },
    calendar: {
      id: `${scope}.enterprise.calendar`,
    },
    resources: {
      id: `${scope}.enterprise.resources`,
    },
    diversity: {
      id: `${scope}.enterprise.diversity`,
    },
    branding: {
      id: `${scope}.enterprise.branding`,
    },
    metrics: {
      id: `${scope}.enterprise.metrics`,
    },
    users: {
      id: `${scope}.enterprise.users`,
    },
    segments: {
      id: `${scope}.enterprise.segments`,
    },
    mentorship: {
      id: `${scope}.enterprise.mentorship`,
    },
    settings: {
      id: `${scope}.enterprise.settings`,
    },
  },
  general_policies: {
    campaigns: {
      id: `${scope}.general.campaigns`,
    },
    surveys: {
      id: `${scope}.general.surveys`,
    },
    groups: {
      id: `${scope}.general.groups`,
    },
  },
  group_policies: {
    events: {
      id: `${scope}.group.events`,
    },
    resource: {
      id: `${scope}.group.resource`,
    },
    news: {
      id: `${scope}.group.news`,
    },
    budgets: {
      id: `${scope}.group.budgets`,
    },
    members: {
      id: `${scope}.group.members`,
    },
    leaders: {
      id: `${scope}.group.leaders`,
    },
    settings: {
      id: `${scope}.group.settings`,
    },
  },
  snackbars: {
    errors: {
      policy: {
        id: `${snackbar}.errors.load.policy`
      },
      policies: {
        id: `${snackbar}.errors.load.policies`
      },
      create: {
        id: `${snackbar}.errors.create.policy`
      },
      delete: {
        id: `${snackbar}.errors.delete.policy`
      },
      update: {
        id: `${snackbar}.errors.update.policy`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.policy`
      },
      delete: {
        id: `${snackbar}.success.delete.policy`
      },
      update: {
        id: `${snackbar}.success.update.policy`
      },
    }
  }
});
