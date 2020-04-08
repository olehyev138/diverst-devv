/**
 *
 * LogList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Grid, Box, Typography, Card, CardContent, Link
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';

import { injectIntl, intlShape } from 'react-intl';
import { Field, Form, Formik } from 'formik';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';
import { DateTime } from 'luxon';
import GroupSelector from 'components/Shared/GroupSelector';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  logListItem: {
    width: '100%',
  },
  logListItemDescription: {
    paddingTop: 8,
  },
});

export function LogList(props, context) {
  const { classes } = props;
  const { intl } = props;

  const columns = [
    {
      title: 'id',
      field: 'id',
      query_field: 'id'
    },
    {
      title: 'user',
      field: 'owner_id',
      render: rowData => (
        <Link
          component={WrappedNavLink}
          to={{
            pathname: ROUTES.admin.system.users.edit.path(rowData.owner_id),
            state: { id: rowData.owner_id }
          }}
        >
          {rowData.user.first_name}
          &ensp;
          {rowData.user.last_name}
        </Link>
      )
    },
    {
      title: 'key',
      field: 'key',
    },
    {
      title: 'date',
      field: 'created_at',
      query_field: 'created_at'
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
      <Card>
        <Formik
          initialValues={{
            from: props.logFrom,
            to: props.logTo,
            groupLabels: props.groupLabels,
          }}
          enableReinitialize
          onSubmit={(values) => {
            values.groupIds = (values.groupLabels || []).map(i => i.value);
            props.handleFilterChange(values);
          }}
        >
          {formikProps => (
            <Form>
              <CardContent>
                <Grid container spacing={3} alignItems='flex-end' justify='space-between'>
                  <Grid item xs={4}>
                    <Typography>Filter by group</Typography>
                  </Grid>
                  <Grid item xs={3}>
                    <Typography>From</Typography>
                  </Grid>
                  <Grid item xs={3}>
                    <Typography>To</Typography>
                  </Grid>
                  <Grid item xs={2}>
                  </Grid>
                </Grid>
                <Grid container spacing={3} alignItems='flex-start' justify='space-between'>
                  <Grid item xs={4}>
                    <GroupSelector
                      groupField='groupLabels'
                      label=''
                      {...formikProps}
                    />
                  </Grid>
                  <Grid item xs={3}>
                    <Field
                      component={DiverstDatePicker}
                      keyboardMode
                      fullWidth
                      maxDate={formikProps.values.to ? formikProps.values.to : new Date()}
                      maxDateMessage={<DiverstFormattedMessage {...messages.filter.fromMax} />}
                      id='from'
                      name='from'
                      margin='normal'
                      label=''
                    />
                  </Grid>
                  <Grid item xs={3}>
                    <Field
                      component={DiverstDatePicker}
                      keyboardMode
                      fullWidth
                      minDate={formikProps.values.from ? formikProps.values.from : undefined}
                      maxDate={new Date()}
                      minDateMessage={<DiverstFormattedMessage {...messages.filter.toMin} />}
                      maxDateMessage={<DiverstFormattedMessage {...messages.filter.toMax} />}
                      id='to'
                      name='to'
                      margin='normal'
                      label=''
                    />
                  </Grid>
                  <Grid item xs={2}>
                    <Button
                      color='primary'
                      type='submit'
                      variant='contained'
                      className={classes.submitButton}
                    >
                      Filter
                    </Button>
                  </Grid>
                </Grid>
              </CardContent>
            </Form>
          )}
        </Formik>
      </Card>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Logs'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingLogs}
            rowsPerPage={5}
            dataArray={Object.values(props.logs)}
            dataTotal={props.logTotal}
            columns={columns}
            my_options={{
              exportButton: true,
              exportCsv: (columns, data) => {
                props.exportLogsBegin();
              }
            }}

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
  isCommitting: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleChangeScope: PropTypes.func,
  exportLogsBegin: PropTypes.func,
  handleFilterChange: PropTypes.func.isRequired,
  selectGroups: PropTypes.array,
  params: PropTypes.object,
  logFrom: PropTypes.instanceOf(DateTime),
  logTo: PropTypes.instanceOf(DateTime),
  groupLabels: PropTypes.array,

};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(LogList);
