/**
 *
 * Expense Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { Form, Formik } from 'formik';
import { Box, Button, CardContent, Divider, Grid, Paper, TextField, Typography } from '@material-ui/core';
import { buildValues } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { selectPaginatedSelectUsers } from 'containers/User/selectors';
import { getUsersBegin } from 'containers/User/actions';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

// import messages from 'containers/Shared/Expense/messages';

/* eslint-disable object-curly-newline */
export function ExpenseFormInner({ formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;

  return (
    <React.Fragment>
      <Form>
        <Paper>
          <CardContent>
            <Typography color='secondary' variant='body1' component='h2'>
              Add an expense to this event
            </Typography>
            <TextField
              autoFocus
              fullWidth
              required
              margin='dense'
              id='description'
              name='description'
              type='text'
              onChange={handleChange}
              value={values.description}
              label='Description'
            />
            <Box mb={2} />
            <Divider />
            <Box mb={2} />
            <TextField
              fullWidth
              required
              margin='dense'
              id='amount'
              name='amount'
              type='number'
              onChange={handleChange}
              value={values.amount}
              label='Specify the amount'
            />
          </CardContent>
        </Paper>
        <Box mb={2} />
        <Grid container spacing={2}>
          <Grid item>
            <DiverstSubmit isCommitting={props.isCommitting} variant='contained'>
              {buttonText}
            </DiverstSubmit>
          </Grid>
          <Grid item>
            <Button
              component={WrappedNavLink}
              to={props.links.index}
              disabled={props.isCommitting}
              variant='contained'
            >
              Cancel
            </Button>
          </Grid>
        </Grid>
      </Form>
    </React.Fragment>
  );
}

export function ExpenseForm(props) {
  const expense = dig(props, 'expense');

  const initialValues = buildValues(expense, {
    description: { default: '' },
    amount: { default: 0 },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.expenseAction({ path: props.links.index, initiative_id: props.initiativeId, ...values });
      }}
    >
      {formikProps => <ExpenseFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

ExpenseForm.propTypes = {
  expenseAction: PropTypes.func.isRequired,
  initiativeId: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  }).isRequired
};

ExpenseFormInner.propTypes = {
  expense: PropTypes.object,
  approvers: PropTypes.array,
  currentGroup: PropTypes.object,

  formikProps: PropTypes.object,

  buttonText: PropTypes.string.isRequired,

  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,

  getUsersBegin: PropTypes.func,

  links: PropTypes.shape({
    index: PropTypes.string,
  })
};

const mapStateToProps = createStructuredSelector({
  approvers: selectPaginatedSelectUsers(),
});

const mapDispatchToProps = {
  getUsersBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ExpenseForm);
