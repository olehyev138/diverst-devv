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
    total_comments: {
      id: `${scope}.comment.total_comments`,
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
  archive: {
    id: `${scope}.index.button.archive`,
  },
  export: {
    id: `${scope}.index.button.export`,
  },
  delete_confirm: {
    id: `${scope}.index.button.delete_confirm`,
  },
  join: {
    id: `${scope}.index.button.join`,
  },
  leave: {
    id: `${scope}.index.button.leave`,
  },
  view: {
    id: `${scope}.index.button.view`,
  },
  calendar: {
    id: `${scope}.index.button.calendar`,
  },
  createupdate: {
    id: `${scope}.form.button.createupdate`,
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
    location: {
      id: `${scope}.form.input.location`,
    },
    start: {
      id: `${scope}.form.input.start`,
    },
    end: {
      id: `${scope}.form.input.end`,
    },
    starterror: {
      id: `${scope}.form.input.starterror`,
    },
    enderror: {
      id: `${scope}.form.input.enderror`,
    },
    attendee: {
      id: `${scope}.form.input.attendee`
    },
    participating_groups: {
      id: `${scope}.form.input.participating_groups`
    },
    picture: {
      id: `${scope}.form.input.picture`
    },
    image: {
      id: `${scope}.form.input.image`
    },
    goal: {
      id: `${scope}.form.input.goal`
    },
    budgetName: {
      id: `${scope}.form.input.budgetName`
    },
    budgetAmount: {
      id: `${scope}.form.input.budgetAmount`
    },
    freeEvent: {
      id: `${scope}.form.input.freeEvent`
    },
  },
  show: {
    dateAndTime: {
      id: `${scope}.show.date_and_time`,
    },
    until: {
      id: `${scope}.show.until`
    },
  },
});
