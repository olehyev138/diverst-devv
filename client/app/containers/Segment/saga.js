import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_SEGMENTS_BEGIN, CREATE_SEGMENT_BEGIN,
  GET_SEGMENT_BEGIN, UPDATE_SEGMENT_BEGIN, DELETE_SEGMENT_BEGIN
} from 'containers/Segment/constants';

import {
  getSegmentsSuccess, getSegmentsError,
  createSegmentSuccess, createSegmentError,
  getSegmentSuccess, getSegmentError,
  updateSegmentSuccess, updateSegmentError,
  deleteSegmentError
} from 'containers/Segment/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getSegments(action) {
  try {
    const response = yield call(api.segments.all.bind(api.segments), action.payload);

    yield put(getSegmentsSuccess(response.data.page));
  } catch (err) {
    yield put(getSegmentsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load segments', options: { variant: 'warning' } }));
  }
}

export function* getSegment(action) {
  try {
    const response = yield call(api.segments.get.bind(api.segments), action.payload.id);
    yield put(getSegmentSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getSegmentError(err));
    yield put(showSnackbar({ message: 'Failed to get segment', options: { variant: 'warning' } }));
  }
}


export function* createSegment(action) {
  try {
    const payload = { segment: action.payload };

    const response = yield call(api.segments.create.bind(api.segments), payload);

    yield put(push(ROUTES.admin.manage.segments.index.path()));
    yield put(showSnackbar({ message: 'Segment created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSegmentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create segment', options: { variant: 'warning' } }));
  }
}

export function* updateSegment(action) {
  try {
    const payload = { segment: action.payload };
    const response = yield call(api.segments.update.bind(api.segments), payload.segment.id, payload);

    yield put(push(ROUTES.admin.manage.segments.index.path()));
    yield put(showSnackbar({ message: 'Segment updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSegmentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update segment', options: { variant: 'warning' } }));
  }
}

export function* deleteSegment(action) {
  try {
    yield call(api.segments.destroy.bind(api.segments), action.payload);
    yield put(push(ROUTES.admin.manage.segments.index.path()));
    yield put(showSnackbar({ message: 'Segment deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSegmentError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update segment', options: { variant: 'warning' } }));
  }
}

export default function* segmentsSaga() {
  yield takeLatest(GET_SEGMENTS_BEGIN, getSegments);
  yield takeLatest(GET_SEGMENT_BEGIN, getSegment);
  yield takeLatest(CREATE_SEGMENT_BEGIN, createSegment);
  yield takeLatest(UPDATE_SEGMENT_BEGIN, updateSegment);

  yield takeLatest(DELETE_SEGMENT_BEGIN, deleteSegment);
}
