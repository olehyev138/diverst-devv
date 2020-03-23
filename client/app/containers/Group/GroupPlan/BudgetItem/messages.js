/*
 * Group Messages
 *
 * This contains all the text for the Groups containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.BudgetItem';

export default defineMessages({
  columns: {
    status: {
      id: `${scope}.index.columns.status`,
    },
    title: {
      id: `${scope}.index.columns.title`,
    },
    requested: {
      id: `${scope}.index.columns.requested`,
    },
    available: {
      id: `${scope}.index.columns.available`,
    },
    endDate: {
      id: `${scope}.index.columns.endDate`,
    },
    private: {
      id: `${scope}.index.columns.private`,
    },
  },
  lookup: {
    isDoneTrue: {
      id: `${scope}.index.lookup.isDoneTrue`,
    },
    isDoneFalse: {
      id: `${scope}.index.lookup.isDoneFalse`,
    },
    notSet: {
      id: `${scope}.index.lookup.notSet`,
    },
    privateTrue: {
      id: `${scope}.index.lookup.privateTrue`,
    },
    privateFalse: {
      id: `${scope}.index.lookup.privateFalse`,
    },
  },
  actions: {
    close: {
      id: `${scope}.index.actions.close`,
    },
    closeConfirm: {
      id: `${scope}.index.actions.closeConfirm`,
    }
  },
  declineForm: {
    title: {
      id: `${scope}.index.declineForm.title`,
    },
    question: {
      id: `${scope}.index.declineForm.question`,
    },
    cancel: {
      id: `${scope}.index.declineForm.cancel`,
    },
    submit: {
      id: `${scope}.index.declineForm.submit`,
    },
  },
  buttons: {
    back: {
      id: `${scope}.index.buttons.back`,
    },
    approve: {
      id: `${scope}.index.buttons.approve`,
    },
    decline: {
      id: `${scope}.index.buttons.decline`,
    },
  },
  declineReason: {
    id: `${scope}.index.declineReason`,
  },
  defaultReason: {
    id: `${scope}.index.defaultReason`,
  },
  title: {
    id: `${scope}.index.title`,
  },
  description: {
    id: `${scope}.index.description`,
  },
  tableTitle: {
    id: `${scope}.index.tableTitle`,
  },
  form: {
    descriptionTitle: {
      id: `${scope}.form.descriptionTitle`,
    },
    description: {
      id: `${scope}.form.description`,
    },
    approverTitle: {
      id: `${scope}.form.approverTitle`,
    },
    approver: {
      id: `${scope}.form.approver`,
    },
    listTitle: {
      id: `${scope}.form.listTitle`,
    },
    addEvent: {
      id: `${scope}.form.addEvent`,
    },
    cancel: {
      id: `${scope}.form.cancel`,
    },
    create: {
      id: `${scope}.form.create`,
    },
    event: {
      title: {
        id: `${scope}.form.event.title`,
      },
      amount: {
        id: `${scope}.form.event.amount`,
      },
      date: {
        id: `${scope}.form.event.date`,
      },
      private: {
        id: `${scope}.form.event.private`,
      },
    },
  },
});
