/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.AnnualBudget';

export default defineMessages({
  links: {
    editAnnualBudget: {
      id: `${scope}.tabs.editAnnualBudget`,
    },
    overview: {
      id: `${scope}.tabs.overview`,
    },
  },
  item: {
    pastTitle: {
      id: `${scope}.item.title`,
    },
    currentTitle: {
      id: `${scope}.item.currentTitle`,
    },
    budget: {
      id: `${scope}.item.budget`,
    },
    viewRequests: {
      id: `${scope}.item.viewRequests`,
    },
    createRequests: {
      id: `${scope}.item.createRequests`,
    },
    expenses: {
      id: `${scope}.item.expenses`,
    },
    annualBudget: {
      id: `${scope}.item.annualBudget`,
    },
    approvedBudget: {
      id: `${scope}.item.approvedBudget`,
    },
    availableBudget: {
      id: `${scope}.item.availableBudget`,
    },
    estimatedExpenses: {
      id: `${scope}.item.estimatedExpenses`,
    },
    eventUnspent: {
      id: `${scope}.item.eventUnspent`,
    },
  },
  events: {
    columns: {
      name: {
        id: `${scope}.events.columns.name`,
      },
      funding: {
        id: `${scope}.events.columns.funding`,
      },
      spent: {
        id: `${scope}.events.columns.spent`,
      },
      unspent: {
        id: `${scope}.events.columns.unspent`,
      },
      status: {
        id: `${scope}.events.columns.status`,
      },
    },
    title: {
      id: `${scope}.events.title`,
    },
  },
  form: {
    amount: {
      id: `${scope}.form.amount`,
    },
    leftover: {
      id: `${scope}.form.leftover`,
    },
    approved: {
      id: `${scope}.form.approved`,
    },
    setAnnualBudget: {
      id: `${scope}.form.button.setAnnualBudget`,
    },
    cancel: {
      id: `${scope}.form.button.cancel`,
    },
  },
  adminList: {
    columns: {
      group: {
        id: `${scope}.adminList.columns.group`,
      },
      budget: {
        id: `${scope}.adminList.columns.budget`,
      },
      leftover: {
        id: `${scope}.adminList.columns.leftover`,
      },
      approved: {
        id: `${scope}.adminList.columns.approved`,
      },
    },
    actions: {
      edit: {
        id: `${scope}.adminList.actions.edit`,
      },
      carryover: {
        id: `${scope}.adminList.actions.carryover`,
      },
      reset: {
        id: `${scope}.adminList.actions.reset`,
      },
      carryoverConfirm: {
        id: `${scope}.adminList.actions.carryoverConfirm`,
      },
      resetConfirm: {
        id: `${scope}.adminList.actions.resetConfirm`,
      },
    },
    title: {
      id: `${scope}.adminList.title`,
    },
    notSet: {
      id: `${scope}.adminList.notSet`,
    },
  },
});
