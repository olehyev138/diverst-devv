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
  approve: {
    id: `${scope}.index.button.approve`,
  },
  comments: {
    id: `${scope}.index.button.comments`,
  },
  edit: {
    id: `${scope}.index.button.edit`,
  },
  delete: {
    id: `${scope}.index.button.delete`,
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
  approved: {
    id: `${scope}.tab.approved`,
  },
  pending: {
    id: `${scope}.tab.pending`,
  },
  add: {
    id: `${scope}.index.button.add`,
  },
  social_link: {
    id: `${scope}.index.button.add.social_link`,
  },
  news_link: {
    id: `${scope}.index.button.add.news_link`,
  },
  group_message: {
    id: `${scope}.index.button.add.group_message`,
  },
  link_url: {
    id: `${scope}.form.news.input.link_url`,
  },
  title: {
    id: `${scope}.form.news.input.title`,
  },
  description: {
    id: `${scope}.form.news.input.description`,
  },
  social_url: {
    id: `${scope}.form.social.input.social_url`,
  },
});
