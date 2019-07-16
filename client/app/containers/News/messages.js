/*
 * News  Messages
 *
 * This contains all the text for the News containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.News';

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
  subject: {
    id: `${scope}.form.group_message.input.subject`,
  },
  content: {
    id: `${scope}.form.group_message.input.content`,
  },
});
