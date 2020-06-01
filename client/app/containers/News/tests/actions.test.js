import {
  GET_NEWS_ITEMS_BEGIN, GET_NEWS_ITEMS_SUCCESS, GET_NEWS_ITEMS_ERROR,
  GET_NEWS_ITEM_BEGIN, GET_NEWS_ITEM_SUCCESS, GET_NEWS_ITEM_ERROR,
  CREATE_GROUP_MESSAGE_BEGIN, CREATE_GROUP_MESSAGE_SUCCESS, CREATE_GROUP_MESSAGE_ERROR,
  UPDATE_GROUP_MESSAGE_BEGIN, UPDATE_GROUP_MESSAGE_SUCCESS, UPDATE_GROUP_MESSAGE_ERROR,
  DELETE_GROUP_MESSAGE_BEGIN, DELETE_GROUP_MESSAGE_SUCCESS, DELETE_GROUP_MESSAGE_ERROR,
  NEWS_FEED_UNMOUNT,
  UPDATE_NEWS_ITEM_BEGIN, UPDATE_NEWS_ITEM_SUCCESS, UPDATE_NEWS_ITEM_ERROR,
  CREATE_GROUP_MESSAGE_COMMENT_BEGIN, CREATE_GROUP_MESSAGE_COMMENT_SUCCESS, CREATE_GROUP_MESSAGE_COMMENT_ERROR,
  DELETE_GROUP_MESSAGE_COMMENT_BEGIN, DELETE_GROUP_MESSAGE_COMMENT_SUCCESS, DELETE_GROUP_MESSAGE_COMMENT_ERROR,
  CREATE_NEWSLINK_BEGIN, CREATE_NEWSLINK_SUCCESS, CREATE_NEWSLINK_ERROR,
  UPDATE_NEWSLINK_BEGIN, UPDATE_NEWSLINK_SUCCESS, UPDATE_NEWSLINK_ERROR,
  DELETE_NEWSLINK_BEGIN, DELETE_NEWSLINK_SUCCESS, DELETE_NEWSLINK_ERROR,
  CREATE_NEWSLINK_COMMENT_BEGIN, CREATE_NEWSLINK_COMMENT_SUCCESS, CREATE_NEWSLINK_COMMENT_ERROR,
  DELETE_NEWSLINK_COMMENT_BEGIN, DELETE_NEWSLINK_COMMENT_SUCCESS, DELETE_NEWSLINK_COMMENT_ERROR,
} from 'containers/News/constants';

import {
  getNewsItemsBegin, getNewsItemsSuccess, getNewsItemsError,
  getNewsItemBegin, getNewsItemSuccess, getNewsItemError,
  createGroupMessageBegin, createGroupMessageSuccess, createGroupMessageError,
  updateGroupMessageBegin, updateGroupMessageSuccess, updateGroupMessageError,
  deleteGroupMessageBegin, deleteGroupMessageSuccess, deleteGroupMessageError,
  newsFeedUnmount,
  updateNewsItemBegin, updateNewsItemSuccess, updateNewsItemError,
  createGroupMessageCommentBegin, createGroupMessageCommentSuccess, createGroupMessageCommentError,
  deleteGroupMessageCommentBegin, deleteGroupMessageCommentSuccess, deleteGroupMessageCommentError,
  createNewsLinkBegin, createNewsLinkSuccess, createNewsLinkError,
  updateNewsLinkBegin, updateNewsLinkSuccess, updateNewsLinkError,
  deleteNewsLinkBegin, deleteNewsLinkSuccess, deleteNewsLinkError,
  createNewsLinkCommentBegin, createNewsLinkCommentSuccess, createNewsLinkCommentError,
  deleteNewsLinkCommentBegin, deleteNewsLinkCommentSuccess, deleteNewsLinkCommentError,
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
  describe('News Item actions', () => {
    describe('getNewsItemBegin', () => {
      it('has a type of getNewsItemBegin and takes a given payload', () => {
        const expected = {
          type: GET_NEWS_ITEM_BEGIN,
          payload: { items: {} }
        };

        expect(getNewsItemBegin({ items: {} })).toEqual(expected);
      });
    });
    describe('getNewsItemSuccess', () => {
      it('has a type of getNewsItemSuccess and takes a given payload', () => {
        const expected = {
          type: GET_NEWS_ITEM_SUCCESS,
          payload: { items: {} }
        };

        expect(getNewsItemSuccess({ items: {} })).toEqual(expected);
      });
    });
    describe('getNewsItemError', () => {
      it('has a type of getNewsItemSuccess and takes a given error', () => {
        const expected = {
          type: GET_NEWS_ITEM_ERROR,
          error: 'error'
        };

        expect(getNewsItemError('error')).toEqual(expected);
      });
    });
    describe('updateNewsItemBegin', () => {
      it('has a type of UPDATE_NEWS_ITEM_BEGIN and takes a given payload', () => {
        const expected = {
          type: UPDATE_NEWS_ITEM_BEGIN,
          payload: { item: {} }
        };

        expect(updateNewsItemBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('updateNewsItemSuccess', () => {
      it('has a type of UPDATE_NEWS_ITEM_SUCCESS and takes a given payload', () => {
        const expected = {
          type: UPDATE_NEWS_ITEM_SUCCESS,
          payload: { item: {} }
        };

        expect(updateNewsItemSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('updateNewsItemError', () => {
      it('has a type of UPDATE_NEWS_ITEM_ERROR and takes a given error', () => {
        const expected = {
          type: UPDATE_NEWS_ITEM_ERROR,
          error: 'error'
        };

        expect(updateNewsItemError('error')).toEqual(expected);
      });
    });
  });
  describe('Group Message actions', () => {
    describe('createGroupMessageBegin', () => {
      it('has a type of CREATE_GROUP_MESSAGE_BEGIN and takes a given payload', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_BEGIN,
          payload: { item: {} }
        };

        expect(createGroupMessageBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('createGroupMessageSuccess', () => {
      it('has a type of CREATE_GROUP_MESSAGE_SUCCESS and takes a given payload', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_SUCCESS,
          payload: { item: {} }
        };

        expect(createGroupMessageSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('createGroupMessageError', () => {
      it('has a type of CREATE_GROUP_MESSAGE_ERROR and takes a given error', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_ERROR,
          error: 'error'
        };

        expect(createGroupMessageError('error')).toEqual(expected);
      });
    });
    describe('updateGroupMessageBegin', () => {
      it('has a type of UPDATE_GROUP_MESSAGE_BEGIN and takes a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_MESSAGE_BEGIN,
          payload: { item: {} }
        };

        expect(updateGroupMessageBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('updateGroupMessageSuccess', () => {
      it('has a type of UPDATE_GROUP_MESSAGE_SUCCESS and takes a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_MESSAGE_SUCCESS,
          payload: { item: {} }
        };

        expect(updateGroupMessageSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('updateGroupMessageError', () => {
      it('has a type of UPDATE_GROUP_MESSAGE_ERROR and takes a given error', () => {
        const expected = {
          type: UPDATE_GROUP_MESSAGE_ERROR,
          error: 'error'
        };

        expect(updateGroupMessageError('error')).toEqual(expected);
      });
    });
    describe('deleteGroupMessageBegin', () => {
      it('has a type of DELETE_GROUP_MESSAGE_BEGIN and takes a given payload', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_BEGIN,
          payload: { item: {} }
        };

        expect(deleteGroupMessageBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteGroupMessageSuccess', () => {
      it('has a type of DELETE_GROUP_MESSAGE_SUCCESS and takes a given payload', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_SUCCESS,
          payload: { item: {} }
        };

        expect(deleteGroupMessageSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteGroupMessageError', () => {
      it('has a type of DELETE_GROUP_MESSAGE_ERROR and takes a given error', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_ERROR,
          error: 'error'
        };

        expect(deleteGroupMessageError('error')).toEqual(expected);
      });
    });
    describe('createGroupMessageCommentBegin', () => {
      it('has a type of CREATE_GROUP_MESSAGE_COMMENT_BEGIN and takes a given payload', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_COMMENT_BEGIN,
          payload: { item: {} }
        };

        expect(createGroupMessageCommentBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('createGroupMessageCommentSuccess', () => {
      it('has a type of CREATE_GROUP_MESSAGE_COMMENT_SUCCESS and takes a given payload', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_COMMENT_SUCCESS,
          payload: { item: {} }
        };

        expect(createGroupMessageCommentSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('createGroupMessageCommentError', () => {
      it('has a type of CREATE_GROUP_MESSAGE_COMMENT_ERROR and takes a given error', () => {
        const expected = {
          type: CREATE_GROUP_MESSAGE_COMMENT_ERROR,
          error: 'error'
        };

        expect(createGroupMessageCommentError('error')).toEqual(expected);
      });
    });
    describe('deleteGroupMessageCommentBegin', () => {
      it('has a type of DELETE_GROUP_MESSAGE_COMMENT_BEGIN and takes a given payload', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_COMMENT_BEGIN,
          payload: { item: {} }
        };

        expect(deleteGroupMessageCommentBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteGroupMessageCommentSuccess', () => {
      it('has a type of DELETE_GROUP_MESSAGE_COMMENT_SUCCESS and takes a given payload', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_COMMENT_SUCCESS,
          payload: { item: {} }
        };

        expect(deleteGroupMessageCommentSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteGroupMessageCommentError', () => {
      it('has a type of DELETE_GROUP_MESSAGE_COMMENT_ERROR and takes a given error', () => {
        const expected = {
          type: DELETE_GROUP_MESSAGE_COMMENT_ERROR,
          error: 'error'
        };

        expect(deleteGroupMessageCommentError('error')).toEqual(expected);
      });
    });
  });
  describe('News Link actions', () => {
    describe('createNewsLinkBegin', () => {
      it('has a type of CREATE_NEWSLINK_BEGIN and takes a given payload', () => {
        const expected = {
          type: CREATE_NEWSLINK_BEGIN,
          payload: { item: {} }
        };

        expect(createNewsLinkBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('createNewsLinkSuccess', () => {
      it('has a type of CREATE_NEWSLINK_SUCCESS and takes a given payload', () => {
        const expected = {
          type: CREATE_NEWSLINK_SUCCESS,
          payload: { item: {} }
        };

        expect(createNewsLinkSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('createNewsLinkError', () => {
      it('has a type of CREATE_NEWSLINK_ERROR and takes a given error', () => {
        const expected = {
          type: CREATE_NEWSLINK_ERROR,
          error: 'error'
        };

        expect(createNewsLinkError('error')).toEqual(expected);
      });
    });
    describe('updateNewsLinkBegin', () => {
      it('has a type of UPDATE_NEWSLINK_BEGIN and takes a given payload', () => {
        const expected = {
          type: UPDATE_NEWSLINK_BEGIN,
          payload: { item: {} }
        };

        expect(updateNewsLinkBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('updateNewsLinkSuccess', () => {
      it('has a type of UPDATE_NEWSLINK_SUCCESS and takes a given payload', () => {
        const expected = {
          type: UPDATE_NEWSLINK_SUCCESS,
          payload: { item: {} }
        };

        expect(updateNewsLinkSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('updateNewsLinkError', () => {
      it('has a type of UPDATE_NEWSLINK_ERROR and takes a given error', () => {
        const expected = {
          type: UPDATE_NEWSLINK_ERROR,
          error: 'error'
        };

        expect(updateNewsLinkError('error')).toEqual(expected);
      });
    });
    describe('deleteNewsLinkBegin', () => {
      it('has a type of DELETE_NEWSLINK_BEGIN and takes a given payload', () => {
        const expected = {
          type: DELETE_NEWSLINK_BEGIN,
          payload: { item: {} }
        };

        expect(deleteNewsLinkBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteNewsLinkSuccess', () => {
      it('has a type of DELETE_NEWSLINK_SUCCESS and takes a given payload', () => {
        const expected = {
          type: DELETE_NEWSLINK_SUCCESS,
          payload: { item: {} }
        };

        expect(deleteNewsLinkSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteNewsLinkError', () => {
      it('has a type of DELETE_NEWSLINK_ERROR and takes a given error', () => {
        const expected = {
          type: DELETE_NEWSLINK_ERROR,
          error: 'error'
        };

        expect(deleteNewsLinkError('error')).toEqual(expected);
      });
    });
    describe('createNewsLinkCommentBegin', () => {
      it('has a type of CREATE_NEWSLINK_COMMENT_BEGIN and takes a given payload', () => {
        const expected = {
          type: CREATE_NEWSLINK_COMMENT_BEGIN,
          payload: { item: {} }
        };

        expect(createNewsLinkCommentBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('createNewsLinkCommentSuccess', () => {
      it('has a type of CREATE_NEWSLINK_COMMENT_SUCCESS and takes a given payload', () => {
        const expected = {
          type: CREATE_NEWSLINK_COMMENT_SUCCESS,
          payload: { item: {} }
        };

        expect(createNewsLinkCommentSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('createNewsLinkCommentError', () => {
      it('has a type of CREATE_NEWSLINK_COMMENT_ERROR and takes a given error', () => {
        const expected = {
          type: CREATE_NEWSLINK_COMMENT_ERROR,
          error: 'error'
        };

        expect(createNewsLinkCommentError('error')).toEqual(expected);
      });
    });
    describe('deleteNewsLinkCommentBegin', () => {
      it('has a type of DELETE_NEWSLINK_COMMENT_BEGIN and takes a given payload', () => {
        const expected = {
          type: DELETE_NEWSLINK_COMMENT_BEGIN,
          payload: { item: {} }
        };

        expect(deleteNewsLinkCommentBegin({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteNewsLinkCommentSuccess', () => {
      it('has a type of DELETE_NEWSLINK_COMMENT_SUCCESS and takes a given payload', () => {
        const expected = {
          type: DELETE_NEWSLINK_COMMENT_SUCCESS,
          payload: { item: {} }
        };

        expect(deleteNewsLinkCommentSuccess({ item: {} })).toEqual(expected);
      });
    });
    describe('deleteNewsLinkCommentError', () => {
      it('has a type of DELETE_NEWSLINK_COMMENT_ERROR and takes a given error', () => {
        const expected = {
          type: DELETE_NEWSLINK_COMMENT_ERROR,
          error: 'error'
        };

        expect(deleteNewsLinkCommentError('error')).toEqual(expected);
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
