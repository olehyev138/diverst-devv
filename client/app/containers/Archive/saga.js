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
    let response = null;
    switch (resource) {
      case ArchiveTypes.resources:
        response = yield call(api.resources.all.bind(api.resources), rest);
        yield (put(getArchivesSuccess(response.data.page)));
        break;
      case ArchiveTypes.posts:
        response = yield call(api.newsFeedLinks.all.bind(api.newsFeedLinks), rest);
        yield (put(getArchivesSuccess(response.data.page)));
        break;
      case ArchiveTypes.events:
        response = yield call(api.initiatives.all.bind(api.initiatives), rest);
        yield (put(getArchivesSuccess(response.data.page)));
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
    const resourceType = resource.resource;

    switch (resourceType) {
      case ArchiveTypes.resources:
        yield call(api.resources.un_archive.bind(api.resources), payload.resource.id, payload);
        yield (put(restoreArchiveSuccess()));
        break;
      case ArchiveTypes.posts:
        yield call(api.newsFeedLinks.un_archive.bind(api.newsFeedLinks), payload.resource.id, payload);
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
