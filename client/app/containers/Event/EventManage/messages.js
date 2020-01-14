/*
 * Event Messages
 *
 * This contains all the text for the Events containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Event.EventManage';

export default defineMessages({
  links: {
    metrics: {
      id: `${scope}.tabs.links`,
    },
    fields: {
      id: `${scope}.tabs.fields`,
    },
    updates: {
      id: `${scope}.tabs.updates`,
    },
    resources: {
      id: `${scope}.tabs.resources`,
    },
    expenses: {
      id: `${scope}.tabs.expenses`,
    },
  }
});
