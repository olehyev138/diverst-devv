import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/News/reducer';

const selectNewsDomain = state => state.news || initialState;

const selectPaginatedNewsItems = () => createSelector(
  selectNewsDomain,
  newsState => newsState.newsItems
);

const selectNewsItemsTotal = () => createSelector(
  selectNewsDomain,
  newsState => newsState.newsItemsTotal
);

export {
  selectNewsDomain, selectPaginatedNewsItems,
  selectNewsItemsTotal
};
