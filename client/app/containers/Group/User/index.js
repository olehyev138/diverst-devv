/**
 *
 * User Groups
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal } from 'containers/Group/selectors';
import reducer from 'containers/Group/reducer';
import { getGroupsBegin } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupsList from 'components/User/Groups';

export function Groups(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    props.getGroupsBegin();
  }, []);

  return (
    <React.Fragment>
      <GroupsList groups={props.groups} groupTotal={props.groupTotal} />
    </React.Fragment>
  );
}

Groups.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Groups);
