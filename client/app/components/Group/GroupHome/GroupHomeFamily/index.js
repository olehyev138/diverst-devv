/**
 *
 * Group Home Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Divider, Typography, Card, Button, CardContent, Link, Box, Tooltip } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { ROUTES } from 'containers/Shared/Routes/constants';
import GroupIcon from '@material-ui/icons/Group';
import GroupOutlinedIcon from '@material-ui/icons/GroupOutlined';
import Collapse from '@material-ui/core/Collapse';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(1),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
});

export function GroupHomeFamily({ classes, ...props }) {
  const renderGroup = group => (
    <Grid container spacing={3} justify='space-between'>
      <Grid item xs='auto'>
        <Link
          component={WrappedNavLink}
          to={ROUTES.group.home.path(group.id)}
        >
          <Typography>
            {`${group.name}`}
          </Typography>
        </Link>
      </Grid>
      <Grid item xs='auto'>
        {group.current_user_is_member
          ? (
            <Tooltip title={<DiverstFormattedMessage {...messages.family.areMember} />} enterDelay={300} placement='right'>
              <GroupIcon />
            </Tooltip>
          ) : (
            <Tooltip title={<DiverstFormattedMessage {...messages.family.notMember} />} enterDelay={300} placement='right'>
              <GroupOutlinedIcon />
            </Tooltip>
          )}
      </Grid>
    </Grid>
  );

  const [expand, setExpand] = useState(false);

  const needExpand = ((props.currentGroup.parent ? 2 : 0)
    + (props.currentGroup.children.length > 0 ? props.currentGroup.children.length + 2 : 0)) > 5;

  const CollapseConditional = needExpand ? Collapse : React.Fragment;

  return (props.currentGroup.parent || props.currentGroup.children.length > 0) && (
    <Card>
      <CardContent>
        <CollapseConditional in={expand} collapsedHeight={125}>
          { props.currentGroup.parent && (
            <React.Fragment>
              <Typography variant='h6'>
                Parent-Group
              </Typography>
              <Box mb={1} />
              <Divider />
              <Box mb={1} />
              { renderGroup(props.currentGroup.parent) }
            </React.Fragment>
          )}
          { props.currentGroup.children.length > 0 && (
            <React.Fragment>
              <Typography variant='h6'>
                Sub-Groups
              </Typography>
              {props.currentGroup.children.map(child => (
                <React.Fragment key={`child:${child.id}`}>
                  <Box mb={1} />
                  <Divider />
                  <Box mb={1} />
                  { renderGroup(child) }
                </React.Fragment>
              ))}
            </React.Fragment>
          )}
        </CollapseConditional>
        { needExpand && (
          <React.Fragment>
            <Box mb={1} />
            <Button
              size='small'
              onClick={() => setExpand(!expand)}
            >
              {expand ? <DiverstFormattedMessage {...messages.family.showLess} /> : <DiverstFormattedMessage {...messages.family.showMore} />}
            </Button>
          </React.Fragment>
        )}
      </CardContent>
    </Card>
  );
}

GroupHomeFamily.propTypes = {
  currentGroup: PropTypes.object,
  classes: PropTypes.object,
  joinGroup: PropTypes.func,
  leaveGroup: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupHomeFamily);
