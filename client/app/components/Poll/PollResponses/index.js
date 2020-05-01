/**
 *
 * PollResponses List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  PollResponsesItem: {
    width: '100%',
  },
  PollResponsesItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function PollResponses(props, context) {
  const { classes } = props;
  const { links, intl } = props;

  const columns = [
    {
      title: 'Respondent',
      field: 'respondent',
      sorting: false
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
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Responses'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.responsesLoading}
            rowsPerPage={5}
            dataArray={props.responses}
            dataTotal={props.responsesTotal}
            columns={columns}
          />
        </Grid>
      </Grid>

    </React.Fragment>
  );
}
PollResponses.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  responses: PropTypes.array,
  responsesTotal: PropTypes.number,
  responsesLoading: PropTypes.bool,
  deletePollBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handlePollEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  links: PropTypes.shape({
    pollNew: PropTypes.string,
    pollEdit: PropTypes.func
  })
};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(PollResponses);
