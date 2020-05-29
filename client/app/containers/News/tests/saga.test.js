import {
  getNewsItems, getNewsItem, updateNewsItem, createGroupMessage, updateGroupMessage, deleteGroupMessage,
  deleteGroupMessageComment, createGroupMessageComment, createNewsLink, updateNewsLink, deleteNewsLink,
  createNewsLinkComment, deleteNewsLinkComment, createSocialLink, updateSocialLink, deleteSocialLink,
  archiveNewsItem, approveNewsItem, pinNewsItem, unpinNewsItem
} from 'containers/News/saga';
import {
  getNewsItemsBegin, getNewsItemsSuccess, getNewsItemsError,
  getNewsItemBegin, getNewsItemSuccess, getNewsItemError,
  createGroupMessageBegin, createGroupMessageSuccess, createGroupMessageError,
  updateGroupMessageBegin, updateGroupMessageSuccess, updateGroupMessageError,
  deleteGroupMessageBegin, deleteGroupMessageSuccess, deleteGroupMessageError,
  newsFeedUnmount
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
api.newsFeedLinks.pin = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});
const newsitem = {
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

describe('Get news items Saga', () => {
  it('Should return newsItems list', async () => {
    api.newsFeedLinks.all.mockImplementation(() => Promise.resolve({ data: { page: { ...newsitem } } }));
    const results = [getNewsItemsSuccess(newsitem)];

    const initialAction = { payload: {
      count: 5,
    } };

    const dispatched = await recordSaga(
      getNewsItems,
      initialAction
    );

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
