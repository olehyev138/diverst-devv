/**
 *
 * LogList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  Button, Grid, Box, Typography,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';
import { injectIntl, intlShape } from 'react-intl';

const styles = theme => ({
  logListItem: {
    width: '100%',
  },
  logListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function LogList(props, context) {
  const { classes } = props;
  const { intl } = props;
  const [expandedSegments, setExpandedSegments] = useState({});

  /* Store a expandedSegmentsHash for each segment, that tracks whether or not its children are expanded */
  if (props.logs && Object.keys(props.logs).length !== 0 && Object.keys(expandedSegments).length <= 0) {
    const initialExpandedSegments = {};

    /* Setup initial hash, with each segment set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.logs).map((id, i) => initialExpandedSegments[id] = false); // eslint-disable
    setExpandedSegments(initialExpandedSegments);
  }

  const columns = [
    {
      title: <DiverstFormattedMessage {...messages.list.name} />,
      field: 'name',
      query_field: 'name'
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Typography variant='h5' component='h2' display='inline'>
            placerholder for filters
          </Typography>

        </Grid>
      </Grid>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.list.title)}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingLogs}
            rowsPerPage={5}
            dataArray={Object.values(props.logs)}
            dataTotal={props.logTotal}
            columns={columns}
          />
        </Grid>
      </Grid>

    </React.Fragment>
  );
}
LogList.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  logs: PropTypes.object,
  logTotal: PropTypes.number,
  isFetchingLogs: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleChangeScope: PropTypes.func,
};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(LogList);
