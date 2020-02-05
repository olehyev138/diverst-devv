/*
 * Archive Messages
 *
 * This contains all the text for the Archive container.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.Archive';

export default defineMessages({
  posts: {
    id: `${scope}.index.tabs.posts`,
  },
  resources: {
    id: `${scope}.index.tabs.resources`,
  },
  events: {
    id: `${scope}.index.tabs.events`,
  },
  title: {
    id: `${scope}.column.title`,
  },
  url: {
    id: `${scope}.column.url`,
  },
  creation: {
    id: `${scope}.column.creation`
  },
  options: {
    id: `${scope}.column.options`
  },
  empty_message: {
    id: `${scope}.index.empty_section`
  }
});
