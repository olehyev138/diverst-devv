/**
 *
 * RangeSelector Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';

import { buildValues } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, ButtonGroup,
} from '@material-ui/core';
import RefreshIcon from '@material-ui/icons/Cached';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  dateInput: {
    padding: '8.5px 10px',
  },
  refreshButton: {
    minWidth: 'initial',
    padding: '7px 10px',
  }
});

/* eslint-disable object-curly-newline */
export function RangeSelectorInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const { classes } = props;

  return (
    <Form>
      <Grid container spacing={2}>
        <Grid item>
          <ButtonGroup
            color='secondary'
            size='medium'
            variant='contained'
          >
            <Field
              component={Button}
              onChange={handleChange}
              id='name'
              name='name'
              onClick={() => setFieldValue('from_date', '1m')}
            >
              1M
            </Field>
            <Field
              component={Button}
              onChange={handleChange}
              id='name'
              name='name'
              onClick={() => setFieldValue('from_date', '3m')}
            >
              3M
            </Field>
            <Field
              component={Button}
              onChange={handleChange}
              id='name'
              name='name'
              onClick={() => setFieldValue('from_date', '6m')}
            >
              6M
            </Field>
            <Field
              component={Button}
              onChange={handleChange}
              id='name'
              name='name'
              onClick={() => setFieldValue('from_date', 'ytd')}
            >
              YTD
            </Field>
            <Field
              component={Button}
              onChange={handleChange}
              id='name'
              name='name'
              onClick={() => setFieldValue('from_date', '1y')}
            >
              YTD
            </Field>
          </ButtonGroup>
        </Grid>
        <Grid item>
          <Field
            component={TextField}
            margin='none'
            type='date'
            variant='outlined'
            onChange={handleChange}
            id='name'
            name='name'
            helperText='From'
            value={values.from_date}
            inputProps={{
              className: classes.dateInput
            }}
          />
        </Grid>
        <Grid item>
          <Field
            component={TextField}
            margin='none'
            type='date'
            variant='outlined'
            onChange={handleChange}
            id='name'
            name='name'
            helperText='To'
            value={values.to_date}
            inputProps={{
              className: classes.dateInput
            }}
          />
        </Grid>
        <Grid item>
          <Button
            color='primary'
            type='submit'
            size='small'
            variant='contained'
            className={classes.refreshButton}
          >
            <RefreshIcon />
          </Button>
        </Grid>
      </Grid>
    </Form>
  );
}

export function RangeSelector(props) {
  const initialValues = buildValues({}, {
    from_date: { default: '' },
    to_date: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => props.updateRange(values)}
      render={formikProps => <RangeSelectorInner {...props} {...formikProps} />}
    />
  );
}

RangeSelector.propTypes = {
  updateRange: PropTypes.func.isRequired,
};

RangeSelectorInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(RangeSelector);
