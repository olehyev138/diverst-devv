/**
 *
 * SegmentList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Segment/messages';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import Pagination from 'components/Shared/Pagination';

const styles = theme => ({
  segmentListItem: {
    width: '100%',
  },
  segmentListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function SegmentList(props, context) {
  const { classes } = props;
  const { links } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [expandedSegments, setExpandedSegments] = useState({});

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  /* Store a expandedSegmentsHash for each segment, that tracks whether or not its children are expanded */
  if (props.segments && Object.keys(props.segments).length !== 0 && Object.keys(expandedSegments).length <= 0) {
    const initialExpandedSegments = {};

    /* Setup initial hash, with each segment set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.segments).map((id, i) => initialExpandedSegments[id] = false); // eslint-disable
    setExpandedSegments(initialExpandedSegments);
  }

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={links.segmentNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.segments && Object.values(props.segments).map((segment, i) => {
          return (
            <Grid item key={segment.id} className={classes.segmentListItem}>
              <Card>
                <CardContent>
                  {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                  <Link
                    component={WrappedNavLink}
                    to={links.segmentPage(segment.id)}
                  >
                    <Typography variant='h5' component='h2' display='inline'>
                      {segment.name}
                    </Typography>
                  </Link>
                  {segment.description && (
                    <Typography color='textSecondary' className={classes.segmentListItemDescription}>
                      {segment.description}
                    </Typography>
                  )}
                </CardContent>
                <CardActions>
                  <Button
                    size='small'
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete segment?'))
                        props.deleteSegmentBegin(segment.id);
                    }}
                  >
                    <FormattedMessage {...messages.delete} />
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          );
        })}
      </Grid>
      <Pagination
        page={page}
        rowsPerPage={rowsPerPage}
        count={props.segmentTotal}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
      />
    </React.Fragment>
  );
}

SegmentList.propTypes = {
  classes: PropTypes.object,
  segments: PropTypes.object,
  segmentTotal: PropTypes.number,
  deleteSegmentBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles),
)(SegmentList);
