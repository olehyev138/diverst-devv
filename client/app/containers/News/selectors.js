import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/News/reducer';

const selectNewsDomain = state => state.news || initialState;

const selectPaginatedNews = () => createSelector(
  selectNewsDomain,
  newsState => newsState.newsList
);

export {
  selectPaginatedNews
};
