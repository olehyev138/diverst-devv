/*
 * Enterprise Configurations Messages
 *
 * This contains all the text for the Enterprise Configurations containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.GlobalSettings.Configurations';
export const snackbar = 'diverst.snackbars.GlobalSettings.EnterpriseConfiguration'
export default defineMessages({
  update: {
    id: `${scope}.button.update`,
  },
  save: {
    id: `${scope}.button.save`,
  },
  cancel: {
    id: `${scope}.button.cancel`,
  },
  name: {
    id: `${scope}.name`,
  },
  timezone: {
    id: `${scope}.timezone`,
  },
  from_email: {
    id: `${scope}.from_email`,
  },
  from_display_name: {
    id: `${scope}.from_display_name`,
  },
  redirect_email_contact: {
    id: `${scope}.redirect_email_contact`,
  },
  mentorship_module: {
    id: `${scope}.switch.mentorship_module`,
  },
  likes: {
    id: `${scope}.switch.likes`,
  },
  pending_comments: {
    id: `${scope}.switch.pending_comments`,
  },
  collaborate_module: {
    id: `${scope}.switch.collaborate_module`,
  },
  scope_module: {
    id: `${scope}.switch.scope_module`,
  },
  onboarding_emails: {
    id: `${scope}.switch.onboarding_emails`,
  },
  all_emails: {
    id: `${scope}.switch.all_emails`,
  },
  rewards: {
    id: `${scope}.switch.rewards`,
  },
  social_media: {
    id: `${scope}.switch.social_media`,
  },
  plan_module: {
    id: `${scope}.switch.plan_module`,
  },
  idp_url: {
    id: `${scope}.idp_url`,
  },
  sp_url: {
    id: `${scope}.sp_url`,
  },
  login_url: {
    id: `${scope}.login_url`,
  },
  logout_url: {
    id: `${scope}.logout_url`,
  },
  certificate: {
    id: `${scope}.certificate`,
  },
  auto_archive: {
    id: `${scope}.settings.auto_archive`,
  },
  expiry_units: {
    id: `${scope}.settings.expiry_units`,
  },
  expiry_resources: {
    id: `${scope}.settings.expiry_resources`,
  },
  units: {
    years: {
      id: `${scope}.settings.units.years`,
    },
    months: {
      id: `${scope}.settings.units.months`,
    },
    weeks: {
      id: `${scope}.settings.units.weeks`,
    },
  },
  snackbars: {
    errors: {
      load: {
        id: `${snackbar}.errors.load`,
      },
      update: {
        id: `${snackbar}.errors.update`,
      },
    },
    success: {
      update: {
        id: `${snackbar}.success.update`,
      },
    }
  }
});
