/**
 * Test sagas
 */

import {
  getLogs, exportLogs
} from '../saga';

import {
  getLogsError, getLogsSuccess,
  exportLogsError, exportLogsSuccess
} from '../actions';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.activities.all = jest.fn();
api.activities.csvExport = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

describe('Get logs Saga', () => {
  it('Should return logs', async () => {
    api.activities.all.mockImplementation(() => Promise.resolve({ data: { page: 'abc' } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load archives',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    const results = [getLogsSuccess('abc')];

    const action = { payload: {} };
    const dispatched = await recordSaga(
      getLogs,
      action
    );
    expect(api.activities.all).toHaveBeenCalledWith(action.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API for all resources possible', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.activities.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load archives',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const result = [getLogsError(response), notified];
    const action = { payload: {} };
    const dispatched = await recordSaga(
      getLogs,
      action
    );
    expect(api.activities.all).toHaveBeenCalledWith(action.payload);
    expect(dispatched).toEqual(result);
  });
});

// TODO Fix export sagas
describe('export Saga', () => {
  xit('Should export an item', async () => {
    api.activities.csvExport.mockImplementation(() => Promise.resolve({ data: { page: undefined } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to restore an archive',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [exportLogsSuccess(), notified];

    const action = { payload: undefined };
    const dispatched = await recordSaga(
      exportLogs,
      action
    );

    expect(api.activities.csvExport).toHaveBeenCalledWith(action.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API for all resources possible', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.activities.csvExport.mockImplementation(() => Promise.reject(response));

    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to restore an archive',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const result = [exportLogsError(response), notified];
    const action = { payload: {} };
    const newsDispatched = await recordSaga(
      exportLogs,
      action
    );

    expect(api.activities.csvExport).toHaveBeenCalledWith(action.payload);
    expect(newsDispatched).toEqual(result);
  });
});
