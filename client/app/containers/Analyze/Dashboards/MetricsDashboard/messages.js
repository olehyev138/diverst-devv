/*
 * MetricsDashboard Messages
 *
 * This contains all the text for the MetricsDashboard container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MetricsDashboard';
export const snackbars = 'diverst.snackbars.Analyze.Dashboards'

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
        id: `${snackbars}.errors.load.dashboard`
      },
      dashboards: {
        id: `${snackbars}.errors.load.dashboards`
      },
      create_dashboard: {
        id: `${snackbars}.errors.create.dashboard`
      },
      update_dashboard: {
        id: `${snackbars}.errors.update.dashboard`
      },
      delete_dashboard: {
        id: `${snackbars}.errors.delete.dashboard`
      },
      graph: {
        id: `${snackbars}.errors.load.graph`
      },
      graph_data: {
        id: `${snackbars}.errors.load.graph_data`
      },
      create_graph: {
        id: `${snackbars}.errors.create.graph`
      },
      update_graph: {
        id: `${snackbars}.errors.update.graph`
      },
      delete_graph: {
        id: `${snackbars}.errors.delete.graph`
      }
    },
    success: {
      create_graph: {
        id: `${snackbars}.success.create.graph`
      },
      update_graph: {
        id: `${snackbars}.success.update.graph`
      },
      delete_graph: {
        id: `${snackbars}.success.delete.graph`
      },
      create_dashboard: {
        id: `${snackbars}.success.create.dashboard`
      },
      update_dashboard: {
        id: `${snackbars}.success.update.dashboard`
      },
      delete_dashboard: {
        id: `${snackbars}.success.delete.dashboard`
      },
    }
  }
});
