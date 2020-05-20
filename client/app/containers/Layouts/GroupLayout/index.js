import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import { withStyles } from '@material-ui/core/styles';

import GroupLinks from 'components/Group/GroupLinks';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';

import { getGroupBegin, groupFormUnmount } from 'containers/Group/actions';
import { selectGroup, selectHasChanged, selectGroupIsFormLoading } from 'containers/Group/selectors';
import dig from 'object-dig';
import { createStructuredSelector } from 'reselect';

import Scrollbar from 'components/Shared/Scrollbar';
import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    padding: theme.spacing(3),
  },
});

const GroupLayout = (props) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const { classes, currentGroup, ...rest } = props;

  /* - currentGroup will be wrapped around every container in the group section
   * - Connects to store & handles general current group state, such as current group object, layout
   */

  const { group_id: groupId } = useParams();

  useEffect(() => {
    if (groupId && dig(currentGroup, 'id') !== groupId)
      rest.getGroupBegin({ id: groupId });

    return () => rest.groupFormUnmount();
  }, [groupId, rest.groupHasChanged]);

  const permission = name => dig(currentGroup, 'permissions', name);

  return (
    <React.Fragment>
      { currentGroup && <GroupLinks currentGroup={currentGroup} permission={permission} {...rest} /> }
      <Scrollbar>
        <Fade in appear>
          <Container maxWidth='lg'>
            <div className={classes.content}>
              {currentGroup && (
                <React.Fragment>
                  <DiverstBreadcrumbs />
                  {renderChildrenWithProps(props.children, { currentGroup, permission, ...rest })}
                </React.Fragment>
              )}
            </div>
          </Container>
        </Fade>
      </Scrollbar>
    </React.Fragment>
  );
};

GroupLayout.propTypes = {
  children: PropTypes.any,
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
  groupHasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  isFormLoading: selectGroupIsFormLoading(),
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
)(Conditional(
  GroupLayout,
  ['currentGroup.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.user.root.path(),
  permissionMessages.layouts.group
));
