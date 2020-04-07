import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_SPONSORS_BEGIN, GET_SPONSOR_BEGIN, CREATE_SPONSOR_BEGIN,
  DELETE_SPONSOR_BEGIN, UPDATE_SPONSOR_BEGIN, UPDATE_SPONSOR_SUCCESS, UPDATE_SPONSOR_ERROR
} from 'containers/Branding/Sponsor/constants';

import {
  CREATE_GROUP_SPONSOR_BEGIN, UPDATE_GROUP_SPONSOR_BEGIN
} from '../../Group/GroupManage/GroupSponsors/constants';

import {
  getSponsorsSuccess, getSponsorsError, deleteSponsorSuccess,
  createSponsorError, deleteSponsorError, createSponsorSuccess,
  updateSponsorBegin, updateSponsorSuccess, updateSponsorError, getSponsorSuccess, getSponsorError,
} from 'containers/Branding/Sponsor/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getSponsors(action) {
  try {
    const response = yield call(api.sponsors.all.bind(api.sponsors), action.payload);

    yield put(getSponsorsSuccess(response.data.page));
  } catch (err) {
    yield put(getSponsorsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load sponsors', options: { variant: 'warning' } }));
  }
}

export function* getSponsor(action) {
  try {
    const response = yield call(api.sponsors.get.bind(api.sponsors), action.payload.id);
    yield put(getSponsorSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getSponsorError(err));
    yield put(showSnackbar({
      message: 'Failed to get sponsor',
      options: { variant: 'warning' }
    }));
  }
}

export function* createSponsors(action, sponsorableKey) {
  try {
    const payload = { sponsor: action.payload };
    payload[sponsorableKey] = payload.sponsor.sponsorableId;

    const response = yield call(api.sponsors.create.bind(api.sponsors), payload);

    // Route to different location based on the call made
    if (action.type === CREATE_GROUP_SPONSOR_BEGIN)
      yield put(push(ROUTES.group.manage.sponsors.index.path(payload.sponsor.sponsorableId)));
    else
      yield put(push(ROUTES.admin.system.branding.sponsors.index.path()));

    yield put(createSponsorSuccess());

    yield put(showSnackbar({ message: 'Sponsor created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSponsorError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create sponsors', options: { variant: 'warning' } }));
  }
}

export function* deleteSponsors(action) {
  try {
    yield call(api.sponsors.destroy.bind(api.sponsors), action.payload.id);
    yield put(deleteSponsorSuccess());

    yield put(push(ROUTES.admin.system.branding.sponsors.index.path()));
    yield put(showSnackbar({ message: 'Sponsor deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSponsorError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove sponsors', options: { variant: 'warning' } }));
  }
}

export function* updateSponsor(action) {
  try {
    const payload = { sponsor: action.payload };
    const response = yield call(api.sponsors.update.bind(api.sponsors), payload.sponsor.id, payload);

    // Route to different location based on the call made
    if (action.type === UPDATE_GROUP_SPONSOR_BEGIN)
      yield put(push(ROUTES.group.manage.sponsors.index.path(payload.sponsor.sponsorableId)));
    else
      yield put(push(ROUTES.admin.system.branding.sponsors.index.path()));
    yield put(updateSponsorSuccess());
    yield put(showSnackbar({
      message: 'Sponsor updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateSponsorError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update sponsor',
      options: { variant: 'warning' }
    }));
  }
}

export default function* sponsorsSaga() {
  yield takeLatest(GET_SPONSORS_BEGIN, getSponsors);
  yield takeLatest(GET_SPONSOR_BEGIN, getSponsor);
  yield takeLatest(UPDATE_SPONSOR_BEGIN, updateSponsor);
  yield takeLatest(UPDATE_GROUP_SPONSOR_BEGIN, updateSponsor);
  yield takeLatest(CREATE_SPONSOR_BEGIN, action => createSponsors(action, 'enterprise_id'));
  yield takeLatest(CREATE_GROUP_SPONSOR_BEGIN, action => createSponsors(action, 'group_id'));
  yield takeLatest(DELETE_SPONSOR_BEGIN, deleteSponsors);
}
