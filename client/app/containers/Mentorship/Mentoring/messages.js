/*
 * Mentorship Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MentorshipList';
export const snackbar = 'diverst.snackbars.Mentorship.Mentoring';

export default defineMessages({
  columns: {
    interests: {
      id: `${scope}.column.interests`
    },
  },
  tabs: {
    current: {
      id: `${scope}.tab.current`
    },
    available: {
      id: `${scope}.tab.available`
    },
  },
  title: {
    current: {
      mentor: {
        id: `${scope}.title.current.mentor`
      },
      mentee: {
        id: `${scope}.title.current.mentee`
      },
    },
    available: {
      mentor: {
        id: `${scope}.title.available.mentor`
      },
      mentee: {
        id: `${scope}.title.available.mentee`
      },
    },
  },
  actions: {
    remove: {
      id: `${scope}.actions.remove`
    },
    sendRequest: {
      id: `${scope}.actions.sendRequest`
    },
    mentorWhy: {
      id: `${scope}.actions.mentorWhy`
    },
    menteeWhy: {
      id: `${scope}.actions.menteeWhy`
    },
    deleteWarning: {
      id: `${scope}.actions.deleteWarning`
    },
    viewProfile: {
      id: `${scope}.actions.viewProfile`
    }
  },
  snackbars: {
    errors: {
      available_mentors: {
        id: `${snackbar}.errors.load.available_mentors`
      },
      available_mentees: {
        id: `${snackbar}.errors.load.available_mentees`
      },
      mentors: {
        id: `${snackbar}.errors.load.mentors`
      },
      request: {
        id: `${snackbar}.errors.request`
      },
      delete: {
        id: `${snackbar}.errors.delete.mentor`
      },
    },
    success: {
      request: {
        id: `${snackbar}.success.request`
      },
      delete: {
        id: `${snackbar}.success.delete.mentor`
      },
    }
  }
});
