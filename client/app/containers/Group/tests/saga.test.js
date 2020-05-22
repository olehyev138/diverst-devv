/**
 * Test sagas
 */

import {
  getGroups,
  getGroup,
  getAnnualBudgets,
  createGroup,
  categorizeGroup,
  updateGroup,
  updateGroupSettings,
  deleteGroup,
  carryBudget,
  resetBudget,
  joinGroup,
  leaveGroup,
  joinSubgroups
} from 'containers/Group/saga';

import {
  getGroupsError,
  getGroupsSuccess,
  getGroupError,
  getGroupSuccess,
  getAnnualBudgetsSuccess,
  getAnnualBudgetsError,
  createGroupSuccess,
  createGroupError,
  groupCategorizeSuccess,
  groupCategorizeError,
  updateGroupSuccess,
  updateGroupError,
  updateGroupSettingsSuccess,
  updateGroupSettingsError,
  deleteGroupSuccess,
  deleteGroupError,
  carryBudgetSuccess,
  carryBudgetError,
  resetBudgetSuccess,
  resetBudgetError,
  joinGroupSuccess,
  joinGroupError,
  leaveGroupSuccess,
  leaveGroupError,
  joinSubgroupsSuccess,
  joinSubgroupsError,
} from 'containers/Group/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';
import AuthService from 'utils/authService';

api.groups.all = jest.fn();
api.groups.create = jest.fn();
api.groups.update = jest.fn();
api.groups.destroy = jest.fn();
api.groups.get = jest.fn();
api.groups.annualBudgets = jest.fn();
api.groups.updateCategories = jest.fn();
api.groups.carryOverBudget = jest.fn();
api.groups.resetBudget = jest.fn();
api.userGroups.join = jest.fn();
api.userGroups.leave = jest.fn();
api.userGroups.joinSubgroups = jest.fn();

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

describe('Create group', () => {
  it('Should create a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.create.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to create group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [createGroupError(response), push(ROUTES.admin.manage.groups.index.path()), notified];
    const initialAction = { payload: { group: undefined } };
    const dispatched = await recordSaga(
      createGroup,
      initialAction.payload
    );
    expect(api.groups.create).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

// TODO
describe('Categorize group', () => {
  it('Should categorize a group', async () => {

  });

  xit('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.updateCategories.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to categorize group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [groupCategorizeError(response), notified];
    const initialAction = { payload: { group: 1 } };
    const dispatched = await recordSaga(
      categorizeGroup,
      initialAction.payload
    );
    expect(api.groups.updateCategories).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

describe('Update group', () => {
  it('Should update a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateGroupError(response), notified];
    const initialAction = { payload: { id: 5, name: 'dragon' } };
    const dispatched = await recordSaga(
      updateGroup,
      initialAction
    );

    expect(api.groups.update).toHaveBeenCalledWith(initialAction.payload.id, { group: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});

describe('Update group settings', () => {
  it('Should update some group settings', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.update.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to update group settings',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [updateGroupSettingsError(response), notified];
    const initialAction = { payload: { id: 5, name: 'dragon' } };
    const dispatched = await recordSaga(
      updateGroupSettings,
      initialAction
    );

    expect(api.groups.update).toHaveBeenCalledWith(initialAction.payload.id, { group: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});

describe('Delete group', () => {
  it('Should delete a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.destroy.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to delete group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [deleteGroupError(response), notified];
    const initialAction = { payload: { group: undefined } };
    const dispatched = await recordSaga(
      deleteGroup,
      initialAction
    );
    expect(api.groups.destroy).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});

// TODO
describe('Carry budget', () => {
  it('Should carry a group budget', async () => {

  });

  xit('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.carryOverBudget.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Error message',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [carryBudgetError(response), notified];
    const initialAction = { payload: 16 };
    const dispatched = await recordSaga(
      carryBudget,
      initialAction
    );
    expect(api.groups.carryOverBudget).toHaveBeenCalledWith(initialAction);
    expect(dispatched).toEqual(results);
  });
});

describe('reset budget', () => {
  it('Should reset a group budget', async () => {

  });

  xit('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.resetBudget.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Error message',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [resetBudgetError(response), notified];
    const initialAction = { payload: 16 };
    const dispatched = await recordSaga(
      resetBudget,
      initialAction
    );
    expect(api.groups.resetBudget).toHaveBeenCalledWith(initialAction);
    expect(dispatched).toEqual(results);
  });
});

describe('Join group', () => {
  it('Should let a user join a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.userGroups.join.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to join group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [joinGroupError(response), notified];
    const initialAction = { payload: { group_id: 5 } };
    const dispatched = await recordSaga(
      joinGroup,
      initialAction
    );
    expect(api.userGroups.join).toHaveBeenCalledWith({ user_group: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});

describe('Leave group', () => {
  it('Should let a user leave a group', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.userGroups.leave.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to leave group',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [leaveGroupError(response), notified];
    const initialAction = { payload: { group_id: 5 } };
    const dispatched = await recordSaga(
      leaveGroup,
      initialAction
    );
    expect(api.userGroups.leave).toHaveBeenCalledWith({ user_group: initialAction.payload });
    expect(dispatched).toEqual(results);
  });
});

describe('Join subgroups', () => {
  it('Should let a user join some subgroups', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.userGroups.joinSubgroups.mockImplementation(() => Promise.reject(response));
    const notified = {
      notification: {
        key: 1590092641484,
        message: 'Failed to join subgroups',
        options: { variant: 'warning' }
      },
      type: 'app/Notifier/ENQUEUE_SNACKBAR'
    };

    jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
    const results = [joinSubgroupsError(response), notified];
    const initialAction = { payload: { group_id: 99, subgroups: [] } };
    const dispatched = await recordSaga(
      joinSubgroups,
      initialAction
    );
    expect(api.userGroups.joinSubgroups).toHaveBeenCalledWith(initialAction.payload);
    expect(dispatched).toEqual(results);
  });
});
