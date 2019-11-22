/*
 * Mentorship Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MentorshipSession';

export default defineMessages({
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
    delete: {
      id: `${scope}.index.tabs.delete`,
    },
    deleteConfirmation: {
      id: `${scope}.index.tabs.deleteConfirmation`,
    },
    edit: {
      id: `${scope}.index.tabs.edit`,
    },
  },
  title: {
    hosting: {
      id: `${scope}.title.hosting`,
    },
    participating: {
      id: `${scope}.title.participating`,
    },
  },
  form: {
    notes: {
      id: `${scope}.form.input.notes`,
    },
    topics: {
      id: `${scope}.form.input.topics`,
    },
    users: {
      id: `${scope}.form.input.users`,
    },
    start: {
      id: `${scope}.form.input.start`,
    },
    end: {
      id: `${scope}.form.input.end`,
    },
    create: {
      id: `${scope}.form.button.create`,
    },
    update: {
      id: `${scope}.form.button.update`,
    },
  },
});
