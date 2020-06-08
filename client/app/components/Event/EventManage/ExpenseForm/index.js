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

import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/EventManage/Expense/messages';
import { getCurrency } from 'utils/currencyHelpers';
import { DiverstMoneyField } from 'components/Shared/DiverstMoneyField';
const { form: formMessages } = messages;

/* eslint-disable object-curly-newline */
export function ExpenseFormInner({ formikProps, buttonText, intl, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;

  return (
    <React.Fragment>
      <Form>
        <Paper>
          <CardContent>
            <Typography color='secondary' variant='body1' component='h2'>
              <DiverstFormattedMessage {...formMessages.title} />
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
              <DiverstFormattedMessage {...formMessages.cancel} />
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
  intl: intlShape,
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
  intl: intlShape,
  expense: PropTypes.object,
  approvers: PropTypes.array,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,

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
  injectIntl,
)(ExpenseForm);
