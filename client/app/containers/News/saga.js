import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

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
  DELETE_GROUP_MESSAGE_COMMENT_SUCCESS, DELETE_GROUP_MESSAGE_COMMENT_ERROR, DELETE_GROUP_MESSAGE_COMMENT_BEGIN,
  ARCHIVE_NEWS_ITEM_BEGIN, ARCHIVE_NEWS_ITEM_SUCCESS, ARCHIVE_NEWS_ITEM_ERROR,
  PIN_NEWS_ITEM_BEGIN, PIN_NEWS_ITEM_SUCCESS, PIN_NEWS_ITEM_ERROR,
  UNPIN_NEWS_ITEM_BEGIN, UNPIN_NEWS_ITEM_SUCCESS, UNPIN_NEWS_ITEM_ERROR, APPROVE_NEWS_ITEM_BEGIN,
} from 'containers/News/constants';

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
  approveNewsItemSuccess, approveNewsItemError
} from 'containers/News/actions';

export function* getNewsItems(action) {
  try {
    const response = yield call(api.newsFeedLinks.all.bind(api.newsFeedLinks), action.payload);
    yield (put(getNewsItemsSuccess(response.data.page)));
  } catch (err) {
    yield put(getNewsItemsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.news_items), options: { variant: 'warning' } }));
  }
}

export function* getNewsItem(action) {
  try {
    const response = yield call(api.newsFeedLinks.get.bind(api.newsFeedLinks), action.payload.id);
    yield put(getNewsItemSuccess(response.data));
  } catch (err) {
    yield put(getNewsItemError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.news_item), options: { variant: 'warning' } }));
  }
}

export function* updateNewsItem(action) {
  try {
    const payload = { news_feed_link: action.payload };
    const response = yield call(api.newsFeedLinks.update.bind(api.newsFeedLinks), payload.news_feed_link.id, payload);

    yield put(updateNewsItemSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update_news_item), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateNewsItemError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update_news_item), options: { variant: 'warning' } }));
  }
}

export function* createGroupMessage(action) {
  try {
    const payload = { group_message: action.payload };
    const response = yield call(api.groupMessages.create.bind(api.groupMessages), payload);

    yield put(createGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_group_message), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_group_message), options: { variant: 'warning' } }));
  }
}

export function* updateGroupMessage(action) {
  try {
    const payload = { group_message: action.payload };
    const response = yield call(api.groupMessages.update.bind(api.groupMessages), payload.group_message.id, payload);

    yield put(updateGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update_group_message), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateGroupMessageError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update_group_message), options: { variant: 'warning' } }));
  }
}

export function* deleteGroupMessage(action) {
  try {
    yield call(api.groupMessages.destroy.bind(api.groupMessages), action.payload.id);
    yield put(deleteGroupMessageSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_group_message), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupMessageError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_group_message), options: { variant: 'warning' } }));
  }
}

export function* deleteGroupMessageComment(action) {
  try {
    yield call(api.groupMessageComments.destroy.bind(api.groupMessageComments), action.payload.id);
    yield put(deleteGroupMessageCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_group_message_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteGroupMessageCommentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_group_message_comment), options: { variant: 'warning' } }));
  }
}

export function* createGroupMessageComment(action) {
  // create comment & re-fetch news feed link from server

  try {
    const payload = { group_message_comment: action.payload.attributes };
    const response = yield call(api.groupMessageComments.create.bind(api.groupMessageComments), payload);

    yield put(createGroupMessageCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_feed_link_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_group_message_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createGroupMessageCommentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_group_message_comment), options: { variant: 'warning' } }));
  }
}

export function* createNewsLink(action) {
  try {
    const payload = { news_link: action.payload };
    const response = yield call(api.newsLinks.create.bind(api.newsLinks), payload);

    yield put(createNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_news_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createNewsLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_news_link), options: { variant: 'warning' } }));
  }
}

export function* updateNewsLink(action) {
  try {
    const payload = { news_link: action.payload };
    const response = yield call(api.newsLinks.update.bind(api.newsLinks), payload.news_link.id, payload);

    yield put(updateNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update_news_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateNewsLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update_news_link), options: { variant: 'warning' } }));
  }
}

export function* deleteNewsLink(action) {
  try {
    yield call(api.newsLinks.destroy.bind(api.newsLinks), action.payload.id);
    yield put(deleteNewsLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_news_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteNewsLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_news_link), options: { variant: 'warning' } }));
  }
}

export function* createNewsLinkComment(action) {
  // create comment & re-fetch news feed link from server

  try {
    const payload = { news_link_comment: action.payload.attributes };
    const response = yield call(api.newsLinkComments.create.bind(api.newsLinkComments), payload);

    yield put(createNewsLinkCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_feed_link_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_news_link_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createNewsLinkCommentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_news_link_comment), options: { variant: 'warning' } }));
  }
}

export function* deleteNewsLinkComment(action) {
  try {
    yield call(api.newsLinkComments.destroy.bind(api.newsLinkComments), action.payload.id);
    yield put(deleteNewsLinkCommentSuccess());
    yield put(getNewsItemBegin({ id: action.payload.news_id }));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_news_link_comment), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteNewsLinkCommentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_news_link_comment), options: { variant: 'warning' } }));
  }
}

export function* createSocialLink(action) {
  try {
    const payload = { social_link: action.payload };
    const response = yield call(api.socialLinks.create.bind(api.socialLinks), action.payload);

    yield put(createSocialLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create_social_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSocialLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create_social_link), options: { variant: 'warning' } }));
  }
}

export function* updateSocialLink(action) {
  try {
    const payload = { social_link: action.payload };
    const response = yield call(api.socialLinks.update.bind(api.socialLinks), payload.social_link.id, payload);

    yield put(updateSocialLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update_social_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSocialLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update_social_link), options: { variant: 'warning' } }));
  }
}

export function* deleteSocialLink(action) {
  try {
    yield call(api.socialLinks.destroy.bind(api.socialLinks), action.payload.id);
    yield put(deleteSocialLinkSuccess());
    yield put(push(ROUTES.group.news.index.path(action.payload.group_id)));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete_social_link), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSocialLinkError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete_social_link), options: { variant: 'warning' } }));
  }
}

export function* archiveNewsItem(action) {
  try {
    const payload = { news_feed_link: action.payload };
    const response = yield call(api.newsFeedLinks.archive.bind(api.newsFeedLinks), payload.news_feed_link.id, payload);
    yield put(archiveNewsItemSuccess());
  } catch (err) {
    yield put(archiveNewsItemError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.archive),
      options: { variant: 'warning' }
    }));
  }
}

export function* approveNewsItem(action) {
  try {
    const { callback, id, ...rest } = action.payload;
    const response = yield call(api.newsFeedLinks.approve.bind(api.newsFeedLinks), id);
    yield put(approveNewsItemSuccess(response.data));
  } catch (err) {
    yield put(approveNewsItemError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.approve),
      options: { variant: 'warning' }
    }));
  }
}

export function* pinNewsItem(action) {
  try {
    const payload = { news_feed_link: action.payload };
    const { callback, ...rest } = action.payload;
    const response = yield call(api.newsFeedLinks.pin.bind(api.newsFeedLinks), payload.news_feed_link.id, rest);
    yield put(pinNewsItemSuccess());
  } catch (err) {
    yield put(pinNewsItemError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.pin),
      options: { variant: 'warning' }
    }));
  }
}

export function* unpinNewsItem(action) {
  try {
    const payload = { news_feed_link: action.payload };
    const { callback, ...rest } = action.payload;
    const response = yield call(api.newsFeedLinks.un_pin.bind(api.newsFeedLinks), payload.news_feed_link.id, rest);
    yield put(unpinNewsItemSuccess());
  } catch (err) {
    yield put(unpinNewsItemError(err));
    yield put(showSnackbar({
      message: intl.formatMessage(messages.snackbars.errors.un_pin),
      options: { variant: 'warning' }
    }));
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
  yield takeLatest(ARCHIVE_NEWS_ITEM_BEGIN, archiveNewsItem);
  yield takeLatest(APPROVE_NEWS_ITEM_BEGIN, approveNewsItem);
  yield takeLatest(PIN_NEWS_ITEM_BEGIN, pinNewsItem);
  yield takeLatest(UNPIN_NEWS_ITEM_BEGIN, unpinNewsItem);
}
