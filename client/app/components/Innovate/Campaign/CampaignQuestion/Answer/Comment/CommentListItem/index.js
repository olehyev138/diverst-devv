import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';


export function CommentListItem(props) {
  console.log(props.currentComment);
  return (
    props.currentComment && (
      <React.Fragment>
        <h3>
          Author: {' '}
          {props.currentComment.author}
        </h3>
        <h4>{props.currentAnswer.content}</h4>
      </React.Fragment>
    )
  );
}

CommentListItem.propTypes = {
  currentComment: PropTypes.object

};

export default compose(
  memo,
)(CommentListItem);
