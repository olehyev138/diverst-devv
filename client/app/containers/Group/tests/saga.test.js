/**
 * Test sagas
 */

import {
  getGroups,
} from 'containers/Group/saga';

import {
  getGroupsError,
} from 'containers/Group/actions';

import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';
import AuthService from 'utils/authService';

api.groups.all = jest.fn();

describe('Get groups Saga', () => {
  it('Should return grouplist', async () => {

  });

  it('Should return error from the API', async () => {
    const response = { response: { data: 'ERROR!' } };
    api.groups.all.mockImplementation(() => Promise.reject(response));
    const results = [getGroupsError(response)];
    const dispatched = await recordSaga(
      getGroups,
    );

    expect(api.user.all).toHaveBeenCalled();
    expect(dispatched).toEqual(results);
  });
});
