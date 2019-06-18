/**
 *
 * Groups
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions, Typography, Grid, Link
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal } from 'containers/Group/Groups/selectors';
import reducer from 'containers/Group/Groups/reducer';
import saga from 'containers/Group/Groups/saga';
import messages from 'containers/Group/Groups/messages';
import { getGroupsBegin } from 'containers/Group/Groups/actions';

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

// TODO: Figure out structure for this
export function Groups(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const { classes } = props;

  useEffect(() => {
    props.getGroupsBegin();
  }, []);

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

Groups.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  classes: PropTypes.object,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(Groups);
