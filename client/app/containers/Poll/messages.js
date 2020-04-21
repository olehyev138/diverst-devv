/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Poll';

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
  delete_message: {
    id: `${scope}.index.text.delete_message`,
  },
  delete_confirm: {
    id: `${scope}.index.text.delete_confirm`,
  },
  rows: {
    id: `${scope}.index.button.rows`,
  },
  page: {
    id: `${scope}.index.button.page`,
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
  form: {
    name: {
      id: `${scope}.form.input.name`,
    },
    active_filter: {
      id: `${scope}.form.label.active_filter`,
    },
    field_rule: {
      id: `${scope}.form.label.field_rule`,
    },
    order_rule: {
      id: `${scope}.form.label.order_rule`,
    },
    scope_rule: {
      id: `${scope}.form.label.scope_rule`,
    },
  },
  list: {
    name: {
      id: `${scope}.list.column.title`,
    },
    questions: {
      id: `${scope}.list.column.questions`,
    },
    responses: {
      id: `${scope}.list.column.responses`,
    },
    creationDate: {
      id: `${scope}.list.column.creationDate`,
    },
    status: {
      id: `${scope}.list.column.status`,
    },
    title: {
      id: `${scope}.list.title`,
    },
    edit: {
      id: `${scope}.list.tooltip.edit`,
    },
    delete: {
      id: `${scope}.list.tooltip.delete`,
    },
  },
  member: {
    firstname: {
      id: `${scope}.member.column.firstname`,
    },
    lastname: {
      id: `${scope}.member.column.lastname`,
    },
    title: {
      id: `${scope}.member.title`,
    },
    export: {
      id: `${scope}.member.export`,
    },
  },
  rule: {
    tab: {
      field: {
        id: `${scope}.rule.tab.field`,
      },
      order: {
        id: `${scope}.rule.tab.order`,
      },
      group: {
        id: `${scope}.rule.tab.group`,
      },
    },
    button: {
      field: {
        id: `${scope}.rule.button.field`,
      },
      order: {
        id: `${scope}.rule.button.order`,
      },
      group: {
        id: `${scope}.rule.button.group`,
      },
    },
    field: {
      id: `${scope}.rule.field`,
    },
    operator: {
      id: `${scope}.rule.operator`,
    },
    order: {
      field: {
        id: `${scope}.rule.order.field`,
      },
      operator: {
        id: `${scope}.rule.order.operator`,
      },
    },
    group: {
      field: {
        id: `${scope}.rule.group.field`,
      },
      operator: {
        id: `${scope}.rule.group.operator`,
      },
    }
  }
});
