/*
 * Event Messages
 *
 * This contains all the text for the Event container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Event';

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
  archive: {
    id: `${scope}.index.button.archive`,
  },
  delete_confirm: {
    id: `${scope}.index.button.delete_confirm`,
  },
  join: {
    id: `${scope}.index.button.join`,
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
    picture: {
      id: `${scope}.form.input.picture`
    },
    image: {
      id: `${scope}.form.input.image`
    },
  },
  show: {
    dateAndTime: {
      id: `${scope}.show.date_and_time`,
    },
  },
});
