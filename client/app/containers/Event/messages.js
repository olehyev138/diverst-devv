/*
 * Event Messages
 *
 * This contains all the text for the Event container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Event';

export default defineMessages({
  comment: {
    submit: {
      id: `${scope}.comment.button.submit`,
    },
    delete: {
      id: `${scope}.comment.button.delete`,
    },
    deleteconfirm: {
      id: `${scope}.comment.button.deleteconfirm`,
    },
    input: {
      id: `${scope}.comment.form.input`,
    },
    label: {
      id: `${scope}.comment.form.label`,
    },
    total_commments: {
      id: `${scope}.comment.total_commments`,
    },
    said: {
      id: `${scope}.comment.said`,
    },
    ago: {
      id: `${scope}.comment.ago`,
    },
    you: {
      id: `${scope}.comment.you`,
    },
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
  index: {
    upcoming: {
      id: `${scope}.index.tabs.upcoming`,
    },
    ongoing: {
      id: `${scope}.index.tabs.ongoing`,
    },
    past: {
      id: `${scope}.index.tabs.past`,
    },
    emptySection: {
      id: `${scope}.index.tabs.empty_section`,
    },
    participating: {
      id: `${scope}.index.tabs.participating`
    },
    all: {
      id: `${scope}.index.tabs.all`
    },
  },
  inputs: {
    name: {
      id: `${scope}.form.input.name`,
    },
    description: {
      id: `${scope}.form.input.description`,
    },
    start: {
      id: `${scope}.form.input.start`,
    },
    end: {
      id: `${scope}.form.input.end`,
    },
    picture: {
      id: `${scope}.form.input.picture`
    }
  },
  show: {
    dateAndTime: {
      id: `${scope}.show.date_and_time`,
    },
  },
});
