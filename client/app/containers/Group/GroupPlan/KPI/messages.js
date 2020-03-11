/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group.GroupPlan.KPI';

export default defineMessages({
  links: {
    metrics: {
      id: `${scope}.tabs.metrics`,
    },
    fields: {
      id: `${scope}.tabs.fields`,
    },
    updates: {
      id: `${scope}.tabs.updates`,
    },
    event: {
      id: `${scope}.tabs.event`,
    },
    KPI: {
      id: `${scope}.tabs.KPI`,
    },
    budgeting: {
      id: `${scope}.tabs.budgeting`,
    },
  },
  createupdate: {
    id: `${scope}.form.button.createupdate`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },

});