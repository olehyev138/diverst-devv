/*
 * MetricsDashboard Messages
 *
 * This contains all the text for the MetricsDashboard container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MetricsDashboard';
export const snackbar = 'diverst.snackbars.Analyze.Dashboards';

export default defineMessages({
  delete_confirm: {
    id: `${scope}.delete_confirm`,
  },
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
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  creategraph: {
    id: `${scope}.index.button.creategraph`,
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
    aggregations: {
      id: `${scope}.fields.aggregations`,
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
  snackbars: {
    errors: {
      dashboard: {
        id: `${snackbar}.errors.load.dashboard`
      },
      dashboards: {
        id: `${snackbar}.errors.load.dashboards`
      },
      create_dashboard: {
        id: `${snackbar}.errors.create.dashboard`
      },
      update_dashboard: {
        id: `${snackbar}.errors.update.dashboard`
      },
      delete_dashboard: {
        id: `${snackbar}.errors.delete.dashboard`
      },
      graph: {
        id: `${snackbar}.errors.load.graph`
      },
      graph_data: {
        id: `${snackbar}.errors.load.graph_data`
      },
      create_graph: {
        id: `${snackbar}.errors.create.graph`
      },
      update_graph: {
        id: `${snackbar}.errors.update.graph`
      },
      delete_graph: {
        id: `${snackbar}.errors.delete.graph`
      }
    },
    success: {
      create_graph: {
        id: `${snackbar}.success.create.graph`
      },
      update_graph: {
        id: `${snackbar}.success.update.graph`
      },
      delete_graph: {
        id: `${snackbar}.success.delete.graph`
      },
      create_dashboard: {
        id: `${snackbar}.success.create.dashboard`
      },
      update_dashboard: {
        id: `${snackbar}.success.update.dashboard`
      },
      delete_dashboard: {
        id: `${snackbar}.success.delete.dashboard`
      },
    }
  }
});
