import {
  selectNewsDomain, selectPaginatedNewsItems,
  selectNewsItemsTotal, selectNewsItem,
  selectIsLoading, selectIsFormLoading, selectIsCommitting, selectHasChanged
} from 'containers/News/selectors';

describe('News selectors', () => {
  describe('selectNewsDomain', () => {
    it('should select the news domain', () => {
      const mockedState = { news: { newsItems: {} } };
      const selected = selectNewsDomain(mockedState);

      expect(selected).toEqual({ newsItems: {} });
    });
  });

  describe('selectPaginatedNewsItems', () => {
    it('should select the paginated news items', () => {
      const mockedState = { newsItems: [{ id: 59 }] };
      const selected = selectPaginatedNewsItems().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 59 }]);
    });
  });

  describe('selectNewsItemsTotal', () => {
    it('should select the group total', () => {
      const mockedState = { newsItemsTotal: 59 };
      const selected = selectNewsItemsTotal().resultFunc(mockedState);

      expect(selected).toEqual(59);
    });
  });

  describe('selectNewsItem', () => {
    it('should select a news item', () => {
      const mockedState = { currentNewsItem: { id: 59 } };
      const selected = selectNewsItem().resultFunc(mockedState);

      expect(selected).toEqual({ id: 59 });
    });
  });

  describe('selectIsLoading', () => {
    it('should select is loading', () => {
      const mockedState = { isLoading: { id: 422, __dummy: '422' } };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual({ id: 422, __dummy: '422' });
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select is form loading', () => {
      const mockedState = { isFormLoading: { id: 60, __dummy: '60' } };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual({ id: 60, __dummy: '60' });
    });
  });

  describe('selectIsCommitting', () => {
    it('should select is committing', () => {
      const mockedState = { isCommitting: { id: 893, __dummy: '893' } };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual({ id: 893, __dummy: '893' });
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
