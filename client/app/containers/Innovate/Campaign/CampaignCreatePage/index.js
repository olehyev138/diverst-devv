import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';
import groupReducer from 'containers/Group/reducer';
import groupSaga from 'containers/Group/saga';

import { createCampaignBegin, campaignsUnmount } from 'containers/Innovate/Campaign/actions';
import {
  selectCampaignTotal, selectIsCommitting
} from 'containers/Innovate/Campaign/selectors';
import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';

import CampaignForm from 'components/Innovate/Campaign/CampaignForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Innovate/Campaign/messages';
import Conditional from 'components/Compositions/Conditional';
import { CampaignEditPage } from 'containers/Innovate/Campaign/CampaignEditPage';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignCreatePage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  const { intl } = props;
  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };

  useEffect(() => () => props.campaignsUnmount(), []);

  return (
    <CampaignForm
      campaignAction={props.createCampaignBegin}
      buttonText={intl.formatMessage(messages.create)}
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.groups}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

CampaignCreatePage.propTypes = {
  intl: intlShape,
  createCampaignBegin: PropTypes.func,
  campaignsUnmount: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groups: PropTypes.array,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createCampaignBegin,
  campaignsUnmount,
  getGroupsBegin,
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
  CampaignCreatePage,
  ['permissions.campaigns_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.innovate.campaign.createPage
));
