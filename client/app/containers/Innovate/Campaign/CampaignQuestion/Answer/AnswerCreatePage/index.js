import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import questionReducer from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import questionSaga from 'containers/Innovate/Campaign/CampaignQuestion/saga';
import campaignReducer from 'containers/Innovate/Campaign/reducer';
import campaignSaga from 'containers/Innovate/Campaign/saga';
import reducer from 'containers/Innovate/Campaign/CampaignQuestion/Answer/reducer';
import saga from 'containers/Innovate/Campaign/CampaignQuestion/Answer/saga';

import { createAnswerBegin, questionAnswersUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/Answer/actions';
import { selectIsCommitting } from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import AnswerForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/Answer/messages';

export function AnswerCreatePage(props) {
  useInjectReducer({ key: 'answers', reducer });
  useInjectSaga({ key: 'answers', saga });
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });

  const rs = new RouteService(useContext);
  const questionId = rs.params('question_id');
  const campaignId = rs.params('campaign_id');
  // const links = {
  //   questionsIndex: ROUTES.admin.innovate.campaigns.show.path(campaignId),
  // };

  useEffect(() => () => props.questionAnswersUnmount(), []);

  return (
    <AnswerForm
      answerAction={props.createAnswerBegin}
      campaignId={campaignId[0]}
      questionId={questionId[0]}
      buttonText={<DiverstFormattedMessage {...messages.create} />}
      isCommitting={props.isCommitting}
      // links={links}
    />
  );
}

AnswerCreatePage.propTypes = {
  createAnswerBegin: PropTypes.func,
  questionAnswersUnmount: PropTypes.func,
  getAnswerBegin: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createAnswerBegin,
  questionAnswersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AnswerCreatePage);
