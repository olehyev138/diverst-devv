/*
 * Mentorship Messages
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
  form: {
    mentor: {
      id: `${scope}.form.mentor`
    },
    mentee: {
      id: `${scope}.form.mentee`
    },
    acceptMentor: {
      id: `${scope}.form.acceptMentor`
    },
    acceptMentee: {
      id: `${scope}.form.acceptMentee`
    },
    mentorDescription: {
      id: `${scope}.form.mentorDescription`
    },
    interests: {
      id: `${scope}.form.interests`
    },
    types: {
      id: `${scope}.form.types`
    },
  },
  menu: {
    profile: {
      id: `${scope}.menu.profile`
    },
    editProfile: {
      id: `${scope}.menu.editProfile`
    },
    mentors: {
      id: `${scope}.menu.mentors`
    },
    mentees: {
      id: `${scope}.menu.mentees`
    },
    requests: {
      id: `${scope}.menu.requests`
    },
    schedule: {
      id: `${scope}.menu.schedule`
    },
    upcoming: {
      id: `${scope}.menu.upcoming`
    },
    feedback: {
      id: `${scope}.menu.feedback`
    },
  }
});
