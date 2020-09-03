import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_SEGMENTS_BEGIN, CREATE_SEGMENT_BEGIN,
  GET_SEGMENT_BEGIN, UPDATE_SEGMENT_BEGIN,
  GET_SEGMENT_MEMBERS_BEGIN, DELETE_SEGMENT_BEGIN
} from 'containers/Segment/constants';

import {
  getSegmentsSuccess, getSegmentsError,
  createSegmentSuccess, createSegmentError,
  getSegmentSuccess, getSegmentError,
  updateSegmentSuccess, updateSegmentError,
  getSegmentMembersSuccess, getSegmentMembersError,
  deleteSegmentError, deleteSegmentSuccess,
} from 'containers/Segment/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { getMembersError, getMembersSuccess } from 'containers/Group/GroupMembers/actions';

export function* getSegments(action) {
  try {
    const response = yield call(api.segments.all.bind(api.segments), action.payload);

    yield put(getSegmentsSuccess(response.data.page));
  } catch (err) {
    yield put(getSegmentsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.segments), options: { variant: 'warning' } }));
  }
}

export function* getSegment(action) {
  try {
    const response = yield call(api.segments.get.bind(api.segments), action.payload.id);
    yield put(getSegmentSuccess(response.data));
  } catch (err) {
    yield put(getSegmentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.segment), options: { variant: 'warning' } }));
  }
}


export function* createSegment(action) {
  try {
    const payload = { segment: action.payload };

    const response = yield call(api.segments.create.bind(api.segments), payload);

    yield put(createSegmentSuccess());
    // TODO: get id from response & direct to show/update page
    yield put(push(ROUTES.admin.manage.segments.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSegmentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export function* updateSegment(action) {
  try {
    const payload = { segment: action.payload };
    const response = yield call(api.segments.update.bind(api.segments), payload.segment.id, payload);

    yield put(updateSegmentSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSegmentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deleteSegment(action) {
  try {
    yield call(api.segments.destroy.bind(api.segments), action.payload);

    yield put(deleteSegmentSuccess());
    yield put(push(ROUTES.admin.manage.segments.index.path()));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSegmentError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* getSegmentMembers(action) {
  try {
    const response = yield call(api.userSegments.all.bind(api.userSegments), action.payload);

    yield put(getSegmentMembersSuccess(response.data.page));
  } catch (err) {
    yield put(getSegmentMembersError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.members), options: { variant: 'warning' } }));
  }
}

export default function* segmentsSaga() {
  yield takeLatest(GET_SEGMENTS_BEGIN, getSegments);
  yield takeLatest(GET_SEGMENT_BEGIN, getSegment);
  yield takeLatest(CREATE_SEGMENT_BEGIN, createSegment);
  yield takeLatest(UPDATE_SEGMENT_BEGIN, updateSegment);
  yield takeLatest(DELETE_SEGMENT_BEGIN, deleteSegment);
  yield takeLatest(GET_SEGMENT_MEMBERS_BEGIN, getSegmentMembers);
}
