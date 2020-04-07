import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Branding/Sponsor/reducer';
import saga from 'containers/Branding/Sponsor/saga';

import {
  getSponsorsBegin, deleteSponsorBegin,
  sponsorsUnmount
} from 'containers/Branding/Sponsor/actions';

import {
  selectPaginatedSponsors, selectSponsorTotal,
  selectIsFetchingSponsors
} from 'containers/Branding/Sponsor/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import SponsorList from 'components/Branding/Sponsor/SponsorList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';

export function SponsorListPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc'
  });

  const links = {
    sponsorNew: ROUTES.admin.system.branding.sponsors.new.path(),
    sponsorEdit: id => ROUTES.admin.system.branding.sponsors.edit.path(id),
  };

  const sponsorId = rs.params('sponsor_id');

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getSponsorsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getSponsorsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getSponsorsBegin(params);

    return () => {
      props.sponsorsUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SponsorList
        sponsorList={props.sponsorList}
        camapaignTotal={props.sponsorTotal}
        isFetchingSponsors={props.isFetchingSponsors}
        deleteSponsorBegin={props.deleteSponsorBegin}
        handleVisitSponsorEdit={props.handleVisitSponsorEdit}
        handleVisitSponsorShow={props.handleVisitSponsorShow}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
      />
    </React.Fragment>
  );
}

SponsorListPage.propTypes = {
  getSponsorsBegin: PropTypes.func,
  deleteSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func,
  sponsorList: PropTypes.array,
  sponsorTotal: PropTypes.number,
  isFetchingSponsors: PropTypes.bool,
  sponsor: PropTypes.object,
  handleVisitSponsorEdit: PropTypes.func,
  handleVisitSponsorShow: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  sponsorList: selectPaginatedSponsors(),
  sponsorTotal: selectSponsorTotal(),
  isFetchingSponsors: selectIsFetchingSponsors(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = dispatch => ({
  getSponsorsBegin: payload => dispatch(getSponsorsBegin(payload)),
  deleteSponsorBegin: payload => dispatch(deleteSponsorBegin(payload)),
  sponsorsUnmount: () => dispatch(sponsorsUnmount()),
  handleVisitSponsorEdit: id => dispatch(push(ROUTES.admin.system.branding.sponsors.edit.path(id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  SponsorListPage,
  ['permissions.branding_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'branding.sponsor.listPage'
));
