import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/News/reducer';
import { selectResourcesDomain } from '../Resource/selectors';

const selectNewsDomain = state => state.news || initialState;

const selectPaginatedNewsItems = () => createSelector(
  selectNewsDomain,
  newsState => newsState.newsItems
);

const selectNewsItemsTotal = () => createSelector(
  selectNewsDomain,
  newsState => newsState.newsItemsTotal
);

const selectNewsItem = () => createSelector(
  selectNewsDomain,
  newsState => newsState.currentNewsItem
);

const selectIsLoading = () => createSelector(
  selectNewsDomain,
  newsState => newsState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectNewsDomain,
  newsState => newsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectNewsDomain,
  newsState => newsState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectNewsDomain,
  newsState => newsState.hasChanged
);

export {
  selectNewsDomain, selectPaginatedNewsItems, selectIsFormLoading,
  selectNewsItem, selectNewsItemsTotal, selectIsLoading, selectIsCommitting, selectHasChanged
};
