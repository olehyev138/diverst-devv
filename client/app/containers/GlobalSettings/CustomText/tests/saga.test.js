/**
 * Test sagas
 */

import { updateCustomText } from '../saga';

import {
  updateCustomTextSuccess,
  updateCustomTextError,
} from 'containers/GlobalSettings/CustomText/actions';

import recordSaga from 'utils/recordSaga';
import * as Notifiers from 'containers/Shared/Notifier/actions';
import api from 'api/api';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from '../messages';

import * as Selectors from 'containers/Shared/App/selectors';

api.customText.update = jest.fn();


beforeEach(() => {
  jest.resetAllMocks();
});

describe('CustomText saga', () => {
  describe('Get groups Saga', () => {
    // TODO : Testing : Selector call in saga
    xit('Should return grouplist', async () => {
      api.customText.update.mockImplementation(() => Promise.resolve({ data: { page: { undefined } } }));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      jest.spyOn(Selectors, 'selectEnterprise').mockImplementation(() => {});
      const results = [updateCustomTextSuccess(), notified];

      const initialAction = { payload: {
        id: 1,
        erg: 'Groupq1',
        program: 'Goal',
      } };

      const dispatched = await recordSaga(
        updateCustomText,
        initialAction
      );
      expect(api.customText.update).toHaveBeenCalledWith(initialAction.payload.id, { custom_text: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith(messages.snackbars.success.update);
    });

    it('Should return error from the API', async () => {
      const response = { response: { data: 'ERROR!' } };
      api.customText.update.mockImplementation(() => Promise.reject(response));

      const notified = {
        notification: {
          key: 1590092641484,
          message: 'Failed to load groups',
          options: { variant: 'warning' }
        },
        type: 'app/Notifier/ENQUEUE_SNACKBAR'
      };
      jest.spyOn(Notifiers, 'showSnackbar').mockReturnValue(notified);
      const results = [updateCustomTextError(response), notified];

      const initialAction = { payload: {
        id: 1,
        erg: 'Groupq1',
        program: 'Goal',
      } };

      const dispatched = await recordSaga(
        updateCustomText,
        initialAction
      );

      expect(api.customText.update).toHaveBeenCalledWith(initialAction.payload.id, { custom_text: initialAction.payload });
      expect(dispatched).toEqual(results);
      expect(Notifiers.showSnackbar).toHaveBeenCalledWith(messages.snackbars.errors.update);
    });
  });
});
