/**
 * Test sagas
 */

import {
  getArchives, unArchive
} from '../saga';

import {
  getArchivesError, getArchivesSuccess,
  restoreArchiveError, restoreArchiveSuccess
} from '../actions';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.resources.archived = jest.fn();
api.newsFeedLinks.archived = jest.fn();
api.initiatives.archived = jest.fn();
api.resources.un_archive = jest.fn();
api.newsFeedLinks.un_archive = jest.fn();
api.initiatives.un_archive = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const archiveNews = {
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'id',
  resource: 'posts'
};

const archiveResources = {
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'id',
  resource: 'resources'
};

const archiveEvents = {
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'id',
  resource: 'events'
};

const unArchiveEvents = {
  id: 32,
  resource: 'events'
};

const unArchiveNews = {
  id: 34,
  resource: 'posts'
};

const unArchiveResource = {
  id: 32,
  resource: 'resources'
};

describe('Get archives Saga', () => {
  it('Should return archivesList', async () => {
    api.newsFeedLinks.archived.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    api.resources.archived.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    api.initiatives.archived.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    const results = [getArchivesSuccess('abc')];

    const newsAction = { payload: archiveNews };
    const newsDispatched = await recordSaga(
      getArchives,
      newsAction
    );
    const { resource, ...newsCall } = newsAction.payload;
    expect(api.newsFeedLinks.archived).toHaveBeenCalledWith(newsCall);
    expect(newsDispatched).toEqual(results);

    const resourcesAction = { payload: archiveResources };
    const resourcesDispatched = await recordSaga(
      getArchives,
      resourcesAction
    );

    const { resourcesResource, ...resourcesCall } = newsAction.payload;
    delete resourcesCall.resource;
    expect(api.resources.archived).toHaveBeenCalledWith(resourcesCall);
    expect(resourcesDispatched).toEqual(results);

    const eventsAction = { payload: archiveEvents };
    const eventsDispatched = await recordSaga(
      getArchives,
      eventsAction
    );

    const { eventsResource, ...eventsCall } = newsAction.payload;
    delete eventsCall.resource;
    expect(api.initiatives.archived).toHaveBeenCalledWith(eventsCall);
    expect(eventsDispatched).toEqual(results);
  });

  it('Should return error from the API for archived resources possible', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.resources.archived.mockImplementation(() => Promise.reject(response));
    api.newsFeedLinks.archived.mockImplementation(() => Promise.reject(response));
    api.initiatives.archived.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load archives',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const result = [getArchivesError(response), notified];
    const newsAction = { payload: archiveNews };
    const newsDispatched = await recordSaga(
      getArchives,
      newsAction
    );
    const { resource, ...newsCall } = newsAction.payload;
    expect(api.newsFeedLinks.archived).toHaveBeenCalledWith(newsCall);
    expect(newsDispatched).toEqual(result);

    const resourcesAction = { payload: archiveResources };
    const resourcesDispatched = await recordSaga(
      getArchives,
      resourcesAction
    );

    const { resourcesResource, ...resourcesCall } = newsAction.payload;
    delete resourcesCall.resource;
    expect(api.resources.archived).toHaveBeenCalledWith(resourcesCall);
    expect(resourcesDispatched).toEqual(result);

    const eventsAction = { payload: archiveEvents };
    const eventsDispatched = await recordSaga(
      getArchives,
      eventsAction
    );

    const { eventsResource, ...eventsCall } = newsAction.payload;
    delete eventsCall.resource;
    expect(api.initiatives.archived).toHaveBeenCalledWith(eventsCall);
    expect(eventsDispatched).toEqual(result);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.load, options: { variant: 'warning' } });
  });
});


describe('UnArchive Saga', () => {
  it('Should unArchive an item', async () => {
    api.newsFeedLinks.un_archive.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    api.resources.un_archive.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    api.initiatives.un_archive.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    const results = [restoreArchiveSuccess()];

    const newsAction = { payload: unArchiveNews };
    const newsDispatched = await recordSaga(
      unArchive,
      newsAction
    );

    expect(api.newsFeedLinks.un_archive).toHaveBeenCalledWith(newsAction.payload.id, { resource: newsAction.payload });
    expect(newsDispatched).toEqual(results);

    const resourcesAction = { payload: unArchiveResource };
    const resourcesDispatched = await recordSaga(
      unArchive,
      resourcesAction
    );

    expect(api.resources.un_archive).toHaveBeenCalledWith(resourcesAction.payload.id, { resource: resourcesAction.payload });
    expect(resourcesDispatched).toEqual(results);

    const eventsAction = { payload: unArchiveEvents };
    const eventsDispatched = await recordSaga(
      unArchive,
      eventsAction
    );

    expect(api.initiatives.un_archive).toHaveBeenCalledWith(eventsAction.payload.id, { resource: eventsAction.payload });
    expect(eventsDispatched).toEqual(results);
  });

  it('Should return error from the API for all resources possible', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.resources.un_archive.mockImplementation(() => Promise.reject(response));
    api.newsFeedLinks.un_archive.mockImplementation(() => Promise.reject(response));
    api.initiatives.un_archive.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to restore an archive',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const result = [restoreArchiveError(response), notified];
    const newsAction = { payload: unArchiveNews };
    const newsDispatched = await recordSaga(
      unArchive,
      newsAction
    );

    expect(api.newsFeedLinks.un_archive).toHaveBeenCalledWith(newsAction.payload.id, { resource: newsAction.payload });
    expect(newsDispatched).toEqual(result);

    const resourcesAction = { payload: unArchiveResource };
    const resourcesDispatched = await recordSaga(
      unArchive,
      resourcesAction
    );

    expect(api.resources.un_archive).toHaveBeenCalledWith(resourcesAction.payload.id, { resource: resourcesAction.payload });
    expect(resourcesDispatched).toEqual(result);

    const eventsAction = { payload: unArchiveEvents };
    const eventsDispatched = await recordSaga(
      unArchive,
      eventsAction
    );

    expect(api.initiatives.un_archive).toHaveBeenCalledWith(eventsAction.payload.id, { resource: eventsAction.payload });
    expect(eventsDispatched).toEqual(result);
    expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.restore, options: { variant: 'warning' } });
  });
});
