import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Shared/Sponsors/reducer';
import saga from 'containers/Shared/Sponsors/saga';

import {
  getSponsorsBegin, deleteSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import {
  selectPaginatedSponsors, selectSponsorTotal,
  selectIsFetchingSponsors
} from 'containers/Shared/Sponsors/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import SponsorList from 'components/Branding/Sponsor/SponsorList';
import { push } from 'connected-react-router';

export function GroupSponsorListPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id')[0];

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc', query_scopes: ['group_sponsor'] , sponsorable_id: groupId
  });

  const links = {
    sponsorNew: ROUTES.group.manage.sponsors.new.path(groupId),
    sponsorEdit: id => ROUTES.group.manage.sponsors.edit.path(groupId),
  };

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

GroupSponsorListPage.propTypes = {
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
});


const mapDispatchToProps = dispatch => ({
  getSponsorsBegin: payload => dispatch(getSponsorsBegin(payload)),
  deleteSponsorBegin: payload => dispatch(deleteSponsorBegin(payload)),
  sponsorsUnmount: () => dispatch(sponsorsUnmount()),
  handleVisitSponsorEdit: (groupId, id) => dispatch(push(ROUTES.group.manage.sponsors.edit.path(groupId,id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSponsorListPage);
