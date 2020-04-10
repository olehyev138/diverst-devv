import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Grid, Card, CardContent } from '@material-ui/core';

export function QuestionSummary(props) {
  return (
    props.question && (
      <React.Fragment>
        <Card>
          <Grid item xs={8}>
            <CardContent>
              <h2>
                Question:
                {' '}
                {props.question.title}
              </h2>
            </CardContent>
          </Grid>
        </Card>
      </React.Fragment>
    )
  );
}

QuestionSummary.propTypes = {
  getQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  question: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaignId: PropTypes.array,
  questionId: PropTypes.array,

};

export default compose(
  memo,
)(QuestionSummary);
