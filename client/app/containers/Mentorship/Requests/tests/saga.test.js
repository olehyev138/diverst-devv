import {
  getRequests,
  getProposals,
  acceptRequest,
  rejectRequest,
  deleteRequest
} from '../saga';

import {
  getRequestsSuccess, getRequestsError,
  getProposalsSuccess, getProposalsError,
  acceptRequestSuccess, acceptRequestError,
  rejectRequestSuccess, rejectRequestError,
  deleteRequestSuccess, deleteRequestError,
} from '../actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import messages from '../messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

api.mentoringRequests.all = jest.fn();
api.mentoringRequests.acceptRequest = jest.fn();
api.mentoringRequests.rejectRequest = jest.fn();
api.mentoringRequests.destroy = jest.fn();

beforeEach(() => {
  jest.resetAllMocks();
});

const request = {
  id: 5,
};

describe('Request Saga', () => {
  describe('getRequests', () => {
    it('Should return request', async () => {
      api.mentoringRequests.all.mockImplementation(() => Promise.resolve({ data: { page: { ...request } } }));
      const results = [getRequestsSuccess(request)];

      const initialAction = { payload: {
        ...request
      } };

      const dispatched = await recordSaga(
        getRequests,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringRequests.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getRequestsError(response), notified];
      const initialAction = { payload: { ...request } };
      const dispatched = await recordSaga(
        getRequests,
        initialAction
      );

      expect(api.mentoringRequests.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.request, options: { variant: 'warning' } });
    });
  });

  describe('getProposals', () => {
    it('Should return request', async () => {
      api.mentoringRequests.all.mockImplementation(() => Promise.resolve({ data: { page: { ...request } } }));
      const results = [getProposalsSuccess(request)];

      const initialAction = { payload: {
        ...request
      } };

      const dispatched = await recordSaga(
        getProposals,
        initialAction
      );
      expect(dispatched).toEqual(results);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringRequests.all.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [getProposalsError(response), notified];
      const initialAction = { payload: { ...request } };
      const dispatched = await recordSaga(
        getProposals,
        initialAction
      );

      expect(api.mentoringRequests.all).toHaveBeenCalledWith(initialAction.payload);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.proposal, options: { variant: 'warning' } });
    });
  });

  describe('acceptRequest', () => {
    it('Should accept request', async () => {
      api.mentoringRequests.acceptRequest.mockImplementation(() => Promise.resolve({ data: { ...request } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [acceptRequestSuccess(), notified];

      const initialAction = { payload: {
        ...request
      } };

      const dispatched = await recordSaga(
        acceptRequest,
        initialAction
      );
      expect(api.mentoringRequests.acceptRequest).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.accept, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringRequests.acceptRequest.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [acceptRequestError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        acceptRequest,
        initialAction
      );

      expect(api.mentoringRequests.acceptRequest).toHaveBeenCalledWith(initialAction.payload.id);
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.accept, options: { variant: 'warning' } });
    });
  });

  describe('rejectRequest', () => {
    it('Should reject request', async () => {
      api.mentoringRequests.rejectRequest.mockImplementation(() => Promise.resolve({ data: { ...request } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [rejectRequestSuccess(), notified];
      const initialAction = { payload: {
        ...request
      } };

      const dispatched = await recordSaga(
        rejectRequest,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.reject, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringRequests.rejectRequest.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [rejectRequestError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        rejectRequest,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.reject, options: { variant: 'warning' } });
    });
  });

  describe('deleteRequest', () => {
    it('Should deleteRequest', async () => {
      api.mentoringRequests.destroy.mockImplementation(() => Promise.resolve({ data: { ...request } }));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteRequestSuccess(), notified];
      const initialAction = { payload: {
        ...request
      } };

      const dispatched = await recordSaga(
        deleteRequest,
        initialAction
      );
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.success.delete, options: { variant: 'success' } });
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.mentoringRequests.destroy.mockImplementation(() => Promise.reject(response));
      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load events',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };

      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [deleteRequestError(response), notified];
      const initialAction = { payload: { id: 2 } };
      const dispatched = await recordSaga(
        deleteRequest,
        initialAction
      );

      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } });
    });
  });
});
