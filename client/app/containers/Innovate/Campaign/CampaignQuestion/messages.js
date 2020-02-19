/*
 * Campaign Questions Messages
 *
 * This contains all the text for the Campaign Questions containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Innovate';

export default defineMessages({
  new: {
    id: `${scope}.form.button.new`,
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
    close: {
      id: `${scope}.question.button.close`,
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
  }
});
