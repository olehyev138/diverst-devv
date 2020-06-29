import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import dig from 'object-dig';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import { getGroupBegin, groupFormUnmount } from 'containers/Group/actions';
import { selectGroup } from 'containers/Group/selectors';

/* Wrapper around every page in a 'group section' - /group/:id/
 * Handles global group state, ie current group, group layout
 * Is imported & rendered in GroupLayout
 */

// TODO: remounts on every group section page change, ie home -> news, would be better if it didnt

export function GroupPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const { group_id: groupId } = useParams();

  useEffect(() => {
    if (dig(props.currentGroup, 'id') !== groupId)
      props.getGroupBegin({ id: groupId });

    return () => props.groupFormUnmount();
  }, []);

  return (
    <React.Fragment>
      { /* Note: assumes a single child */ }
      {React.cloneElement(React.Children.only(props.children), { currentGroup: props.currentGroup, ...props })}
    </React.Fragment>
  );
}

GroupPage.propTypes = {
  computedMatch: PropTypes.shape({
    params: PropTypes.shape({
      id: PropTypes.string
    })
  }),
  currentGroup: PropTypes.object,
  children: PropTypes.any,
  groupFormUnmount: PropTypes.func,
  getGroupBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  getGroupBegin,
  groupFormUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupPage);
