/**
 *
 * Expense Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { Form, Formik } from 'formik';
import { Box, CardContent, Divider, Grid, Paper, TextField } from '@material-ui/core';
import { buildValues } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/EventManage/Expense/messages';
import { getCurrency } from 'utils/currencyHelpers';
import DiverstMoneyField from 'components/Shared/DiverstMoneyField';
const { form: formMessages } = messages;

/* eslint-disable object-curly-newline */
export function ExpenseFormInner({ formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;

  return (
    <React.Fragment>
      <Form>
        <Paper>
          <CardContent>
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
              disabled={props.isCommitting}
              label={<DiverstFormattedMessage {...formMessages.description} />}
            />
            <Box mb={2} />
            <Divider />
            <Box mb={2} />
            <DiverstMoneyField
              label={<DiverstFormattedMessage {...formMessages.amount} />}
              id='amount'
              name='amount'
              margin='dense'
              fullWidth
              disabled={props.isCommitting}
              value={values.amount}
              onChange={value => setFieldValue('amount', value)}
              currency={getCurrency(props.currentEvent.currency)}
            />
          </CardContent>
        </Paper>
        <Box mb={2} />
        <Grid container spacing={2}>
          <Grid item>
            <DiverstSubmit isCommitting={props.isCommitting} variant='contained'>
              <DiverstFormattedMessage {...buttonText} />
            </DiverstSubmit>
          </Grid>
          <Grid item>
            <DiverstCancel
              redirectFallback={props.links.index}
              disabled={props.isCommitting}
              variant='contained'
            >
              <DiverstFormattedMessage {...formMessages.cancel} />
            </DiverstCancel>
          </Grid>
        </Grid>
      </Form>
    </React.Fragment>
  );
}

export function ExpenseForm(props) {
  const expense = props?.expense;

  const initialValues = buildValues(expense, {
    id: { default: '' },
    description: { default: '' },
    amount: { default: '' },
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
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,

  formikProps: PropTypes.object,

  buttonText: PropTypes.object.isRequired,

  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,

  links: PropTypes.shape({
    index: PropTypes.string,
  })
};

export default compose(
  memo,
)(ExpenseForm);
