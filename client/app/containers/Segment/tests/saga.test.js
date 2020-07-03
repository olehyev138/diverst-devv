/**
 * Test sagas
 */

import {
  getSegments,
  getSegment,
  createSegment,
  updateSegment,
  deleteSegment,
  getSegmentMembers
} from 'containers/Segment/saga';

import {
  getSegmentsBegin, getSegmentsSuccess, getSegmentsError,
  getSegmentBegin, getSegmentSuccess, getSegmentError,
  createSegmentBegin, createSegmentSuccess, createSegmentError,
  updateSegmentBegin, updateSegmentSuccess, updateSegmentError,
  getSegmentMembersBegin, getSegmentMembersSuccess, getSegmentMembersError,
  deleteSegmentBegin, deleteSegmentError, deleteSegmentSuccess,
  segmentUnmount
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.segments.all = jest.fn();
api.segments.create = jest.fn();
api.segments.update = jest.fn();
api.segments.destroy = jest.fn();
api.segments.get = jest.fn();

api.userSegments.all = jest.fn();

const segment = {
  id: 1,
  name: 'abc'
};

describe('Get segments Saga', () => {
  it('Should return segmentList', async () => {
    api.segments.all.mockImplementation(() => Promise.resolve({ data: { page: { ...segment } } }));
    const results = [getSegmentsSuccess(segment)];

    const initialAction = { payload: {
      count: 5,
    } };

    const dispatched = await recordSaga(
      getSegments,
      initialAction
    );
    expect(api.segments.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.segments.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load segments',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getSegmentsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getSegments,
      initialAction
    );

    expect(api.segments.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Get segment Saga', () => {
  it('Should return a group', async () => {
    api.segments.get.mockImplementation(() => Promise.resolve({ data: { ...segment } }));
    const results = [getSegmentSuccess(segment)];
    const initialAction = { payload: { id: segment.id } };

    const dispatched = await recordSaga(
      getSegment,
      initialAction
    );
    expect(api.segments.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.segments.get.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get segment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getSegmentError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      getSegment,
      initialAction
    );

    expect(api.segments.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});


describe('Create segment', () => {
  it('Should create a segment', async () => {
    api.segments.create.mockImplementation(() => Promise.resolve({ data: { segment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'segment created',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createSegmentSuccess(), push(ROUTES.admin.manage.segments.index.path()), notified];
    const initialAction = { payload: {
      id: '',
    } };

    const dispatched = await recordSaga(
      createSegment,
      initialAction
    );
    expect(api.segments.create).toHaveBeenCalledWith({ segment: initialAction.payload });
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.segments.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create segment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createSegmentError(response), notified];
    const initialAction = { payload: { segment: undefined } };
    const dispatched = await recordSaga(
      createSegment,
      initialAction.payload
    );
    expect(api.segments.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should update a segment', async () => {
    api.segments.update.mockImplementation(() => Promise.resolve({ data: { segment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'segment updated',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [updateSegmentSuccess(), notified];
    const initialAction = { payload: {
      id: 1,
    } };
    const dispatched = await recordSaga(
      updateSegment,
      initialAction
    );
    expect(api.segments.update).toHaveBeenCalledWith(initialAction.payload.id, { segment: initialAction.payload });
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.segments.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateSegmentError(response), notified];
    const initialAction = { payload: { id: 5, name: 'dragon' } };
    const dispatched = await recordSaga(
      updateSegment,
      initialAction
    );

    expect(api.segments.update).toHaveBeenCalledWith(initialAction.payload.id, { segment: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});


describe('Delete segment', () => {
  it('Should delete a segment', async () => {
    api.segments.destroy.mockImplementation(() => Promise.resolve({ data: { segment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'segment deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [deleteSegmentSuccess(), push(ROUTES.admin.manage.segments.index.path()), notified];

    const initialAction = { payload: {
      id: 1,
    } };

    const dispatched = await recordSaga(
      deleteSegment,
      initialAction
    );
    expect(api.segments.destroy).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.segments.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete segment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteSegmentError(response), notified];
    const initialAction = { payload: { segment: undefined } };
    const dispatched = await recordSaga(
      deleteSegment,
      initialAction
    );
    expect(api.segments.destroy).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});


describe('get members for a segment', () => {
  it('Should get the members for the segment', async () => {
    api.userSegments.all.mockImplementation(() => Promise.resolve({ data: { segment } }));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'segment deleted',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };
    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

    const results = [getSegmentMembersSuccess()];

    const initialAction = { payload: {
      id: 1,
    } };

    const dispatched = await recordSaga(
      getSegmentMembers,
      initialAction
    );
    expect(api.userSegments.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.userSegments.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete segment',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getSegmentMembersError(response), notified];
    const initialAction = { payload: { segment: undefined } };
    const dispatched = await recordSaga(
      getSegmentMembers,
      initialAction
    );
    expect(api.userSegments.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});
