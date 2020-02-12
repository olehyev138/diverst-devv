/*
 * News  Messages
 *
 * This contains all the text for the News containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.News';

export default defineMessages({
  new: {
    id: `${scope}.index.button.group_message.new`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
  },
  archive: {
    id: `${scope}.index.button.archive`,
  },
  approve: {
    id: `${scope}.index.button.approve`,
  },
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
  comment_submit: {
    id: `${scope}.form.group_message.comment.submit`
  },
});
