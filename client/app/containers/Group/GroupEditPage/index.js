import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { selectGroup } from 'containers/Group/selectors';

import { getGroupBegin, updateGroupBegin, groupFormUnmount } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupForm from 'components/Group/GroupForm';

export function GroupEditPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    props.getGroupBegin({ id: props.location.state.id });

    return () => {
      props.groupFormUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupForm
        groupAction={props.updateGroupBegin}
        group={props.group}
        buttonText='Edit'
      />
    </React.Fragment>
  );
}

GroupEditPage.propTypes = {
  location: PropTypes.shape({
    state: PropTypes.shape({
      id: PropTypes.number
    })
  }),
  group: PropTypes.object,
  getGroupBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func
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
    groupFormUnmount: () => dispatch(groupFormUnmount())
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
