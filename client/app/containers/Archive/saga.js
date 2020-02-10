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
    const response = yield call(api.resources.all.bind(api.resources), rest);
    // TODO : Implement actions in the case of posts & events
    switch (resource) {
      case 'resources':
        yield (put(getArchivesSuccess(response.data.page)));
        break;
      case 'posts':
        response.data.page.items[0].title = 'THIS IS A POST NOT A RESOURCE';
        yield (put(getArchivesSuccess(response.data.page)));
        break;
      case 'events':
        response.data.page.items[0].title = 'THIS IS AN EVENT NOT A RESOURCE';
        yield (put(getArchivesSuccess(response.data.page)));
        break;
    }
  } catch (err) {
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
    //TODO rename variable
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
