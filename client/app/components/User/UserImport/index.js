/**
 *
 * UserList Component
 *
 *
 */

import React, {
  memo, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem, Paper, CardHeader, TextField, Divider,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import dig from 'object-dig';


import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstLoader from 'components/Shared/DiverstLoader';
import { Field, Form, Formik } from 'formik';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFileInput from 'components/Shared/DiverstFileInput';


const styles = theme => ({
  padding: {
    paddingBottom: theme.spacing(3),
    margin: theme.spacing(0, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
});

export function ImportForm({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  const { isCommitting } = props;

  return (
    <React.Fragment>
      <Paper>
        <Form>
          <CardContent>
            <Field
              component={DiverstFileInput}
              disabled={isCommitting}
              fullWidth
              id='csv'
              name='csv'
              margin='normal'
              label='Import your file'
              value={values.csv}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={isCommitting}>
              Import
            </DiverstSubmit>
          </CardActions>
        </Form>
      </Paper>
    </React.Fragment>
  );
}

export function UserImport(props, context) {
  const { classes, fields, isLoading } = props;

  return (
    <React.Fragment>
      <Paper>
        <CardHeader
          title='Import users via CSV'
        />
        <CardContent>
          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            Import instructions
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            To batch import users, upload a CSV file using the form below. The file needs to follow the following structure:
          </Typography>
          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            Columns
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            The file must contain the following columns in the specified order. Leave a cell blank if you don&#39;t have the necessary information for the user. Columns marked with an asterisk are required.
          </Typography>

          <Grid className={classes.padding}>
            <DiverstLoader isLoading={isLoading}>
              {fields.map((fieldName, index) => (
                <Typography component='h2' variant='body1' color='secondary'>
                  {`${index}. ${fieldName}`}
                </Typography>
              ))}
            </DiverstLoader>
          </Grid>

          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            Rows
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            The first row is reserved for headers and will not be imported. Every subsequent row will be imported as a user.
          </Typography>
        </CardContent>
      </Paper>
      <Box mb={3} />
      <Formik
        initialValues={{
          csv: null
        }}
        enableReinitialize
        onSubmit={(values, actions) => {
          // eslint-disable-next-line no-alert
          alert(values);
        }}
      >
        {formikProps => <ImportForm {...props} {...formikProps} />}
      </Formik>
    </React.Fragment>
  );
}

UserImport.propTypes = {
  classes: PropTypes.object,
  fields: PropTypes.array,
  isLoading: PropTypes.bool,
};

ImportForm.propTypes = {
  classes: PropTypes.object,
  isCommitting: PropTypes.bool,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(UserImport);
