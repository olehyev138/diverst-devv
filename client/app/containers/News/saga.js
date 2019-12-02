import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEM_BEGIN,
  CREATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_BEGIN,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_NEWSLINK_BEGIN, UPDATE_NEWSLINK_BEGIN,
  CREATE_NEWSLINK_COMMENT_BEGIN
} from 'containers/News/constants';

import {
  getNewsItemsSuccess, getNewsItemsError,
  getNewsItemBegin, getNewsItemSuccess, getNewsItemError,
  createGroupMessageSuccess, createGroupMessageError,
  createGroupMessageCommentError, updateGroupMessageSuccess,
  createGroupMessageCommentSuccess, createNewslinkBegin,
  createNewslinkSuccess, createNewslinkError, createNewslinkCommentError,
  updateNewslinkSuccess, createNewslinkCommentSuccess
} from 'containers/News/actions';


export function* getNewsItems(action) {
  try {
    const response = yield call(api.newsFeedLinks.all.bind(api.newsFeedLinks), action.payload);
    yield (put(getNewsItemsSuccess(response.data.page)));
  } catch (err) {
    yield put(getNewsItemsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load news', options: { variant: 'warning' } }));
  }
}

export function* getNewsItem(action) {
  try {
    const response = yield call(api.newsFeedLinks.get.bind(api.newsFeedLinks), action.payload.id);
    yield put(getNewsItemSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getNewsItemError(err));
    yield put(showSnackbar({ message: 'Failed to load news item', options: { variant: 'warning' } }));
  }
}

export function* createGroupMessage(action) {
  try {
    const payload = { group_message: action.payload };
    const response = yield call(api.groupMessages.create.bind(api.groupMessages), payload);

    yield put(createGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Group message created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group message', options: { variant: 'warning' } }));
  }
}

export function* updateGroupMessage(action) {
  try {
    const payload = { group_message: action.payload };
    const response = yield call(api.groupMessages.update.bind(api.groupMessages), payload.group_message.id, payload);

    yield put(updateGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Group message updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update group message', options: { variant: 'warning' } }));
  }
}

export function* createGroupMessageComment(action) {
  // create comment & re-fetch news feed link from server

  try {
    const payload = { group_message_comment: action.payload.attributes };
    const response = yield call(api.groupMessageComments.create.bind(api.groupMessageComments), payload);

    yield put(createGroupMessageCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_feed_link_id }));
    yield put(showSnackbar({ message: 'Group message comment created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create group message', options: { variant: 'warning' } }));
  }
}

export function* createNewslink(action) {
  try {
    const payload = { news_link : action.payload };
    console.log(payload);
    const response = yield call(api.newsFeedLinks.create.bind(api.newsFeedLinks), payload);

    yield put(createGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.id)));
    yield put(showSnackbar({ message: 'News link created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createNewslinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create news link ', options: { variant: 'warning' } }));
  }
}

export function* updateNewslink(action) {
  try {
    const payload = { news_link: action.payload };
    const response = yield call(api.newsFeedLinks.update.bind(api.newsFeedLinks), payload.news_link.id, payload);

    yield put(updateGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.id)));
    yield put(showSnackbar({ message: 'News link updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update news link', options: { variant: 'warning' } }));
  }
}

export default function* newsSaga() {
  yield takeLatest(GET_NEWS_ITEMS_BEGIN, getNewsItems);
  yield takeLatest(GET_NEWS_ITEM_BEGIN, getNewsItem);
  yield takeLatest(CREATE_GROUP_MESSAGE_BEGIN, createGroupMessage);
  yield takeLatest(UPDATE_GROUP_MESSAGE_BEGIN, updateGroupMessage);
  yield takeLatest(CREATE_GROUP_MESSAGE_COMMENT_BEGIN, createGroupMessageComment);
  yield takeLatest(CREATE_NEWSLINK_BEGIN, createNewslink);
  yield takeLatest(UPDATE_NEWSLINK_BEGIN, updateNewslink);
}
