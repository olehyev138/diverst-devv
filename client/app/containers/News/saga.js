import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEM_BEGIN, UPDATE_NEWS_ITEM_BEGIN,
  UPDATE_NEWS_ITEM_ERROR, UPDATE_NEWS_ITEM_SUCCESS,
  CREATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_BEGIN,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_NEWSLINK_BEGIN, UPDATE_NEWSLINK_BEGIN,
  CREATE_NEWSLINK_COMMENT_BEGIN,
  CREATE_SOCIALLINK_BEGIN, UPDATE_SOCIALLINK_BEGIN,
  CREATE_SOCIALLINK_COMMENT_BEGIN, DELETE_GROUP_MESSAGE_BEGIN, DELETE_GROUP_MESSAGE_SUCCESS,
  DELETE_GROUP_MESSAGE_ERROR, DELETE_SOCIALLINK_BEGIN, DELETE_SOCIALLINK_SUCCESS, DELETE_SOCIALLINK_ERROR,
  DELETE_NEWSLINK_BEGIN, DELETE_NEWSLINK_SUCCESS, DELETE_NEWSLINK_ERROR, DELETE_NEWSLINK_COMMENT_BEGIN,
  DELETE_GROUP_MESSAGE_COMMENT_SUCCESS, DELETE_GROUP_MESSAGE_COMMENT_ERROR, DELETE_GROUP_MESSAGE_COMMENT_BEGIN
} from 'containers/News/constants';

import {
  getNewsItemsSuccess, getNewsItemsError,
  getNewsItemBegin, getNewsItemSuccess, getNewsItemError,
  updateNewsItemBegin, updateNewsItemError, updateNewsItemSuccess,
  createGroupMessageSuccess, createGroupMessageError,
  createGroupMessageCommentError, updateGroupMessageSuccess,
  createGroupMessageCommentSuccess, createNewsLinkBegin,
  createNewsLinkSuccess, createNewsLinkError, createNewsLinkCommentError,
  updateNewsLinkSuccess, createNewsLinkCommentSuccess,
  createSocialLinkBegin, deleteGroupMessageBegin, deleteGroupMessageError, deleteGroupMessageSuccess,
  createSocialLinkSuccess, createSocialLinkError, createSocialLinkCommentError,
  updateSocialLinkSuccess, createSocialLinkCommentSuccess, deleteNewsLinkBegin, deleteNewsLinkError,
  deleteNewsLinkSuccess, deleteSocialLinkBegin, deleteSocialLinkError, deleteSocialLinkSuccess,
  deleteGroupMessageCommentBegin, deleteGroupMessageCommentError, deleteGroupMessageCommentSuccess, deleteNewsLinkCommentBegin,
  deleteNewsLinkCommentError, deleteNewsLinkCommentSuccess
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

export function* updateNewsItem(action) {
  try {
    const payload = { news_feed_link: action.payload };
    const response = yield call(api.newsFeedLinks.update.bind(api.newsFeedLinks), payload.news_feed_link.id, payload);

    yield put(updateNewsItemSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'News feed link updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update news feed link', options: { variant: 'warning' } }));
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

export function* deleteGroupMessage(action) {
  try {
    yield call(api.groupMessages.destroy.bind(api.groupMessages), action.payload.id);
    yield put(deleteGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Message deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove message', options: { variant: 'warning' } }));
  }
}

export function* deleteGroupMessageComment(action) {
  try {
    yield call(api.groupMessageComments.destroy.bind(api.groupMessageComments), action.payload.id);
    yield put(deleteGroupMessageCommentSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Group message comment deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupMessageCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove group message comment', options: { variant: 'warning' } }));
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

export function* createNewsLink(action) {
  try {
    const payload = { news_link: action.payload };
    const response = yield call(api.newsLinks.create.bind(api.newsLinks), payload);

    yield put(createNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'News link created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createNewsLinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create news link ', options: { variant: 'warning' } }));
  }
}

export function* updateNewsLink(action) {
  try {
    const payload = { news_link: action.payload };
    const response = yield call(api.newsLinks.update.bind(api.newsLinks), payload.news_link.id, payload);

    yield put(updateNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.id)));
    yield put(showSnackbar({ message: 'News link updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update news link', options: { variant: 'warning' } }));
  }
}

export function* deleteNewsLink(action) {
  try {
    yield call(api.newsLinks.destroy.bind(api.newsLinks), action.payload.id);
    yield put(deleteNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'News link deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteNewsLinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove news link', options: { variant: 'warning' } }));
  }
}

export function* createNewsLinkComment(action) {
  // create comment & re-fetch news feed link from server

  try {
    const payload = { news_link_comment: action.payload.attributes };
    const response = yield call(api.newsLinkComments.create.bind(api.newsLinkComments), payload);

    yield put(createNewsLinkCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_feed_link_id }));
    yield put(showSnackbar({ message: 'News link comment created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createNewsLinkCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create news link comment', options: { variant: 'warning' } }));
  }
}

export function* deleteNewsLinkComment(action) {
  try {
    yield call(api.newsLinkComments.destroy.bind(api.newsLinkComments), action.payload.id);
    yield put(deleteNewsLinkCommentSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'News link comment deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteNewsLinkCommentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove news link comment', options: { variant: 'warning' } }));
  }
}

export function* createSocialLink(action) {
  try {
    const payload = { social_link: action.payload };
    const response = yield call(api.socialLinks.create.bind(api.socialLinks), action.payload);

    yield put(createSocialLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Social link created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSocialLinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create social link ', options: { variant: 'warning' } }));
  }
}

export function* updateSocialLink(action) {
  try {
    const payload = { social_link: action.payload };
    const response = yield call(api.socialLinks.update.bind(api.socialLinks), payload.social_link.id, payload);

    yield put(updateSocialLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.id)));
    yield put(showSnackbar({ message: 'Social link updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update social link', options: { variant: 'warning' } }));
  }
}

export function* deleteSocialLink(action) {
  try {
    yield call(api.socialLinks.destroy.bind(api.socialLinks), action.payload.id);
    yield put(deleteNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: 'Social link deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteNewsLinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove social link', options: { variant: 'warning' } }));
  }
}

export default function* newsSaga() {
  yield takeLatest(GET_NEWS_ITEMS_BEGIN, getNewsItems);
  yield takeLatest(GET_NEWS_ITEM_BEGIN, getNewsItem);
  yield takeLatest(UPDATE_NEWS_ITEM_BEGIN, updateNewsItem);
  yield takeLatest(CREATE_GROUP_MESSAGE_BEGIN, createGroupMessage);
  yield takeLatest(UPDATE_GROUP_MESSAGE_BEGIN, updateGroupMessage);
  yield takeLatest(CREATE_GROUP_MESSAGE_COMMENT_BEGIN, createGroupMessageComment);
  yield takeLatest(CREATE_NEWSLINK_BEGIN, createNewsLink);
  yield takeLatest(CREATE_NEWSLINK_COMMENT_BEGIN, createNewsLinkComment);
  yield takeLatest(UPDATE_NEWSLINK_BEGIN, updateNewsLink);
  yield takeLatest(CREATE_SOCIALLINK_BEGIN, createSocialLink);
  yield takeLatest(UPDATE_SOCIALLINK_BEGIN, updateSocialLink);
  yield takeLatest(DELETE_GROUP_MESSAGE_BEGIN, deleteGroupMessage);
  yield takeLatest(DELETE_NEWSLINK_BEGIN, deleteNewsLink);
  yield takeLatest(DELETE_NEWSLINK_COMMENT_BEGIN, deleteNewsLinkComment);
  yield takeLatest(DELETE_SOCIALLINK_BEGIN, deleteSocialLink);
  yield takeLatest(DELETE_GROUP_MESSAGE_COMMENT_BEGIN, deleteGroupMessageComment);
}
