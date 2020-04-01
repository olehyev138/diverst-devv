/**
 *
 * LogList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Grid, Box, Typography, Card, CardContent, Select
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Segment/messages';
import { injectIntl, intlShape } from 'react-intl';
import ExportIcon from "@material-ui/icons/SaveAlt";
import { Field, Form, Formik } from 'formik';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';


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

  const columns = [
    {
      title: '',
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
          <Button
            className={classes.actionButton}
            variant='contained'
            color='secondary'
            size='large'
            startIcon={<ExportIcon />}
            onClick={() => props.exportLogsBegin()}
          >
            Export Logs
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <Card>
        <Formik
          initialValues={{
            from: '',
            to: '',
            group: '',
          }}
          enableReinitialize
          onSubmit={(values) => {
            // values.segmentIds = (values.segmentLabels || []).map(i => i.value);
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
                    <Field
                      component={Select}
                      fullWidth
                      disabled={props.isCommitting}
                      id='name'
                      name='name'
                      margin='dense'
                      label='Filter by group'
                      value=''
                      // options={props.selectGroups}
                      // onChange={value => props.changePage(value.value)}
                    />
                  </Grid>
                  <Grid item xs={3}>
                    <Field
                      component={DiverstDatePicker}
                      disabled={props.isCommitting}
                      keyboardMode
                      fullWidth
                      id='from'
                      name='from'
                      margin='dense'
                    />
                  </Grid>
                  <Grid item xs={3}>
                    <Field
                      component={DiverstDatePicker}
                      disabled={props.isCommitting}
                      keyboardMode
                      fullWidth
                      id='to'
                      name='to'
                      margin='dense'
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
};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(LogList);
