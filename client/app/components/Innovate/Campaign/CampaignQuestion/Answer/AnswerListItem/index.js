import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import CommentListItem from 'components/Innovate/Campaign/CampaignQuestion/Answer/Comment/CommentListItem';

export function AnswerListItem(props) {
  return (
    props.currentAnswer && (
      <React.Fragment>
        <h3>
          {`${props.currentAnswer.author.first_name} ${props.currentAnswer.author.last_name} `}
          answered:
          {' '}
          {props.currentAnswer.content}
        </h3>
        {props.currentAnswer.comments.map((comment, i) => (
          <CommentListItem
            currentComment={comment}
            key={comment.id}
          />
        ))}
      </React.Fragment>
    )
  );
}

AnswerListItem.propTypes = {
  currentAnswer: PropTypes.object,
  getQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.func,
  question: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaignId: PropTypes.array,
  questionId: PropTypes.array,

};

export default compose(
  memo,
)(AnswerListItem);
