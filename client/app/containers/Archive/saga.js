import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR,
  RESTORE_ARCHIVE_BEGIN,
  RESTORE_ARCHIVE_SUCCESS,
  RESTORE_ARCHIVE_ERROR
} from './constants';

import {
  getArchivesBegin,
  getArchivesSuccess,
  getArchivesError,
  restoreArchiveBegin,
  restoreArchiveSuccess,
  restoreArchiveError
} from './actions';

export function* getArchives(action) {
  try {
    const { payload } = action;
    const { resource, ...rest } = payload;
    // TODO : Implement actions in the case of posts & events
    switch (resource) {
      case 'resources':
        const resourceResponse = yield call(api.resources.all.bind(api.resources), rest);
        yield (put(getArchivesSuccess(resourceResponse.data.page)));
        break;
      case 'posts':
        const postResponse = yield call(api.resources.all.bind(api.resources), rest);
        yield (put(getArchivesSuccess(postResponse.data.page)));
        break;
      case 'events':
        const eventResponse = yield call(api.initiatives.all.bind(api.initiatives), rest);
        yield (put(getArchivesSuccess(eventResponse.data.page)));
        break;
      default:
        break;
    }
  } catch (err) {
    console.log(err);
    yield put(getArchivesError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to load archives',
      options: { variant: 'warning' }
    }));
  }
}

export function* unArchive(action) {
  try {
    const payload = { resource: action.payload };
    const { resource, ...rest } = payload;
    // TODO rename variable
    const response = yield call(api.resources.un_archive.bind(api.resources), payload.resource.id, payload);

    switch (resource.resource) {
      case 'resources':
        yield (put(restoreArchiveSuccess()));
        break;
      case 'posts':
        yield (put(restoreArchiveSuccess()));
        break;
      case 'events':
        yield (put(restoreArchiveSuccess()));
        break;
      default:
        break;
    }
  } catch (err) {
    yield put(restoreArchiveError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to restore archived item',
      options: { variant: 'warning' }
    }));
  }
}

export default function* archivesSaga() {
  yield takeLatest(GET_ARCHIVES_BEGIN, getArchives);
  yield takeLatest(RESTORE_ARCHIVE_BEGIN, unArchive);
}
