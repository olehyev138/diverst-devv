/*
 * Campaign Questions Messages
 *
 * This contains all the text for the Campaign Questions containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Innovate';
export const snackbar = 'diverst.snackbars.Analyze.Question';

export default defineMessages({
  new: {
    id: `${scope}.form.button.new`,
  },
  deleteQuestionConfirm: {
    id: `${scope}.delete_question_confirm`,
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
  question: {
    placeholder: {
      id: `${scope}.question.placeholder`,
    },
    mark_close: {
      id: `${scope}.question.text.mark_close`,
    },
    mark_close_description: {
      id: `${scope}.question.text.mark_close_description`,
    },
    close: {
      id: `${scope}.question.button.close`,
    },
    closed: {
      id: `${scope}.question.button.closed`,
    },
    back: {
      id: `${scope}.question.button.back`,
    },
    create: {
      id: `${scope}.question.button.create`,
    },
    cancel: {
      id: `${scope}.question.button.cancel`,
    },
    edit: {
      id: `${scope}.question.tooltip.edit`,
    },
    delete: {
      id: `${scope}.question.tooltip.delete`,
    },
    title: {
      id: `${scope}.question.form.title`,
    },
    title_placeholder: {
      id: `${scope}.question.form.title_placeholder`,
    },
    description: {
      id: `${scope}.question.form.description`,
    },
    description_placeholder: {
      id: `${scope}.question.form.description_placeholder`,
    },
    list: {
      questions: {
        id: `${scope}.question.list.questions`,
      },
      title: {
        id: `${scope}.question.list.title`,
      },
      description: {
        id: `${scope}.question.list.description`,
      },
    }
  },
  snackbars: {
    errors: {
      question: {
        id: `${snackbar}.errors.load.question`
      },
      questions: {
        id: `${snackbar}.errors.load.questions`
      },
      create: {
        id: `${snackbar}.errors.create.question`
      },
      update: {
        id: `${snackbar}.errors.update.question`
      },
      delete: {
        id: `${snackbar}.errors.delete.question`
      },
    },
    success: {
      create: {
        id: `${snackbar}.success.create.question`
      },
      update: {
        id: `${snackbar}.success.update.question`
      },
      delete: {
        id: `${snackbar}.success.delete.question`
      },
    }
  }
});
