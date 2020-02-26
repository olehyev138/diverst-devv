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

import { createQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import { selectIsCommitting } from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import CampaignQuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Innovate/Campaign/CampaignQuestion/messages';

export function CampaignQuestionCreatePage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });
  useInjectReducer({ key: 'campaigns', reducer: campaignReducer });
  useInjectSaga({ key: 'campaigns', saga: campaignSaga });
  const { intl } = props;
  const rs = new RouteService(useContext);
  const campaignId = rs.params('campaign_id');
  const links = {
    questionsIndex: ROUTES.admin.innovate.campaigns.show.path(campaignId),
  };

  useEffect(() => () => props.campaignQuestionsUnmount(), []);

  return (
    <CampaignQuestionForm
      questionAction={props.createQuestionBegin}
      campaignId={campaignId[0]}
      buttonText={intl.formatMessage(messages.create)}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

CampaignQuestionCreatePage.propTypes = {
  intl: intlShape,
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
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(CampaignQuestionCreatePage);
