import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';

import {
  getMembersBegin, deleteMemberBegin,
  CampaignsUnmount
} from 'containers/Innovate/Campaign/actions';
import {
  selectPaginatedMembers, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Innovate/Campaign/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import CampaignList from 'components/Innovate/Campaign/CampaignList';

export function CampaignListPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });

  const rs = new RouteService(useContext);

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc'
  });

  const links = {
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
      props.getCampaignsBegin();
    };
  }, []);

  return (
    <React.Fragment>
      <CampaignList
        campaignList={props.campaignList}
        camapaignTotal={props.campaignTotal}
        isFetchingMembers={props.isFetchingCampaigns}
        deleteMemberBegin={props.deleteCampaignBegin}
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
  isFetchingCampaigns: PropTypes.bool
};

const mapStateToProps = createStructuredSelector({
  campaignList: selectPaginatedMembers(),
  campaignTotal: selectMemberTotal(),
  isFetchingCampaigns: selectIsFetchingMembers()
});

const mapDispatchToProps = {
  getCampaignsBegin,
  deleteCampaignBegin,
  campaignsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignListPage);
