import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

export function QuestionSummary(props) {
  return (
    props.question && (
      <React.Fragment>
        <h2>
          Question:
          {props.question.title}
        </h2>
        <br />
        <h4>
          {props.question.description}
        </h4>
      </React.Fragment>
    )
  );
}

QuestionSummary.propTypes = {
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
)(QuestionSummary);
