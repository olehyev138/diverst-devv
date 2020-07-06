import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import saga from 'containers/Innovate/Campaign/CampaignQuestion/saga';
import campaignReducer from 'containers/Innovate/Campaign/reducer';
import campaignSaga from 'containers/Innovate/Campaign/saga';

import {
  selectIsCommitting, selectQuestion, selectIsFormLoading
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import CampaignQuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';

import { updateQuestionBegin, getQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignQuestionEditPage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });

  const { intl } = props;

  const { campaign_id: campaignId, question_id: questionId } = useParams();
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.show.path(campaignId),
  };

  useEffect(() => {
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
      buttonText={intl.formatMessage(messages.update)}
      question={props.question}
      links={links}
    />
  );
}

CampaignQuestionEditPage.propTypes = {
  intl: intlShape.isRequired,
  getQuestionBegin: PropTypes.func,
  updateQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  question: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaignId: PropTypes.array,
  questionId: PropTypes.array,

};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  question: selectQuestion(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  CampaignQuestionEditPage,
  ['question.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.admin.innovate.campaigns.index.path(),
  permissionMessages.innovate.campaign.campaignQuestion.editPage
));
