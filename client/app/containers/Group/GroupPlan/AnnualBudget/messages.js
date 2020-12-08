/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';


export const scope = 'diverst.containers.AnnualBudget';
export const snackbar = 'diverst.snackbars.Group.AnnualBudget';

export default defineMessages({
  links: {
    editAnnualBudget: {
      id: `${scope}.tabs.editAnnualBudget`,
    },
    overview: {
      id: `${scope}.tabs.overview`,
    },
    aggregate: {
      id: `${scope}.tabs.aggregate`,
    },
  },
  item: {
    pastTitle: {
      id: `${scope}.item.pastTitle`,
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
  initializationForm: {
    amount: {
      id: `${scope}.initialization.form.amount`,
    },
    type: {
      id: `${scope}.initialization.form.type`,
    },
    types: {
      id: `${scope}.initialization.form.types`,
    },
    year: {
      id: `${scope}.initialization.form.year`,
    },
    withQuarter: {
      id: `${scope}.initialization.form.withQuarter`,
    },
    quarter: {
      id: `${scope}.initialization.form.quarter`,
    },
    parentType: {
      id: `${scope}.initialization.form.parentType`,
    },
    regionType: {
      id: `${scope}.initialization.form.regionType`,
    },
    allType: {
      id: `${scope}.initialization.form.allType`,
    },
    parentTypeExplanation: {
      id: `${scope}.initialization.form.parentTypeExplanation`,
    },
    regionTypeExplanation: {
      id: `${scope}.initialization.form.regionTypeExplanation`,
    },
    allTypeExplanation: {
      id: `${scope}.initialization.form.allTypeExplanation`,
    },
    currentYear: {
      id: `${scope}.initialization.form.currentYear`,
    },
    currentQuarter: {
      id: `${scope}.initialization.form.currentQuarter`,
    },
    initialize: {
      id: `${scope}.initialization.form.initialize`,
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
    initializeYear: {
      id: `${scope}.adminList.initializeYear`,
    },
    initializeQuarter: {
      id: `${scope}.adminList.initializeQuarter`,
    },
  },
  snackbars: {
    errors: {
      currentAnnualBudget: {
        id: `${snackbar}.errors.load.currentBudget`
      },
      annualBudget: {
        id: `${snackbar}.errors.load.annualBudget`
      },
      annualBudgets: {
        id: `${snackbar}.errors.load.annualBudgets`
      },
      create: {
        id: `${snackbar}.errors.create.annualBudget`
      },
      update: {
        id: `${snackbar}.errors.update.annualBudget`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.annualBudget`
      },
      update: {
        id: `${snackbar}.success.update.annualBudget`
      },
    },
  }
});
