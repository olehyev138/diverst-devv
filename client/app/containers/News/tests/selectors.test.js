import {
  selectNewsDomain, selectPaginatedNewsItems,
  selectNewsItemsTotal
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
});
