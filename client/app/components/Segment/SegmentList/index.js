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
  Typography, Grid, Link, TablePagination, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

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

    /* eslint-disable-next-line no-return-assign */
    /* Setup initial hash, with each segment set to false - do it like this because of how React works with state */
    Object.keys(props.segments).map((id, i) => initialExpandedSegments[id] = false);
    setExpandedSegments(initialExpandedSegments);
  }

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.manage.segments.new.path()}
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
                    to={{
                      pathname: `${ROUTES.segment.pathPrefix}/${segment.id}`,
                      state: { id: segment.id }
                    }}
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
                    to={{
                      pathname: `${ROUTES.manage.segments.pathPrefix}/${segment.id}/edit`,
                      state: { id: segment.id }
                    }}
                    component={WrappedNavLink}
                  >
                    <FormattedMessage {...messages.edit} />
                  </Button>
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
                  <Button
                    size='small'
                    onClick={() => {
                      setExpandedSegments({ ...expandedSegments, [segment.id]: !expandedSegments[segment.id] });
                    }}
                  >
                    <FormattedMessage {...messages.children_collapse} />
                  </Button>
                </CardActions>
              </Card>
              <Collapse in={expandedSegments[`${segment.id}`]}>
                {segment.children && segment.children.map((segment, i) => (
                  /* eslint-disable-next-line react/jsx-wrap-multilines */
                  <Card key={segment.id}>
                    <CardContent>
                      {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                      <Link href='#'>
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
                  </Card>))
                }
              </Collapse>
            </Grid>
          );
        })}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.segmentTotal || 0}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
      />
    </React.Fragment>
  );
}

SegmentList.propTypes = {
  classes: PropTypes.object,
  segments: PropTypes.object,
  segmentTotal: PropTypes.number,
  deleteSegmentBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(SegmentList);
