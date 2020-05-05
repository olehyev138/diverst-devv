/**
 *
 * PollTestAnswers List
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
import dig from 'object-dig';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import { permission } from 'utils/permissionsHelpers';
import CustomFieldShow from 'components/Shared/Fields/FieldDisplays/Field';
import DiverstSelect from 'components/Shared/DiverstSelect';

const styles = theme => ({
  PollTestAnswersItem: {
    width: '100%',
  },
  PollTestAnswersItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function PollTestAnswers(props, context) {
  const { classes } = props;
  const { links, intl, field, poll } = props;
  const { value: fieldId, label: fieldLabel } = field;

  const columns = [
    {
      title: 'Answer',
      render: rowData => dig(rowData, 'field_data', fd => fd.find(fd => fd.field_id === fieldId), 'data'),
      sorting: false,
    },
    {
      title: 'Responded by',
      field: 'respondent',
      sorting: false
    },
    {
      title: 'Responded at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATETIME_FULL),
      query_field: 'poll_responses.created_at',
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
      <Grid container justify='flex-end'>
        <Grid item xs={6}>
          <DiverstSelect
            fullWidth
            label='Question'
            options={dig(poll, 'fields', fs => fs.filter(f => f.type === 'TextField'))}
            value={field}
            onChange={v => props.setField(v)}
            hideHelperText
          />
        </Grid>
      </Grid>
      <Box mb={2} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={fieldLabel}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.responsesLoading}
            rowsPerPage={10}
            dataArray={props.responses}
            dataTotal={props.responsesTotal}
            columns={columns}
            my_options={{
              search: false
            }}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}
PollTestAnswers.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  responses: PropTypes.array,
  responsesTotal: PropTypes.number,
  responsesLoading: PropTypes.bool,
  poll: PropTypes.object,
  field: PropTypes.shape({
    label: PropTypes.string,
    value: PropTypes.number,
  }),
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
)(PollTestAnswers);
