/*
 * Innovate
 *
 * This contains all the text for the Innovate containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Innovate';
export const snackbar = 'diverst.snackbars.Analyze.Campaign';

export default defineMessages({
  links: {
    campaigns: {
      id: `${scope}.links.campaigns`,
    },
    financial: {
      id: `${scope}.links.financial`,
    },
  },
  new: {
    id: `${scope}.form.button.new`,
  },
  edit: {
    id: `${scope}.form.button.edit`,
  },
  delete: {
    id: `${scope}.form.button.delete`,
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  Campaign: {
    title: {
      id: `${scope}.Campaign.form.title`,
    },
    description: {
      id: `${scope}.Campaign.form.description`,
    },
    starttime: {
      id: `${scope}.Campaign.form.starttime`,
    },
    endtime: {
      id: `${scope}.Campaign.form.endtime`,
    },
    groups: {
      id: `${scope}.Campaign.form.groups`,
    },
    starttimemessage: {
      id: `${scope}.Campaign.form.starttimemessage`,
    },
    endtimemessage: {
      id: `${scope}.Campaign.form.endtimemessage`,
    },
    campaigns: {
      id: `${scope}.Campaign.list.campaigns`,
    },
    edit: {
      id: `${scope}.Campaign.tooltip.edit`,
    },
    delete: {
      id: `${scope}.Campaign.tooltip.delete`,
    },
    delete_confirm: {
      id: `${scope}.Campaign.tooltip.delete_confirm`,
    },
  },
  snackbars: {
    errors: {
      campaign: {
        id: `${snackbar}.errors.load.campaign`
      },
      campaigns: {
        id: `${snackbar}.errors.load.campaigns`
      },
      create: {
        id: `${snackbar}.errors.create.campaign`
      },
      update: {
        id: `${snackbar}.errors.update.campaign`
      },
      delete: {
        id: `${snackbar}.errors.delete.campaign`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.campaign`
      },
      update: {
        id: `${snackbar}.success.update.campaign`
      },
      delete: {
        id: `${snackbar}.success.delete.campaign
`
      },
    }
  }
});
