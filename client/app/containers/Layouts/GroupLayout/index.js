import React, { memo, useContext, useEffect } from 'react';
import { Route } from 'react-router';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';

import Container from '@material-ui/core/Container';
import { withStyles } from '@material-ui/core/styles';

import GroupLinks from 'components/Group/GroupLinks';
import AuthenticatedLayout from '../AuthenticatedLayout';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';

import { getGroupBegin, groupFormUnmount } from 'containers/Group/actions';
import { selectGroup } from 'containers/Group/selectors';
import dig from 'object-dig';
import RouteService from 'utils/routeHelpers';
import { createStructuredSelector } from 'reselect';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const GroupLayout = ({ component: Component, ...rest }) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const {
    classes, computedMatch, location, currentGroup, ...other
  } = rest;

  /* - currentGroup will be wrapped around every container in the group section
   * - Connects to store & handles general current group state, such as current group object, layout
   */

  const rs = new RouteService({ computedMatch, location });

  useEffect(() => {
    const groupId = rs.params('group_id');

    if (dig(other.currentGroup, 'id') !== groupId)
      other.getGroupBegin({ id: groupId });

    return () => other.groupFormUnmount();
  }, []);

  return (
    <AuthenticatedLayout
      position='absolute'
      {...other}
      component={() => (
        <React.Fragment>
          <div className={classes.toolbar} />
          <GroupLinks {...other} />

          <Container>
            <div className={classes.content}>
              {currentGroup && (
                <Component currentGroup={currentGroup} {...other} />
              )}
            </div>
          </Container>
        </React.Fragment>
      )}
    />
  );
};

GroupLayout.propTypes = {
  component: PropTypes.elementType,
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
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
  withStyles(styles),
  memo,
)(GroupLayout);
