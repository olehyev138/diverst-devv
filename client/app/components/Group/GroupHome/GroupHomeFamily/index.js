/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Divider, Typography, Card, Paper, CardContent, Link, Box } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { ROUTES } from 'containers/Shared/Routes/constants';
import GroupIcon from '@material-ui/icons/Group';
import GroupOutlinedIcon from '@material-ui/icons/GroupOutlined';

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
    <Grid container spacing={3}>
      <Grid item xs='auto'>
        <Link
          href={ROUTES.group.home.path(group.id)}
          rel='noopener'
        >
          <Typography>
            {`${group.name}`}
          </Typography>
        </Link>
      </Grid>
      <Grid item xs='auto'>
        {group.current_user_is_member
          ? <GroupIcon /> : <GroupOutlinedIcon />}
      </Grid>
    </Grid>
  );

  return (props.currentGroup.parent || props.currentGroup.children.length > 0) && (
    <Card>
      <CardContent>
        { props.currentGroup.parent && (
          <React.Fragment>
            <Typography variant='h6'>
              Parent-Group
            </Typography>
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
