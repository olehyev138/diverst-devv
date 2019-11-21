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

import {
  selectQuestionTotal, selectIsCommitting
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import QuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';

import { updateQuestionBegin, getQuestionBegin, campaignQuestionsUnmount } from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import { selectCampaignTotal, selectFormCampaign, selectIsCommitting } from 'containers/Innovate/Campaign/selectors';

import CampaignQuestionForm from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionForm';

import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups, selectFormGroup } from 'containers/Group/selectors';

export function CampaignEditPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const rs = new RouteService(useContext);
  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };

  useEffect(() => {
    const campaignId = rs.params('campaign_id');
    props.getCampaignBegin({ id: rs.params('campaign_id') });

    return () => props.campaignsUnmount();
  }, []);
  return (
    <CampaignForm
      edit
      getCampaignBegin={props.getCampaignBegin}
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.groups}
      group={props.group}
      campaignAction={props.updateCampaignBegin}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText='Update'
      campaign={props.campaign}
      links={links}
    />
  );
}

CampaignEditPage.propTypes = {
  getCampaignBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  updateCampaignBegin: PropTypes.func,
  group: PropTypes.object,
  groups: PropTypes.array,
  campaignsUnmount: PropTypes.func,
  isFormLoading: PropTypes.func,
  campaign: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  campaign: selectFormCampaign(),
  question: selectFormQuestion(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  getCampaignBegin,
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
