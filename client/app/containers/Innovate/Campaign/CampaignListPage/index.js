import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';

import {
  getCampaignsBegin, deleteCampaignBegin,
  campaignsUnmount
} from 'containers/Innovate/Campaign/actions';

import {
  selectPaginatedCampaigns, selectCampaignTotal,
  selectIsFetchingCampaigns, selectFormCampaign,
} from 'containers/Innovate/Campaign/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import CampaignList from 'components/Innovate/Campaign/CampaignList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignListPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc'
  });

  const links = {
    campaignNew: ROUTES.admin.innovate.campaigns.new.path(),
    campaignEdit: id => ROUTES.admin.campaigns.edit.path(id),
    // campaignsNew: ROUTES.group.members.new.path(groupId),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getCampaignsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getCampaignsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getCampaignsBegin(params);

    return () => {
      props.campaignsUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <CampaignList
        campaignList={props.campaignList}
        camapaignTotal={props.campaignTotal}
        isFetchingCampaigns={props.isFetchingCampaigns}
        deleteCampaignBegin={props.deleteCampaignBegin}
        handleVisitCampaignEdit={props.handleVisitCampaignEdit}
        handleVisitCampaignShow={props.handleVisitCampaignShow}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
      />
    </React.Fragment>
  );
}

CampaignListPage.propTypes = {
  getCampaignsBegin: PropTypes.func,
  deleteCampaignBegin: PropTypes.func,
  campaignsUnmount: PropTypes.func,
  campaignList: PropTypes.array,
  campaignTotal: PropTypes.number,
  isFetchingCampaigns: PropTypes.bool,
  campaign: PropTypes.object,
  handleVisitCampaignEdit: PropTypes.func,
  handleVisitCampaignShow: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  campaignList: selectPaginatedCampaigns(),
  campaignTotal: selectCampaignTotal(),
  isFetchingCampaigns: selectIsFetchingCampaigns(),
  campaign: selectFormCampaign(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = dispatch => ({
  getCampaignsBegin: payload => dispatch(getCampaignsBegin(payload)),
  deleteCampaignBegin: payload => dispatch(deleteCampaignBegin(payload)),
  campaignsUnmount: () => dispatch(campaignsUnmount()),
  handleVisitCampaignEdit: id => dispatch(push(ROUTES.admin.innovate.campaigns.edit.path(id))),
  handleVisitCampaignShow: id => dispatch(push(ROUTES.admin.innovate.campaigns.show.path(id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  CampaignListPage,
  ['permissions.campaigns_create'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.innovate.campaign.listPage
));
