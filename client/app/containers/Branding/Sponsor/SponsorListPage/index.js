import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Shared/Sponsors/reducer';
import saga from 'containers/Branding/Sponsor/enterprisesponsorsSaga';

import {
  getSponsorsBegin, deleteSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import {
  selectPaginatedSponsors, selectSponsorTotal,
  selectIsFetchingSponsors
} from 'containers/Shared/Sponsors/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import SponsorList from 'components/Branding/Sponsor/SponsorList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SponsorListPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc', query_scopes: ['enterprise_sponsor']
  });

  const links = {
    sponsorNew: ROUTES.admin.system.branding.sponsors.new.path(),
    sponsorEdit: id => ROUTES.admin.system.branding.sponsors.edit.path(id),
  };

  const { sponsor_id: sponsorId } = useParams();

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
  handleVisitSponsorEdit: (enterpriseId, id) => dispatch(push(ROUTES.admin.system.branding.sponsors.edit.path(id))),
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
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.branding.sponsor.listPage
));
