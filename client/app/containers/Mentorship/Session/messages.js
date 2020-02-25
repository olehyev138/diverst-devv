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
    start_message: {
      id: `${scope}.form.input.start_message`,
    },
    end_message: {
      id: `${scope}.form.input.end_message`,
    },
    link: {
      id: `${scope}.form.input.link`,
    },
    create: {
      id: `${scope}.form.button.create`,
    },
    update: {
      id: `${scope}.form.button.update`,
    },
  },
  show: {
    dateAndTime: {
      id: `${scope}.show.date_and_time`,
    },
    leadedBy: {
      id: `${scope}.show.leadedBy`,
    },
    from: {
      id: `${scope}.show.from`,
    },
    to: {
      id: `${scope}.show.to`,
    },
    accept: {
      id: `${scope}.show.accept`,
    },
    reject: {
      id: `${scope}.show.reject`,
    },
    accepted: {
      id: `${scope}.show.accepted`,
    },
    rejected: {
      id: `${scope}.show.rejected`,
    },
    pending: {
      id: `${scope}.show.pending`,
    },
    leading: {
      id: `${scope}.show.leading`,
    },
    medium: {
      id: `${scope}.show.medium`,
    },
    link: {
      id: `${scope}.show.link`,
    },
    topics: {
      id: `${scope}.show.topics`,
    },
    role: {
      id: `${scope}.show.role`,
    },
    status: {
      id: `${scope}.show.status`,
    },
    users: {
      id: `${scope}.show.users`,
    },
    viewProfile: {
      id: `${scope}.show.viewProfile`,
    },
    title: {
      id: `${scope}.show.title`,
    },
    confirm: {
      accept: {
        id: `${scope}.show.confirm.accept`,
      },
      decline: {
        id: `${scope}.show.confirm.decline`,
      },
      delete: {
        id: `${scope}.show.confirm.delete`,
      }
    }
  }
});
