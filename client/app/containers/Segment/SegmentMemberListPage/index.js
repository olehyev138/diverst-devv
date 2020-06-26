import React, {
  memo, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Segment/reducer';
import saga from 'containers/Segment/saga';

import {
  getSegmentMembersBegin, segmentUnmount
} from 'containers/Segment/actions';
import {
  selectPaginatedSegmentMembers, selectSegmentMemberTotal,
  selectIsFetchingSegmentMembers
} from 'containers/Segment/selectors';
import { selectEnterprise } from 'containers/Shared/App/selectors';

import SegmentMemberList from 'components/Segment/SegmentMemberList';

export function SegmentMemberListPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const { segment_id: segmentId } = useParams();

  const [params, setParams] = useState({
    segment_id: segmentId, count: 5, page: 0, order: 'asc'
  });

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getSegmentMembersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getSegmentMembersBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getSegmentMembersBegin(params);

    return () => {
      props.segmentUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SegmentMemberList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
        isFetchingMembers={props.isFetchingMembers}
        segmentId={segmentId}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        currentEnterprise={props.currentEnterprise}
      />
    </React.Fragment>
  );
}

SegmentMemberListPage.propTypes = {
  getSegmentMembersBegin: PropTypes.func,
  segmentUnmount: PropTypes.func,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedSegmentMembers(),
  memberTotal: selectSegmentMemberTotal(),
  isFetchingMembers: selectIsFetchingSegmentMembers(),
  currentEnterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  getSegmentMembersBegin,
  segmentUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentMemberListPage);
