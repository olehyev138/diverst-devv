/*
 * MetricsDashboard Messages
 *
 * This contains all the text for the MetricsDashboard container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MetricsDashboard';

export default defineMessages({
  new: {
    id: `${scope}.index.button.new`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  create: {
    id: `${scope}.form.button.create`,
  },
  creategraph: {
    id: `${scope}.index.button.creategraph`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  tabs: {
    overview: {
      id: `${scope}.tab.overview`,
    },
    social: {
      id: `${scope}.tab.social`,
    },
    resources: {
      id: `${scope}.tab.resources`,
    },
  },
  fields: {
    field: {
      id: `${scope}.fields.field`,
    },
    aggregation: {
      id: `${scope}.fields.aggregation`,
    },
    groups: {
      id: `${scope}.fields.groups`,
    },
    segments: {
      id: `${scope}.fields.segments`,
    },
    name: {
      id: `${scope}.fields.name`,
    }
  },
  table: {
    title: {
      id: `${scope}.table.title`,
    },
    edit: {
      id: `${scope}.table.tooltip.edit`,
    },
    delete: {
      id: `${scope}.table.tooltip.delete`,
    },
    delete_confirm: {
      id: `${scope}.table.tooltip.delete_confirm`,
    },
  },
  show: {
  },
});
