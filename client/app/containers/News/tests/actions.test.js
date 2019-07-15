import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEMS_ERROR,
  NEWS_FEED_UNMOUNT
} from 'containers/News/constants';

import {
  getNewsItemsBegin, getNewsItemsSuccess, getNewsItemsError,
  newsFeedUnmount
} from 'containers/News/actions';

describe('News actions', () => {
  describe('News Item list actions', () => {
    describe('getNewsItemsBegin', () => {
      it('has a type of getNewsItemsBegin and takes a given payload', () => {
        const expected = {
          type: GET_NEWS_ITEMS_BEGIN,
          payload: { items: {} }
        };

        expect(getNewsItemsBegin({ items: {} })).toEqual(expected);
      });
    });
    describe('getNewsItemsSuccess', () => {
      it('has a type of getNewsItemsSuccess and takes a given payload', () => {
        const expected = {
          type: GET_NEWS_ITEMS_SUCCESS,
          payload: { items: {} }
        };

        expect(getNewsItemsSuccess({ items: {} })).toEqual(expected);
      });
    });
    describe('getNewsItemsError', () => {
      it('has a type of getNewsItemsSuccess and takes a given error', () => {
        const expected = {
          type: GET_NEWS_ITEMS_ERROR,
          error: 'error'
        };

        expect(getNewsItemsError('error')).toEqual(expected);
      });
    });
  });
  describe('News unmount actions', () => {
    describe('newsFeedUnmount', () => {
      it('has a type of getNewsItemsSuccess', () => {
        const expected = {
          type: NEWS_FEED_UNMOUNT,
        };

        expect(newsFeedUnmount()).toEqual(expected);
      });
    });
  });
});
