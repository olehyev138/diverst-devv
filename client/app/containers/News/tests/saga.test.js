import {
  getNewsItems, getNewsItem, updateNewsItem, createGroupMessage, updateGroupMessage, deleteGroupMessage,
  deleteGroupMessageComment, createGroupMessageComment, createNewsLink, updateNewsLink, deleteNewsLink,
  createNewsLinkComment, deleteNewsLinkComment, createSocialLink, updateSocialLink, deleteSocialLink,
  archiveNewsItem, approveNewsItem, pinNewsItem, unpinNewsItem
} from 'containers/News/saga';
import {
  getNewsItemsSuccess,
  getNewsItemsError,
  getNewsItemBegin,
  getNewsItemSuccess,
  getNewsItemError,
  updateNewsItemBegin,
  updateNewsItemError,
  updateNewsItemSuccess,
  createGroupMessageSuccess,
  createGroupMessageError,
  createGroupMessageCommentError,
  updateGroupMessageSuccess,
  updateGroupMessageError,
  createGroupMessageCommentSuccess,
  createNewsLinkBegin,
  createNewsLinkSuccess,
  createNewsLinkError,
  createNewsLinkCommentError,
  updateNewsLinkSuccess,
  updateNewsLinkError,
  createNewsLinkCommentSuccess,
  createSocialLinkBegin,
  deleteGroupMessageBegin,
  deleteGroupMessageError,
  deleteGroupMessageSuccess,
  createSocialLinkSuccess,
  createSocialLinkError,
  createSocialLinkCommentError,
  updateSocialLinkSuccess,
  updateSocialLinkError,
  createSocialLinkCommentSuccess,
  deleteNewsLinkBegin,
  deleteNewsLinkError,
  deleteNewsLinkSuccess,
  deleteSocialLinkBegin,
  deleteSocialLinkError,
  deleteSocialLinkSuccess,
  deleteGroupMessageCommentBegin,
  deleteGroupMessageCommentError,
  deleteGroupMessageCommentSuccess,
  deleteNewsLinkCommentBegin,
  deleteNewsLinkCommentError,
  deleteNewsLinkCommentSuccess,
  archiveNewsItemBegin,
  archiveNewsItemSuccess,
  archiveNewsItemError,
  pinNewsItemBegin,
  pinNewsItemSuccess,
  pinNewsItemError,
  unpinNewsItemBegin,
  unpinNewsItemSuccess,
  unpinNewsItemError,
  approveNewsItemSuccess,
  approveNewsItemError
} from 'containers/News/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.newsFeedLinks.all = jest.fn();
api.newsFeedLinks.get = jest.fn();
api.newsFeedLinks.update = jest.fn();
api.groupMessages.create = jest.fn();
api.groupMessages.update = jest.fn();
api.groupMessages.destroy = jest.fn();
api.groupMessageComments.create = jest.fn();
api.groupMessageComments.destroy = jest.fn();
api.newsLinks.create = jest.fn();
api.newsLinks.update = jest.fn();
api.newsLinks.destroy = jest.fn();
api.newsLinkComments.create = jest.fn();
api.newsLinkComments.destroy = jest.fn();
api.socialLinks.create = jest.fn();
api.socialLinks.update = jest.fn();
api.socialLinks.destroy = jest.fn();
api.newsFeedLinks.archive = jest.fn();
api.newsFeedLinks.approve = jest.fn();
api.newsFeedLinks.pin = jest.fn();
api.newsFeedLinks.un_pin = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});
const newsItem = {
  id: 4,
  news_feed_id: 1,
  approved: true,
  created_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  updated_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  news_link_id: 2,
  group_message_id: null,
  social_link_id: null,
  is_pinned: false,
  archived_at: null,
  views_count: null,
  likes_count: 1
};
const groupMessage = {
  id: 2,
  group_id: 1,
  subject: 'test',
  content: 'testcontent',
  created_at: 'Tue, 14 Apr 2020 18:45:56 UTC +00:00',
  updated_at: 'Tue, 14 Apr 2020 18:45:56 UTC +00:00',
  owner_id: 1
};
const groupMessageComment = {
  news_link_id: 1,
  attributes: {
    id: 1,
    content: 'test',
    author_id: 1,
    message_id: 2,
    created_at: 'Tue, 14 Apr 2020 19:53:01 UTC +00:00',
    updated_at: 'Tue, 14 Apr 2020 19:53:01 UTC +00:00',
    approved: false
  }
};
const newsLink = {
  id: 2,
  title: 'fe',
  description: 'fe',
  url: 'http://f',
  group_id: 1,
  created_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  updated_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  picture_file_name: null,
  picture_content_type: null,
  picture_file_size: null,
  picture_updated_at: null,
  author_id: 1
};
const newsLinkComment = {
  news_link_id: 1,
  attributes: {
    id: 1,
    content: 'test',
    author_id: 1,
    message_id: 2,
    created_at: 'Tue, 14 Apr 2020 19:53:01 UTC +00:00',
    updated_at: 'Tue, 14 Apr 2020 19:53:01 UTC +00:00',
    approved: false
  }
};
const socialLink = {
  id: 2,
  author_id: 1,
  embed_code: 'fe',
  created_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  updated_at: 'Wed, 15 Apr 2020 13:34:00 UTC +00:00',
  group_id: 1,
  url: 'http://f',
  small_embed_code: 'fe',
};
describe('Get news items Saga', () => {
  it('Should return news Items list', async () => {
    api.newsFeedLinks.all.mockImplementation(() => Promise.resolve({ data: { page: { ...newsItem } } }));
    const results = [getNewsItemsSuccess(newsItem)];
    const initialAction = { payload: {
      count: 5,
    } };
    const dispatched = await recordSaga(
      getNewsItems,
      initialAction
    );

    expect(api.newsFeedLinks.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load news items',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getNewsItemsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getNewsItems,
      initialAction
    );

    expect(api.newsFeedLinks.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.news_items, options: { variant: 'warning' } });
  });
});

describe('Get news item Saga', () => {
  it('Should return a news item', async () => {
    api.newsFeedLinks.get.mockImplementation(() => Promise.resolve({ data: { ...newsItem } }));
    const results = [getNewsItemSuccess(newsItem)];
    const initialAction = { payload: { id: newsItem.id } };
    const dispatched = await recordSaga(
      getNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.get.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get news item',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getNewsItemError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      getNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.news_item, options: { variant: 'warning' } });
  });
});

describe('Update news item', () => {
  it('Should update a news item', async () => {
    api.newsFeedLinks.update.mockImplementation(() => Promise.resolve({ data: { newsItem } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'News feed link updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateNewsItemSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { newsItem } };
    const dispatched = await recordSaga(
      updateNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { news_feed_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update_news_item, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update news feed link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateNewsItemError(response), notified];
    const initialAction = { payload: { id: 5, news_link_id: 5 } };
    const dispatched = await recordSaga(
      updateNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { news_feed_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update_news_item, options: { variant: 'warning' } });
  });
});

describe('Create group message', () => {
  it('Should create a group message', async () => {
    api.groupMessages.create.mockImplementation(() => Promise.resolve({ data: { groupMessage } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group message created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createGroupMessageSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { groupMessage } };
    const dispatched = await recordSaga(
      createGroupMessage,
      initialAction
    );

    expect(api.groupMessages.create).toHaveBeenCalledWith({ group_message: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create_group_message, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groupMessages.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create group message',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createGroupMessageError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      createGroupMessage,
      initialAction
    );
    expect(api.groupMessages.create).toHaveBeenCalledWith({ group_message: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create_group_message, options: { variant: 'warning' } });
  });
});

describe('Update group message', () => {
  it('Should update a group message', async () => {
    api.groupMessages.update.mockImplementation(() => Promise.resolve({ data: { groupMessage } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Group Message updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateGroupMessageSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { groupMessage } };
    const dispatched = await recordSaga(
      updateGroupMessage,
      initialAction
    );

    expect(api.groupMessages.update).toHaveBeenCalledWith(initialAction.payload.id, { group_message: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update_group_message, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groupMessages.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group message',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateGroupMessageError(response), notified];
    const initialAction = { payload: { id: 5, group_id: 5 } };
    const dispatched = await recordSaga(
      updateGroupMessage,
      initialAction
    );

    expect(api.groupMessages.update).toHaveBeenCalledWith(initialAction.payload.id, { group_message: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update_group_message, options: { variant: 'warning' } });
  });
});

describe('Delete group message', () => {
  it('Should delete a group message', async () => {
    api.groupMessages.destroy.mockImplementation(() => Promise.resolve({ data: { groupMessage } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group message deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteGroupMessageSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { groupMessage } };
    const dispatched = await recordSaga(
      deleteGroupMessage,
      initialAction
    );

    expect(api.groupMessages.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete_group_message, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groupMessages.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group message',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteGroupMessageError(response), notified];
    const initialAction = { payload: { id: 10 } };
    const dispatched = await recordSaga(
      deleteGroupMessage,
      initialAction
    );

    expect(api.groupMessages.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete_group_message, options: { variant: 'warning' } });
  });
});

describe('Create group message comment', () => {
  it('Should create a group message comment', async () => {
    api.groupMessageComments.create.mockImplementation(() => Promise.resolve({ data: { groupMessageComment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group message comment created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createGroupMessageCommentSuccess(), getNewsItemBegin({}), notified];
    const initialAction = { payload: { groupMessageComment } };
    const dispatched = await recordSaga(
      createGroupMessageComment,
      initialAction
    );

    expect(api.groupMessageComments.create).toHaveBeenCalledWith({ group_message_comment: initialAction.payload.attributes });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create_group_message_comment, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groupMessageComments.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create group message comment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createGroupMessageCommentError(response), notified];
    const initialAction = { payload: { attributes: undefined } };
    const dispatched = await recordSaga(
      createGroupMessageComment,
      initialAction
    );

    expect(api.groupMessageComments.create).toHaveBeenCalledWith({ group_message_comment: initialAction.payload.attributes });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create_group_message_comment, options: { variant: 'warning' } });
  });
});

describe('Delete group message comment', () => {
  it('Should delete a group message comment', async () => {
    api.groupMessageComments.destroy.mockImplementation(() => Promise.resolve({ data: { groupMessageComment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'group message comment deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteGroupMessageCommentSuccess(), getNewsItemBegin({ id: undefined }), notified];
    const initialAction = { payload: { groupMessageComment } };
    const dispatched = await recordSaga(
      deleteGroupMessageComment,
      initialAction
    );

    expect(api.groupMessageComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete_group_message_comment, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groupMessageComments.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group message comment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteGroupMessageCommentError(response), notified];
    const initialAction = { payload: { id: 100 } };
    const dispatched = await recordSaga(
      deleteGroupMessageComment,
      initialAction
    );
    expect(api.groupMessageComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete_group_message_comment, options: { variant: 'warning' } });
  });
});

describe('Create news link', () => {
  it('Should create a news link', async () => {
    api.newsLinks.create.mockImplementation(() => Promise.resolve({ data: { newsLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'News link created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createNewsLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { newsLink } };
    const dispatched = await recordSaga(
      createNewsLink,
      initialAction
    );

    expect(api.newsLinks.create).toHaveBeenCalledWith({ news_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create_news_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsLinks.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create news link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createNewsLinkError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      createNewsLink,
      initialAction
    );
    expect(api.newsLinks.create).toHaveBeenCalledWith({ news_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create_news_link, options: { variant: 'warning' } });
  });
});

describe('Update news link', () => {
  it('Should update a news link', async () => {
    api.newsLinks.update.mockImplementation(() => Promise.resolve({ data: { newsLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'News link updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateNewsLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { newsLink } };
    const dispatched = await recordSaga(
      updateNewsLink,
      initialAction
    );

    expect(api.newsLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { news_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update_news_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsLinks.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update news link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateNewsLinkError(response), notified];
    const initialAction = { payload: { id: 5, group_id: 5 } };
    const dispatched = await recordSaga(
      updateNewsLink,
      initialAction
    );

    expect(api.newsLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { news_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update_news_link, options: { variant: 'warning' } });
  });
});

describe('Delete news link', () => {
  it('Should delete a news link', async () => {
    api.newsLinks.destroy.mockImplementation(() => Promise.resolve({ data: { newsLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'news link deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteNewsLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { newsLink } };
    const dispatched = await recordSaga(
      deleteNewsLink,
      initialAction
    );

    expect(api.newsLinks.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete_news_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsLinks.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete news link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteNewsLinkError(response), notified];
    const initialAction = { payload: { id: 10 } };
    const dispatched = await recordSaga(
      deleteNewsLink,
      initialAction
    );

    expect(api.newsLinks.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete_news_link, options: { variant: 'warning' } });
  });
});

describe('Create news link comment', () => {
  it('Should create a news link comment', async () => {
    api.newsLinkComments.create.mockImplementation(() => Promise.resolve({ data: { newsLinkComment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'news link comment created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createNewsLinkCommentSuccess(), getNewsItemBegin({}), notified];
    const initialAction = { payload: { newsLinkComment } };
    const dispatched = await recordSaga(
      createNewsLinkComment,
      initialAction
    );

    expect(api.newsLinkComments.create).toHaveBeenCalledWith({ news_link_comment: initialAction.payload.attributes });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create_news_link_comment, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsLinkComments.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create news link comment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createNewsLinkCommentError(response), notified];
    const initialAction = { payload: { attributes: undefined } };
    const dispatched = await recordSaga(
      createNewsLinkComment,
      initialAction
    );

    expect(api.newsLinkComments.create).toHaveBeenCalledWith({ news_link_comment: initialAction.payload.attributes });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create_news_link_comment, options: { variant: 'warning' } });
  });
});

describe('Delete news link comment', () => {
  it('Should delete a news link comment', async () => {
    api.newsLinkComments.destroy.mockImplementation(() => Promise.resolve({ data: { newsLinkComment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'news link comment deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteNewsLinkCommentSuccess(), getNewsItemBegin({ id: undefined }), notified];
    const initialAction = { payload: { newsLinkComment } };
    const dispatched = await recordSaga(
      deleteNewsLinkComment,
      initialAction
    );

    expect(api.newsLinkComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete_news_link_comment, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsLinkComments.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete news link comment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteNewsLinkCommentError(response), notified];
    const initialAction = { payload: { id: 100 } };
    const dispatched = await recordSaga(
      deleteNewsLinkComment,
      initialAction
    );
    expect(api.newsLinkComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete_news_link_comment, options: { variant: 'warning' } });
  });
});

describe('Create social link', () => {
  it('Should create a social link', async () => {
    api.socialLinks.create.mockImplementation(() => Promise.resolve({ data: { socialLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Social link created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createSocialLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { socialLink } };
    const dispatched = await recordSaga(
      createSocialLink,
      initialAction
    );

    expect(api.socialLinks.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.create_social_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.socialLinks.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create social link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createSocialLinkError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      createSocialLink,
      initialAction
    );
    expect(api.socialLinks.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.create_social_link, options: { variant: 'warning' } });
  });
});

describe('Update social link', () => {
  it('Should update a social link', async () => {
    api.socialLinks.update.mockImplementation(() => Promise.resolve({ data: { socialLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Social link updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateSocialLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { socialLink } };
    const dispatched = await recordSaga(
      updateSocialLink,
      initialAction
    );

    expect(api.socialLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { social_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.update_social_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.socialLinks.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update social link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateSocialLinkError(response), notified];
    const initialAction = { payload: { id: 5, group_id: 5 } };
    const dispatched = await recordSaga(
      updateSocialLink,
      initialAction
    );

    expect(api.socialLinks.update).toHaveBeenCalledWith(initialAction.payload.id, { social_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.update_social_link, options: { variant: 'warning' } });
  });
});

describe('Delete social link', () => {
  it('Should delete a social link', async () => {
    api.socialLinks.destroy.mockImplementation(() => Promise.resolve({ data: { socialLink } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'social link deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteSocialLinkSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { socialLink } };
    const dispatched = await recordSaga(
      deleteSocialLink,
      initialAction
    );

    expect(api.socialLinks.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete_social_link, options: { variant: 'success' } });
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.socialLinks.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete social link',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteSocialLinkError(response), notified];
    const initialAction = { payload: { id: 10 } };
    const dispatched = await recordSaga(
      deleteSocialLink,
      initialAction
    );

    expect(api.socialLinks.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete_social_link, options: { variant: 'warning' } });
  });
});

describe('Archive news item', () => {
  it('Should archive a news item', async () => {
    api.newsFeedLinks.archive.mockImplementation(() => Promise.resolve({ data: { newsItem } }));
    const results = [archiveNewsItemSuccess()];
    const initialAction = { payload: { newsItem } };
    const dispatched = await recordSaga(
      archiveNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.archive).toHaveBeenCalledWith(initialAction.payload.id, { news_feed_link: initialAction.payload });
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.archive.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to archive resource',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [archiveNewsItemError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      archiveNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.archive).toHaveBeenCalledWith(initialAction.payload.id, { news_feed_link: initialAction.payload });
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.archive, options: { variant: 'warning' } });
  });
});

describe('Approve news item', () => {
  it('Should approve a news item', async () => {
    api.newsFeedLinks.approve.mockImplementation(() => Promise.resolve({ data: {} }));
    const results = [approveNewsItemSuccess({})];
    const initialAction = { payload: { newsItem } };
    const dispatched = await recordSaga(
      approveNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.approve).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.approve.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to approve resource',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [approveNewsItemError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      approveNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.approve).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.approve, options: { variant: 'warning' } });
  });
});

describe('Pin news item', () => {
  it('Should pin a news item', async () => {
    api.newsFeedLinks.pin.mockImplementation(() => Promise.resolve({ data: { newsItem } }));
    const results = [pinNewsItemSuccess()];
    const initialAction = { payload: { newsItem } };
    const dispatched = await recordSaga(
      pinNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.pin).toHaveBeenCalledWith(initialAction.payload.id, initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.pin.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to pin resource',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [pinNewsItemError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      pinNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.pin).toHaveBeenCalledWith(initialAction.payload.id, initialAction.payload);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.pin, options: { variant: 'warning' } });
  });
});

describe('Unpin news item', () => {
  it('Should unpin a news item', async () => {
    api.newsFeedLinks.un_pin.mockImplementation(() => Promise.resolve({ data: { newsItem } }));
    const results = [unpinNewsItemSuccess()];
    const initialAction = { payload: { newsItem } };
    const dispatched = await recordSaga(
      unpinNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.un_pin).toHaveBeenCalledWith(initialAction.payload.id, initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.newsFeedLinks.un_pin.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to unpin resource',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [unpinNewsItemError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      unpinNewsItem,
      initialAction
    );

    expect(api.newsFeedLinks.un_pin).toHaveBeenCalledWith(initialAction.payload.id, initialAction.payload);
    expect(dispatched).toEqual(results);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.un_pin, options: { variant: 'warning' } });
  });
});
