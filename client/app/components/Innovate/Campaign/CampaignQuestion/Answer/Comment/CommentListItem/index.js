import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';


export function CommentListItem(props) {
  return (
    props.currentComment && (
      <React.Fragment>
        <h3>
          {`${props.currentComment.author.first_name} ${props.currentComment.author.last_name}`}
          commented:
          {props.currentComment.content}
        </h3>
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
