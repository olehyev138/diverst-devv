/**
 * Test sagas
 */

import {
  getGroups,
  getGroup,
  getAnnualBudgets,
  createGroup
} from 'containers/Group/saga';

import {
  getGroupsError,
  getGroupsSuccess,
  getGroupError,
  getGroupSuccess,
  getAnnualBudgetsSuccess,
  getAnnualBudgetsError,
  createGroupSuccess,
  createGroupError
} from 'containers/Group/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';
import AuthService from 'utils/authService';

api.groups.all = jest.fn();
api.groups.create = jest.fn();
api.groups.get = jest.fn();
api.groups.annualBudgets = jest.fn();


beforeEach(() => {
  jest.resetAllMocks();
});

describe('Get groups Saga', () => {
  it('Should return grouplist', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.all.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to load groups',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getGroupsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getGroups,
      initialAction
    );

    expect(api.groups.all).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Get group Saga', () => {
  it('Should return a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.get.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getGroupError(response), notified];
    const initialAction = { payload: { id: 5 } };
    const dispatched = await recordSaga(
      getGroup,
      initialAction
    );

    expect(api.groups.get).toHaveBeenCalledWith(initialAction.payload.id);
    expect(dispatched).toEqual(results);
  });
});

describe('Get annual group budget', () => {
  it('Should return a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.annualBudgets.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to get annual budgets',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [getAnnualBudgetsError(response), notified];
    const initialAction = { payload: undefined };
    const dispatched = await recordSaga(
      getAnnualBudgets,
      initialAction
    );

    expect(api.groups.annualBudgets).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});
