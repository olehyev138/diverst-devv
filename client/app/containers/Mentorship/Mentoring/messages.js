/*
 * Mentorship Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.MentorshipList';

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
  }
});