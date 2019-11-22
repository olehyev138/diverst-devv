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
import reducer from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import saga from 'containers/Innovate/Campaign/CampaignQuestion/saga';

import {
  getQuestionBegin,
  campaignQuestionsUnmount,
} from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import { selectQuestion, selectIsCommitting } from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import QuestionSummary from 'components/Innovate/Campaign/CampaignQuestion/QuestionSummary';

export function CampaignQuestionShowPage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });

  const rs = new RouteService(useContext);
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.show.path(rs.params('campaign_id')),
  };

  useEffect(() => {
    const campaignId = rs.params('campaign_id');
    const questionId = rs.params('question_id');

    props.getQuestionBegin({ id: questionId });
    return () => props.campaignQuestionsUnmount();
  }, []);

  return (
    <QuestionSummary
      getQuestionBegin={props.getQuestionBegin}
      campaignId={props.campaignId}
      isFormLoading={props.isFormLoading}
      question={props.question}
      links={links}
    />
  );
}

CampaignQuestionShowPage.propTypes = {
  getQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.func,
  question: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaignId: PropTypes.array,
  questionId: PropTypes.array,

};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  question: selectQuestion(),
});

const mapDispatchToProps = {
  getQuestionBegin,
  campaignQuestionsUnmount,
};
const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignQuestionShowPage);
