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

import { createQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import { selectIsCommitting } from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import CampaignQuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';
import Conditional from 'components/Compositions/Conditional';
import { getCampaignBegin } from 'containers/Innovate/Campaign/actions';
import { selectCampaign, selectIsFormLoading } from 'containers/Innovate/Campaign/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignQuestionCreatePage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });
  const { intl } = props;

  const { campaign_id: campaignId } = useParams();
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.show.path(campaignId),
  };

  useEffect(() => {
    props.getCampaignBegin({ id: campaignId });

    return () => props.campaignQuestionsUnmount();
  }, []);

  return (
    <CampaignQuestionForm
      questionAction={props.createQuestionBegin}
      campaignId={campaignId}
      buttonText={intl.formatMessage(messages.create)}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

CampaignQuestionCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  getCampaignBegin: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  campaign: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  campaign: selectCampaign(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  CampaignQuestionCreatePage,
  ['campaign.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.admin.innovate.campaigns.index.path(),
  permissionMessages.innovate.campaign.campaignQuestion.createPage
));