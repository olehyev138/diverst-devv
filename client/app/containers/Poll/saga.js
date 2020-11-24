import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_POLL_BEGIN,
  GET_POLLS_BEGIN,
  CREATE_POLL_BEGIN,
  UPDATE_POLL_BEGIN,
  CREATE_POLL_AND_PUBLISH_BEGIN,
  UPDATE_POLL_AND_PUBLISH_BEGIN,
  PUBLISH_POLL_BEGIN,
  DELETE_POLL_BEGIN,
} from './constants';

import {
  getPollSuccess, getPollError,
  getPollsSuccess, getPollsError,
  createPollSuccess, createPollError,
  updatePollSuccess, updatePollError,
  createPollAndPublishSuccess, createPollAndPublishError,
  updatePollAndPublishSuccess, updatePollAndPublishError,
  publishPollSuccess, publishPollError,
  deletePollSuccess, deletePollError,
} from './actions';

export function* getPoll(action) {
  try {
    const response = yield call(api.polls.get.bind(api.polls), action.payload.id);

    yield put(getPollSuccess(response.data));
  } catch (err) {
    yield put(getPollError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.poll, options: { variant: 'warning' } }));
  }
}

export function* getPolls(action) {
  try {
    const response = yield call(api.polls.all.bind(api.polls), action.payload);

    yield put(getPollsSuccess(response.data.page));
  } catch (err) {
    yield put(getPollsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.polls, options: { variant: 'warning' } }));
  }
}

export function* createPoll(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.create.bind(api.polls), payload);

    yield put(createPollSuccess());
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPollError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* updatePoll(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.update.bind(api.polls), action.payload.id, payload);

    yield put(updatePollSuccess());
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updatePollError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* createPollAndPublish(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.createAndPublish.bind(api.polls), payload);

    yield put(createPollAndPublishSuccess());
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.create_publish, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPollAndPublishError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.create_publish, options: { variant: 'warning' } }));
  }
}

export function* updatePollAndPublish(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.updateAndPublish.bind(api.polls), action.payload.id, payload);

    yield put(updatePollAndPublishSuccess());
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.update_publish, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updatePollAndPublishError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.update_publish, options: { variant: 'warning' } }));
  }
}

export function* publishPoll(action) {
  try {
    const response = yield call(api.polls.publish.bind(api.polls), action.payload.id);

    yield put(publishPollSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.publish, options: { variant: 'success' } }));
  } catch (err) {
    yield put(publishPollError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.publish, options: { variant: 'warning' } }));
  }
}

export function* deletePoll(action) {
  try {
    yield call(api.polls.destroy.bind(api.polls), action.payload.id);
    yield put(deletePollSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deletePollError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}


export default function* PollSaga() {
  yield takeLatest(GET_POLL_BEGIN, getPoll);
  yield takeLatest(GET_POLLS_BEGIN, getPolls);
  yield takeLatest(CREATE_POLL_BEGIN, createPoll);
  yield takeLatest(UPDATE_POLL_BEGIN, updatePoll);
  yield takeLatest(CREATE_POLL_AND_PUBLISH_BEGIN, createPollAndPublish);
  yield takeLatest(UPDATE_POLL_AND_PUBLISH_BEGIN, updatePollAndPublish);
  yield takeLatest(PUBLISH_POLL_BEGIN, publishPoll);
  yield takeLatest(DELETE_POLL_BEGIN, deletePoll);
}
