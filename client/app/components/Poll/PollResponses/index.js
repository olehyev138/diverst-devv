/**
 *
 * PollResponses List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  CardContent, Grid, Divider, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import { permission } from 'utils/permissionsHelpers';
import CustomFieldShow from 'components/Shared/Fields/FieldDisplays/Field';
import dig from 'object-dig';
import DiverstSelect from 'components/Shared/DiverstSelect';

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
  const { links, intl, field, poll, fieldOptions } = props;
  const { value: fieldId, label: fieldLabel } = field;

  const responsesColumns = [
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

  const textColumns = [
    {
      title: <DiverstFormattedMessage {...messages.textual.answer} />,
      render: rowData => dig(rowData, 'field_data', fd => fd.find(fd => fd.field_id === fieldId), 'data'),
      sorting: false,
    },
    {
      title: <DiverstFormattedMessage {...messages.textual.respondent} />,
      field: 'respondent',
      sorting: false
    },
    {
      title: <DiverstFormattedMessage {...messages.textual.date} />,
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATETIME_FULL),
      query_field: 'poll_responses.created_at',
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
      orderBy: (columnId === -1) ? 'id' : `${responsesColumns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      {fieldOptions.length > 0 && (
        <Grid container justify='flex-end'>
          <Grid item xs={6}>
            <DiverstSelect
              fullWidth
              label={<DiverstFormattedMessage {...messages.textual.question} />}
              options={fieldOptions}
              value={field}
              onChange={v => props.setField(v)}
              hideHelperText
              isClearable
            />
          </Grid>
        </Grid>
      )}
      <Box mb={2} />
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
            columns={fieldId ? textColumns : responsesColumns}
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
  poll: PropTypes.object,
  field: PropTypes.shape({
    label: PropTypes.string,
    value: PropTypes.number,
  }),
  fieldOptions: PropTypes.array,
  setField: PropTypes.func,
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
