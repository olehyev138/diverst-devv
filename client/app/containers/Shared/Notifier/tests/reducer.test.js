import produce from 'immer/dist/immer';

import notifierReducer from 'containers/Shared/Notifier/reducer';
import { showSnackbar, closeSnackbar, removeSnackbar } from 'containers/Shared/Notifier/actions';

describe('notifierReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      notifications: []
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(notifierReducer(undefined, {})).toEqual(expected);
  });

  it('should handle the showSnackbar action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.notifications.push({
        options: { key: 123005 },
        key: 123005
      });
    });

    expect(notifierReducer(state, showSnackbar({
      options: { key: 123005 }
    }))).toEqual(expected);
  });

  // TODO: closeSnackbar & removeSnackbar
  // it('should handle the closeSnackbar action correctly', () => {
});
