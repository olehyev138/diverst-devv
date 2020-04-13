/*
 * Group Manage Messages
 *
 * This contains all the text for the group manage containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Group.Manage';

export default defineMessages({
  create: {
    id: `${scope}.form.button.create`,
  },
  update: {
    id: `${scope}.form.button.update`,
  },
  cancel: {
    id: `${scope}.form.button.cancel`,
  },
  leader: {
    select: {
      id: `${scope}.leader.form.select`,
    },
    role: {
      id: `${scope}.leader.form.role`,
    },
    position: {
      id: `${scope}.leader.form.position`,
    },
    new: {
      id: `${scope}.leader.list.new`,
    },
    edit: {
      id: `${scope}.leader.list.edit`,
    },
    delete: {
      id: `${scope}.leader.list.edit`,
    },
    title: {
      id: `${scope}.leader.list.title`,
    },
    column_name: {
      id: `${scope}.leader.list.column`,
    },
    column_position: {
      id: `${scope}.leader.list.position`,
    },
  },
  links: {
    settings: {
      id: `${scope}.links.settings`,
    },
    leaders: {
      id: `${scope}.links.leaders`,
    },
  },
  settings: {
    pending_users: {
      id: `${scope}.settings.pending_users`,
    },
    members_visibility: {
      id: `${scope}.settings.members_visibility`,
    },
    event_attendance_visibility: {
      id: `${scope}.settings.event_attendance_visibility`,
    },
    messages_visibility: {
      id: `${scope}.settings.messages_visibility`,
    },
    latest_news_visibility: {
      id: `${scope}.settings.latest_news_visibility`,
    },
    upcoming_events_visibility: {
      id: `${scope}.settings.upcoming_events_visibility`,
    },
    banner: {
      id: `${scope}.settings.banner`,
    },
    logo: {
      id: `${scope}.settings.logo`,
    },
    calendar_color: {
      id: `${scope}.settings.calendar_color`,
    },
    save: {
      id: `${scope}.settings.form.button.save`,
    },

  },
});
