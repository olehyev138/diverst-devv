/**
 *
 * PollResponses List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  CardContent, Grid, Divider,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import { permission } from 'utils/permissionsHelpers';
import CustomFieldShow from 'components/Shared/Fields/FieldDisplays/Field';

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
      title: <DiverstFormattedMessage {...messages.responses.respondent} />,
      field: 'respondent',
      sorting: false
    },
    {
      title: <DiverstFormattedMessage {...messages.responses.date} />,
      query_field: 'poll_responses.created_at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATETIME_FULL)
    },
  ];

  const detailPanel = [{
    tooltip: props.intl.formatMessage(messages.responses.show),
    render: rowData => rowData.field_data && rowData.field_data.map((fieldDatum, i) => (
      <div key={fieldDatum.id}>
        <CardContent>
          <Grid item>
            <CustomFieldShow
              fieldDatum={fieldDatum}
              fieldDatumIndex={i}
            />
          </Grid>
        </CardContent>
        <Divider />
      </div>
    ))
  }];

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
            title={props.intl.formatMessage(messages.responses.title)}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.responsesLoading}
            rowsPerPage={10}
            dataArray={props.responses}
            dataTotal={props.responsesTotal}
            columns={columns}
            detailPanel={detailPanel}
            onRowClick={(event, rowData, togglePanel) => togglePanel()}
            my_options={{
              search: false
            }}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}
PollResponses.propTypes = {
  intl: intlShape.isRequired,
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
