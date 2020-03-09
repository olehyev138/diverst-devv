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
      id: `${scope}.accepting.mentorRequests`,
    },
    mentees: {
      id: `${scope}.accepting.menteeRequests`,
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
    },
    your_time_zone: {
      id: `${scope}.long.your_time_zone`
    },
    their_time_zone: {
      id: `${scope}.long.their_time_zone`
    }
  },
  form: {
    mentor: {
      id: `${scope}.form.mentor`
    },
    mentee: {
      id: `${scope}.form.mentee`
    },
    acceptMentorRequest: {
      id: `${scope}.form.acceptMentorRequests`
    },
    acceptMenteeRequest: {
      id: `${scope}.form.acceptMenteeRequests`
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
    proposals: {
      id: `${scope}.menu.proposals`
    },
    requests: {
      id: `${scope}.menu.requests`
    },
    schedule: {
      id: `${scope}.menu.schedule`
    },
    participating: {
      id: `${scope}.menu.participating`
    },
    hosting: {
      id: `${scope}.menu.hosting`
    },
    feedback: {
      id: `${scope}.menu.feedback`
    },
  }
});
