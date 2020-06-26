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
import { injectIntl, intlShape } from 'react-intl';


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
              id='import_file'
              name='import_file'
              margin='normal'
              label='Import your file'
              value={values.import_file}
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
  const { classes, fields, isLoading, importAction, intl } = props;

  return (
    <React.Fragment>
      <Paper>
        <CardHeader
          title={intl.formatMessage(messages.imports.title)}
        />
        <CardContent>
          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            <DiverstFormattedMessage {...messages.imports.importInstructionsTitle} />
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            <DiverstFormattedMessage {...messages.imports.importInstructions} />
          </Typography>
          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            <DiverstFormattedMessage {...messages.imports.columnInstructionsTitle} />
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            <DiverstFormattedMessage {...messages.imports.columnInstructions} />
          </Typography>

          <Grid className={classes.padding}>
            <DiverstLoader isLoading={isLoading}>
              {fields.map((fieldName, index) => (
                <React.Fragment key={fieldName}>
                  <Typography component='h2' variant='body1' color='secondary'>
                    {`${index + 1}. ${fieldName}`}
                  </Typography>
                </React.Fragment>
              ))}
            </DiverstLoader>
          </Grid>

          <Typography component='h2' variant='h6' className={classes.dataHeaders}>
            <DiverstFormattedMessage {...messages.imports.rowsInstructionsTitle} />
          </Typography>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            <DiverstFormattedMessage {...messages.imports.rowsInstructions} />
          </Typography>

          <Button size='small' variant='outlined' className={classes.dataHeaders} onClick={() => props.getSampleImportBegin({})}>
            <Typography component='body1' variant='body1'>
              <DiverstFormattedMessage {...messages.imports.SampleInstructionsTitle} />
            </Typography>
          </Button>
          <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
            <DiverstFormattedMessage {...messages.imports.SampleInstructions} />
          </Typography>
        </CardContent>
      </Paper>
      <Box mb={3} />
      <Formik
        initialValues={{
          import_file: null
        }}
        enableReinitialize
        onSubmit={(values, actions) => {
          importAction(values);
        }}
      >
        {formikProps => <ImportForm {...props} {...formikProps} />}
      </Formik>
    </React.Fragment>
  );
}

UserImport.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  fields: PropTypes.array,
  isLoading: PropTypes.bool,
  importAction: PropTypes.func.isRequired,
  getSampleImportBegin: PropTypes.func.isRequired,
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
  injectIntl,
  withStyles(styles),
)(UserImport);
