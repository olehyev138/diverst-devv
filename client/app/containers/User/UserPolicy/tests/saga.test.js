/**
 * Test sagas
 */

import {
  getPolicies,
  getPolicy,
  createPolicy,
  updatePolicy,
  deletePolicy
} from 'containers/User/UserPolicy/saga';

import {
  getPolicyError,
  getPolicySuccess,
  getPoliciesError,
  getPoliciesSuccess,
  createPolicyError,
  createPolicySuccess,
  updatePolicyError,
  updatePolicySuccess,
  deletePolicyError,
  deletePolicySuccess,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

api.policyTemplates.all = jest.fn();
api.policyTemplates.create = jest.fn();
api.policyTemplates.update = jest.fn();
api.policyTemplates.destroy = jest.fn();
api.policyTemplates.get = jest.fn();

// eslint-disable-next-line camelcase
const policy = {
  id: 1,
  role_name: 'abc'
};

describe('tests for policy saga', () => {
  describe('Get policies Saga', () => {
    it('Should return policyList', async () => {
      // eslint-disable-next-line camelcase
      api.policyTemplates.all.mockImplementation(() => Promise.resolve({ data: { page: { ...policy } } }));
      const results = [getPoliciesSuccess(policy)];

      const initialAction = { payload: {
        count: 5,
      } };

      const dispatched = await recordSaga(
        getPolicies,
        initialAction
      );
      expect(api.policyTemplates.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.policyTemplates.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load policies',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getPoliciesError(response), notified];
      const initialAction = { payload: undefined };
      const dispatched = await recordSaga(
        getPolicies,
        initialAction
      );

      expect(api.policyTemplates.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('Get policy Saga', () => {
    it('Should return a group', async () => {
      // eslint-disable-next-line camelcase
      api.policyTemplates.get.mockImplementation(() => Promise.resolve({ data: { ...policy } }));
      const results = [getPolicySuccess(policy)];
      const initialAction = { payload: { id: policy.id } };

      const dispatched = await recordSaga(
        getPolicy,
        initialAction
      );
      expect(api.policyTemplates.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.policyTemplates.get.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to get policy',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getPolicyError(response), notified];
      const initialAction = { payload: { id: 5 } };
      const dispatched = await recordSaga(
        getPolicy,
        initialAction
      );

      expect(api.policyTemplates.get).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });


  describe('Create policy', () => {
    it('Should create a policy', async () => {
      api.policyTemplates.create.mockImplementation(() => Promise.resolve({ data: { policy } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'policy created',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createPolicySuccess(), notified];
      const initialAction = { payload: {
        id: '',
      } };

      const dispatched = await recordSaga(
        createPolicy,
        initialAction
      );
      expect(api.policyTemplates.create).toHaveBeenCalledWith({ policy_group_template: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.policyTemplates.create.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to create policy',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [createPolicyError(response), notified];
      const initialAction = { payload: { policy: undefined } };
      const dispatched = await recordSaga(
        createPolicy,
        initialAction.payload
      );
      expect(api.policyTemplates.create).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
    });
  });

  describe('update policy', () => {
    it('Should update a policy', async () => {
      api.policyTemplates.update.mockImplementation(() => Promise.resolve({ data: { policy } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'policy updated',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [updatePolicySuccess(), notified, push(ROUTES.admin.system.users.policy_templates.index.path())];
      const initialAction = { payload: {
        id: 1,
      } };
      const dispatched = await recordSaga(
        updatePolicy,
        initialAction
      );
      expect(api.policyTemplates.update).toHaveBeenCalledWith(initialAction.payload.id, { policy_group_template: initialAction.payload });
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.policyTemplates.update.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to update group',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updatePolicyError(response), notified];
      const initialAction = { payload: { id: 5, name: 'dragon' } };
      const dispatched = await recordSaga(
        updatePolicy,
        initialAction
      );

      expect(api.policyTemplates.update).toHaveBeenCalledWith(initialAction.payload.id, { policy_group_template: initialAction.payload });
      expect(dispatched).toEqual(results);
    });
  });


  describe('Delete policy', () => {
    it('Should delete a policy', async () => {
      api.policyTemplates.destroy.mockImplementation(() => Promise.resolve({ data: { policy } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'policy deleted',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);

      const results = [deletePolicySuccess(), notified];

      const initialAction = { payload: {
        id: 1,
      } };

      const dispatched = await recordSaga(
        deletePolicy,
        initialAction
      );
      expect(api.policyTemplates.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.policyTemplates.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to delete policy',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deletePolicyError(response), notified];
      const initialAction = { payload: { policy: undefined } };
      const dispatched = await recordSaga(
        deletePolicy,
        initialAction
      );
      expect(api.policyTemplates.destroy).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
    });
  });
});
