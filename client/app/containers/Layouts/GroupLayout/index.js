import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import { withStyles } from '@material-ui/core/styles';

import GroupLinks from 'components/Group/GroupLinks';
import AuthenticatedLayout from '../AuthenticatedLayout';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';

import { getGroupBegin, groupFormUnmount } from 'containers/Group/actions';
import { selectGroup, selectHasChanged } from 'containers/Group/selectors';
import dig from 'object-dig';
import RouteService from 'utils/routeHelpers';
import { createStructuredSelector } from 'reselect';

import Scrollbar from 'components/Shared/Scrollbar';
import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    padding: theme.spacing(3),
  },
});

const GroupLayout = ({ component: Component, classes, ...rest }) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const {
    computedMatch, location, currentGroup, disableBreadcrumbs, ...other
  } = rest;

  /* - currentGroup will be wrapped around every container in the group section
   * - Connects to store & handles general current group state, such as current group object, layout
   */

  const rs = new RouteService({ computedMatch, location });

  useEffect(() => {
    const groupId = rs.params('group_id');

    if (groupId && dig(other.currentGroup, 'id') !== groupId)
      other.getGroupBegin({ id: groupId });

    return () => other.groupFormUnmount();
  }, [rs.params('group_id'), rest.groupHasChanged]);

  return (
    <AuthenticatedLayout
      position='relative'
      {...other}
      component={() => (
        <React.Fragment>
          <GroupLinks currentGroup={currentGroup} {...other} />
          <Scrollbar>
            <Fade in appear>
              <Container maxWidth='lg'>
                <div className={classes.content}>
                  {currentGroup && (
                    <React.Fragment>
                      {disableBreadcrumbs !== true ? (
                        <DiverstBreadcrumbs />
                      ) : (
                        <React.Fragment />
                      )}
                      <Component currentGroup={currentGroup} {...rest} />
                    </React.Fragment>
                  )}
                </div>
              </Container>
            </Fade>
          </Scrollbar>
        </React.Fragment>
      )}
    />
  );
};

GroupLayout.propTypes = {
  component: PropTypes.elementType,
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
  disableBreadcrumbs: PropTypes.bool,
  grouphasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  groupHasChanged: selectHasChanged(),
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
