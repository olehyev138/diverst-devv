import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';


const selectCommentsDomain = state => state.comments || initialState;

const selectComment = () => createSelector(
  selectCommentsDomain,
  commentsState => commentsState.currentComment
);

const selectPaginatedComments = () => createSelector(
  selectCommentsDomain,
  commentsState => commentsState.commentList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectComments = () => createSelector(
  selectCommentsDomain,
  commentsState => (
    Object
      .values(commentsState.commentList)
      .map(comment => ({
        value: comment.id,
        label: `${comment.comment}`
      }))
  )
);

const selectCommentTotal = () => createSelector(
  selectCommentsDomain,
  commentsState => commentsState.commentTotal
);

const selectIsFetchingComments = () => createSelector(
  selectCommentsDomain,
  commentsState => commentsState.isFetchingComments
);

const selectIsCommitting = () => createSelector(
  selectCommentsDomain,
  commentsState => commentsState.isCommitting
);

export {
  selectCommentsDomain, selectPaginatedComments, selectPaginatedSelectComments,
  selectCommentTotal, selectIsFetchingComments, selectIsCommitting, selectComment
};
