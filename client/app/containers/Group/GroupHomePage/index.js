import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import GroupHome from 'components/Group/GroupHome';


export function GroupHomePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  return (
    <GroupHome currentGroup={props.currentGroup} />
  );
}

GroupHomePage.propTypes = {
  currentGroup: PropTypes.object,
};

export default compose(
  memo,
)(GroupHomePage);
