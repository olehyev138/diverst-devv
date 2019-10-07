/**
 *
 * Segment Member List Component
 *
 */

import React, {
  forwardRef, memo, useState,
  useEffect, useRef
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Card, CardActions, CardContent, Collapse, Grid, Link,
  TablePagination, Typography, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstTable from 'components/Shared/DiverstTable';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function SegmentMemberList(props) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `users.${columns[columnId].field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to='#'
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            Export
          </Button>
        </Grid>
      </Grid>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Members'
            handlePagination={props.handlePagination}
            isLoading={props.isFetchingMembers}
            onOrderChange={handleOrderChange}
            dataArray={props.memberList}
            dataTotal={props.memberTotal}
            columns={columns}
            rowsPerPage={5}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

SegmentMemberList.propTypes = {
  classes: PropTypes.object,
  links: PropTypes.shape({
    segmentMembersNew: PropTypes.string,
  }),
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  segmentId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(SegmentMemberList);
