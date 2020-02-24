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
import ExportIcon from '@material-ui/icons/SaveAlt';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';

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
    { title: <DiverstFormattedMessage {...messages.member.firstname} />, field: 'first_name' },
    { title: <DiverstFormattedMessage {...messages.member.lastname} />, field: 'last_name' }
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to='#'
            color='secondary'
            size='large'
            component={WrappedNavLink}
            startIcon={<ExportIcon />}
          >
            <DiverstFormattedMessage {...messages.member.export} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />
      <DiverstTable
        title={<DiverstFormattedMessage {...messages.member.title} />}
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingMembers}
        onOrderChange={handleOrderChange}
        dataArray={props.memberList}
        dataTotal={props.memberTotal}
        columns={columns}
        rowsPerPage={5}
      />
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
