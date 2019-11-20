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
import getCampaignBegin from 'containers/Innovate/Campaign/actions';

import { createQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import {
  selectQuestionTotal, selectIsCommitting
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import QuestionForm from 'components/Innovate/Campaign/CampaignQuestion/QuestionForm';

export function CampaignCreatePage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });

  const rs = new RouteService(useContext);
  const campaignId = rs.params('campaign_id')[0];
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.questions.index.path(campaignId),
  };

  useEffect(() => () => props.campaignQuestionsUnmount(), []);

  return (
    <QuestionForm
      questionAction={props.createQuestionBegin}
      buttonText='Create'
      getCampaignBegin={props.getCampaignBegin}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

CampaignCreatePage.propTypes = {
  createQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  getCampaignBegin: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createQuestionBegin,
  campaignQuestionsUnmount,
  getCampaignBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignCreatePage);
