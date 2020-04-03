import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import CommentListItem from 'components/Innovate/Campaign/CampaignQuestion/Answer/Comment/CommentListItem';
import { Card, CardContent, Grid } from '@material-ui/core';

export function AnswerListItem(props) {
  return (
    props.currentAnswer && (
      <React.Fragment>
        <Card>
          <CardContent>
            <Grid item xs={12}>
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
            </Grid>
          </CardContent>
        </Card>
        <br />
      </React.Fragment>
    )
  );
}

AnswerListItem.propTypes = {
  currentAnswer: PropTypes.object,
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
)(AnswerListItem);
