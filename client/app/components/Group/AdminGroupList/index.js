/**
 *
 * Admin AdminGroupList List
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions, Typography, Grid, Link
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  groupListItem: {
    width: '100%',
  },
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function AdminGroupList(props) {
  const { classes } = props;

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        {props.groups && props.groups.map((group, i) => (
          <Grid item key={group.id} className={classes.groupListItem}>
            <Card>
              <CardContent>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link href='#'>
                  <Typography variant='h5' component='h2' display='inline'>
                    {group.name}
                  </Typography>
                </Link>
                {group.description && (
                  <Typography color='textSecondary' className={classes.groupListItemDescription}>
                    {group.description}
                  </Typography>
                )}
              </CardContent>
              <CardActions>
                <Button size='small' color='primary'>Edit</Button>
                <Button size='small' className={classes.errorButton}>Delete</Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
    </React.Fragment>
  );
}

AdminGroupList.propTypes = {
  classes: PropTypes.object,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
};

export default compose(
  memo,
  withStyles(styles),
)(AdminGroupList);
