/*
 * User Messages
 *
 * This contains all the text for the Users containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Mentorship';

export default defineMessages({
  mentor: {
    male: {
      id: `${scope}.mentor_m`
    },
    female: {
      id: `${scope}.mentor_f`
    },
    neutral: {
      id: `${scope}.mentor`
    },
    isA: {
      male: {
        id: `${scope}.isA.mentor_m`,
      },
      female: {
        id: `${scope}.isA.mentor_f`,
      },
      neutral: {
        id: `${scope}.isA.mentor`,
      },
    },
  },
  accepting: {
    mentors: {
      id: `${scope}.accepting.mentors`,
    },
    mentees: {
      id: `${scope}.accepting.mentees`,
    },
  },
  mentee: {
    male: {
      id: `${scope}.mentee_m`
    },
    female: {
      id: `${scope}.mentee_f`
    },
    neutral: {
      id: `${scope}.mentee`
    },
    isA: {
      male: {
        id: `${scope}.isA.mentee_m`,
      },
      female: {
        id: `${scope}.isA.mentee_f`,
      },
      neutral: {
        id: `${scope}.isA.mentee`,
      },
    },
  },
  short: {
    interests: {
      id: `${scope}.short.interests`
    },
    availability: {
      id: `${scope}.short.availability`
    },
    goals: {
      id: `${scope}.short.goals`
    },
    types: {
      id: `${scope}.short.types`
    }
  },
  long: {
    interests: {
      id: `${scope}.long.interests`
    },
    availability: {
      id: `${scope}.long.availability`
    },
    goals: {
      id: `${scope}.long.goals`
    },
    types: {
      id: `${scope}.long.types`
    }
  },
});
