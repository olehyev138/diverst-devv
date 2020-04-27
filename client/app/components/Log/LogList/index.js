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

const styles = theme => ({
  logListItem: {
    width: '100%',
  },
  logListItemDescription: {
    paddingTop: 8,
  },
});

const keyToComp = (key) => {
  const parts = key.split('.');
  const capital = parts.map(str => str.replace(
    /(^\w)|([-_][a-z])/g,
    group => group.toUpperCase().replace('_', '')
  ));
  return capital.join('/');
};

export function LogList(props, context) {
  const { classes } = props;
  const { intl } = props;

  const columns = [
    {
      title: 'Log',
      render: (activity) => {
        try {
          // eslint-disable-next-line global-require
          const Component = require(`components/Log/LogItem/${keyToComp(activity.key)}`).default;
          return <Component activity={activity} />;
        } catch {
          return activity.key;
        }
      },
      query_field: 'created_at'
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'created_at' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'desc' : orderDir
    });
  };

  const filter = (
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
                    isMulti
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
  );

  return (
    <React.Fragment>
      {filter}
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Logs'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isLoading}
            rowsPerPage={10}
            dataArray={props.logs}
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
  logs: PropTypes.array,
  logTotal: PropTypes.number,
  isLoading: PropTypes.bool,
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
