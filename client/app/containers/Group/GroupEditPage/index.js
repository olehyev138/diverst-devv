import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { selectGroup } from 'containers/Group/selectors';

import { getGroupBegin, updateGroupBegin } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupForm from 'components/Group/GroupForm';

export function GroupEditPage(props) {
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    props.getGroupBegin({ id: props.location.state.id });
  }, []);

  return (
    <GroupForm
      groupAction={props.updateGroupBegin}
      group={props.group}
      buttonText='Edit'
    />
  );
}

GroupEditPage.propTypes = {
  location: PropTypes.shape({
    state: PropTypes.shape({
      id: PropTypes.number
    })
  }),
  group: PropTypes.object,
  fetchGroupBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func
};

const mapStateToProps = (state, ownProps) => {
  return {
    group: selectGroup(ownProps.location.state.id)(state)
  };
};


function mapDispatchToProps(dispatch) {
  return {
    getGroupBegin: payload => dispatch(getGroupBegin(payload)),
    updateGroupBegin: payload => dispatch(updateGroupBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupEditPage);
