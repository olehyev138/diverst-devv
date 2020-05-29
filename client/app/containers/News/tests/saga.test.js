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
  createNewsLinkCommentSuccess,
  createSocialLinkBegin,
  deleteGroupMessageBegin,
  deleteGroupMessageError,
  deleteGroupMessageSuccess,
  createSocialLinkSuccess,
  createSocialLinkError,
  createSocialLinkCommentError,
  updateSocialLinkSuccess,
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
api.newsFeedLinks.achieve = jest.fn();
api.newsFeedLinks.approve = jest.fn();
api.newsFeedLinks.pin = jest.fn();
api.newsFeedLinks.unpin = jest.fn();

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

describe('Get news items Saga', () => {
  it('Should return newsItems list', async () => {
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
        message: 'Failed to load news',
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
    const results = [deleteGroupMessageCommentSuccess(), push(ROUTES.group.news.index.path(':group_id')), notified];
    const initialAction = { payload: { groupMessageComment } };
    const dispatched = await recordSaga(
      deleteGroupMessageComment,
      initialAction
    );

    expect(api.groupMessageComments.destroy).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
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
  });
});
