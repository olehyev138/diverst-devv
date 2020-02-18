import produce from 'immer/dist/immer';
import newsReducer from 'containers/News/reducer';
import {
  getNewsItemsSuccess, newsFeedUnmount
} from 'containers/News/actions';

/* eslint-disable default-case, no-param-reassign */
describe('newsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isCommitting: false,
      isFormLoading: true,
      newsItems: [],
      currentNewsItem: null,
      newsItemsTotal: null,
      hasChanged: false
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(newsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getNewsItemsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.newsItems = [{ id: 37 }];
      draft.newsItemsTotal = 49;
      draft.isLoading = false;
    });

    expect(
      newsReducer(
        state,
        getNewsItemsSuccess({
          items: [{ id: 37 }],
          total: 49
        })
      )
    ).toEqual(expected);
  });

  it('handles the newsFeedUnmount action correctly', () => {
    const expected = state;

    expect(newsReducer(state, newsFeedUnmount())).toEqual(expected);
  });
});
