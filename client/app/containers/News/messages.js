/*
 * News  Messages
 *
 * This contains all the text for the News containers/components.
 */

import { defineMessages } from 'react-intl';

export const scope = 'diverst.containers.News';
export const snackbar = 'diverst.snackbars.News';

export default defineMessages({
  new: {
    id: `${scope}.index.button.group_message.new`,
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
  archive: {
    id: `${scope}.index.button.archive`,
  },
  approve: {
    id: `${scope}.index.button.approve`,
  },
  group_comment_delete_confirm: {
    id: `${scope}.index.button.group.comment.delete_confirm`,
  },
  group_delete_confirm: {
    id: `${scope}.index.button.group.delete_confirm`,
  },
  news_delete_confirm: {
    id: `${scope}.index.button.news.delete_confirm`,
  },
  social_delete_confirm: {
    id: `${scope}.index.button.social.delete_confirm`,
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
  comment: {
    id: `${scope}.form.group_message.label.comment`,
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
  no_news: {
    approved: {
      id: `${scope}.index.no_news.approved`,
    },
    pending: {
      id: `${scope}.index.no_news.pending`,
    },
  },
  emptySection: {
    id: `${scope}.home.emptySection`,
  },
  snackbars: {
    errors: {
      approve: {
        id: `${snackbar}.errors.approve`
      },
      archive: {
        id: `${snackbar}.errors.archive`
      },
      create_group_message: {
        id: `${snackbar}.errors.create.group_message`
      },
      create_group_message_comment: {
        id: `${snackbar}.errors.create.group_message_comment`
      },
      create_news_link: {
        id: `${snackbar}.errors.create.news_link`
      },
      create_news_link_comment: {
        id: `${snackbar}.errors.create.news_link_comment`
      },
      create_social_link: {
        id: `${snackbar}.errors.create.social_link`
      },
      delete_group_message: {
        id: `${snackbar}.errors.delete.group_message`
      },
      delete_group_message_comment: {
        id: `${snackbar}.errors.delete.group_message_comment`
      },
      delete_news_link: {
        id: `${snackbar}.errors.delete.news_link`
      },
      delete_news_link_comment: {
        id: `${snackbar}.errors.delete.news_link_comment`
      },
      delete_social_link: {
        id: `${snackbar}.errors.delete.social_link`
      },
      news_item: {
        id: `${snackbar}.errors.load.news_item`
      },
      news_items: {
        id: `${snackbar}.errors.load.news_items`
      },
      pin: {
        id: `${snackbar}.errors.pin`
      },
      un_pin: {
        id: `${snackbar}.errors.un_pin`
      },
      update_group_message: {
        id: `${snackbar}.errors.update.group_message`
      },
      update_news_item: {
        id: `${snackbar}.errors.update.news_item`
      },
      update_news_link: {
        id: `${snackbar}.errors.update.news_link`
      },
      update_social_link: {
        id: `${snackbar}.errors.update.social_link`
      },
    },
    success: {
      create_group_message: {
        id: `${snackbar}.success.create.group_message`
      },
      create_group_message_comment: {
        id: `${snackbar}.success.create.group_message_comment`
      },
      create_news_link: {
        id: `${snackbar}.success.create.news_link`
      },
      create_news_link_comment: {
        id: `${snackbar}.success.create.news_link_comment`
      },
      create_social_link: {
        id: `${snackbar}.success.create.social_link`
      },
      delete_group_message: {
        id: `${snackbar}.success.delete.group_message`
      },
      delete_group_message_comment: {
        id: `${snackbar}.success.delete.group_message_comment`
      },
      delete_news_link: {
        id: `${snackbar}.success.delete.news_link`
      },
      delete_news_link_comment: {
        id: `${snackbar}.success.delete.news_link_comment`
      },
      delete_social_link: {
        id: `${snackbar}.success.delete.social_link`
      },
      update_group_message: {
        id: `${snackbar}.success.update.group_message`
      },
      update_news_item: {
        id: `${snackbar}.success.update.news_item`
      },
      update_news_link: {
        id: `${snackbar}.success.update.news_link`
      },
      update_social_link: {
        id: `${snackbar}.success.update.social_link`
      },
    }
  }
});
