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

import {
  getQuestionBegin, updateQuestionBegin,
  campaignQuestionsUnmount,
} from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import {
  selectQuestion,
  selectIsCommitting,
  selectIsFormLoading,
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';
import { selectCustomText } from '../../../../Shared/App/selectors';

import QuestionSummary from 'components/Innovate/Campaign/CampaignQuestion/QuestionSummary';
import AnswerListPage from 'containers/Innovate/Campaign/CampaignQuestion/Answer/AnswerListPage';
import CampaignQuestionClose from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionClose';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignQuestionShowPage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });

  const { campaign_id: campaignId, question_id: questionId } = useParams();
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.show.path(campaignId),
  };

  useEffect(() => {
    props.getQuestionBegin({ id: questionId });
    return () => props.campaignQuestionsUnmount();
  }, []);

  return (
    props.question
    && (
      <React.Fragment>
        <QuestionSummary
          getQuestionBegin={props.getQuestionBegin}
          campaignId={props.campaignId}
          isFormLoading={props.isFormLoading}
          question={props.question}
          links={links}
        />
        <AnswerListPage />
        <CampaignQuestionClose
          getQuestionBegin={props.getQuestionBegin}
          campaignId={props.campaignId}
          isFormLoading={props.isFormLoading}
          questionAction={props.updateQuestionBegin}
          question={props.question}
          links={links}
          customTexts={props.customTexts}
        />
        {props.question.solved_at !== null ? (<h2>{<DiverstFormattedMessage {...messages.question.closed} />}</h2>) : null}
      </React.Fragment>
    )
  );
}

CampaignQuestionShowPage.propTypes = {
  getQuestionBegin: PropTypes.func,
  updateQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  question: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaignId: PropTypes.array,
  questionId: PropTypes.array,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  question: selectQuestion(),
  isFormLoading: selectIsFormLoading(),
  customTexts: selectCustomText(),
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
)(Conditional(
  CampaignQuestionShowPage,
  ['question.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.admin.innovate.campaigns.index.path(),
  permissionMessages.innovate.campaign.campaignQuestion.showPage
));
