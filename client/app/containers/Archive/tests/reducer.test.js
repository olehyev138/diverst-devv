import produce from 'immer';
import {
  getArchivesSuccess,
  restoreArchiveSuccess,
} from '../actions';
import archivesReducer from 'containers/Archive/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('archivesReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
      isLoading: true,
      archives: null,
      archivesTotal: null,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(archivesReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getArchivesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.isLoading = false;
      draft.archives = { id: 4, name: 'dummy' };
      draft.archivesTotal = 31;
    });

    expect(
      archivesReducer(
        state,
        getArchivesSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });
});
