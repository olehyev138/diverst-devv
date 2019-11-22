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
import campaignReducer from 'containers/Innovate/Campaign/reducer';
import campaignSaga from 'containers/Innovate/Campaign/saga';

import {
  selectQuestionTotal, selectIsCommitting, selectQuestion
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import CampaignQuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';

import { updateQuestionBegin, getQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';


export function CampaignQuestionEditPage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });

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
    <CampaignQuestionForm
      edit
      getQuestionBegin={props.getQuestionBegin}
      questionAction={props.updateQuestionBegin}
      campaignId={props.campaignId}
      questionId={props.questionId}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText='Update'
      question={props.question}
      links={links}
    />
  );
}

CampaignQuestionEditPage.propTypes = {
  getQuestionBegin: PropTypes.func,
  updateQuestionBegin: PropTypes.func,
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
  updateQuestionBegin,
  campaignQuestionsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignQuestionEditPage);
