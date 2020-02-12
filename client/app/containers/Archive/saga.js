import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import {
  GET_ARCHIVES_BEGIN,
  RESTORE_ARCHIVE_BEGIN,
} from './constants';

import {
  getArchivesSuccess,
  getArchivesError,
  restoreArchiveSuccess,
  restoreArchiveError
} from './actions';

const ArchiveTypes = Object.freeze({
  posts: 'posts',
  resources: 'resources',
  events: 'events',
});

export function* getArchives(action) {
  try {
    const { payload } = action;
    const { resource, ...rest } = payload;
    // TODO : Implement actions in the case of posts
    switch (resource) {
      case ArchiveTypes.resources:
        yield (put(getArchivesSuccess(yield call(api.resources.all.bind(api.resources), rest).data.page)));
        break;
      case ArchiveTypes.posts:
        yield (put(getArchivesSuccess(yield call(api.resources.all.bind(api.resources), rest).data.page)));
        break;
      case ArchiveTypes.events:
        yield (put(getArchivesSuccess(yield call(api.initiatives.all.bind(api.initiatives), rest).data.page)));
        break;
      default:
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
    // TODO rename variable

    switch (resource.resource) {
      case ArchiveTypes.resources:
        yield call(api.resources.un_archive.bind(api.resources), payload.resource.id, payload);
        yield (put(restoreArchiveSuccess()));
        break;
      case ArchiveTypes.posts:
        yield (put(restoreArchiveSuccess()));
        break;
      case ArchiveTypes.events:
        yield call(api.initiatives.un_archive.bind(api.initiatives), payload.resource.id, payload);
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
