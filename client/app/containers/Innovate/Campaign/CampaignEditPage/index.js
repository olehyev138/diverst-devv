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
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';
import groupReducer from 'containers/Group/reducer';
import groupSaga from 'containers/Group/saga';

import { updateCampaignBegin, getCampaignBegin, campaignsUnmount } from 'containers/Innovate/Campaign/actions';
import {
  selectCampaignTotal,
  selectFormCampaign,
  selectIsCommitting,
  selectIsFormLoading
} from 'containers/Innovate/Campaign/selectors';

import CampaignForm from 'components/Innovate/Campaign/CampaignForm';

import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups, selectFormGroup } from 'containers/Group/selectors';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Innovate/Campaign/messages';
import Conditional from 'components/Compositions/Conditional';

export function CampaignEditPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const rs = new RouteService(useContext);
  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };
  const { intl } = props;
  useEffect(() => {
    const campaignId = rs.params('campaign_id');
    props.getCampaignBegin({ id: campaignId });

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
      buttonText={intl.formatMessage(messages.update)}
      campaign={props.campaign}
      links={links}
    />
  );
}

CampaignEditPage.propTypes = {
  intl: intlShape,
  getCampaignBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  updateCampaignBegin: PropTypes.func,
  group: PropTypes.object,
  groups: PropTypes.array,
  campaignsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  campaign: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  campaign: selectFormCampaign(),
  groups: selectPaginatedSelectGroups(),
  isCommitting: selectIsCommitting(),
  group: selectFormGroup(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getCampaignBegin,
  getGroupsBegin,
  updateCampaignBegin,
  campaignsUnmount,
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
  CampaignEditPage,
  ['campaign.permissions.update?', 'isFormLoading'],
  (props, rs) => ROUTES.admin.innovate.campaigns.show.path(rs.params('campaign_id')),
  'You don\'t have permission to edit this campaign'
));
