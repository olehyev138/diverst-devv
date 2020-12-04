/**
 *
 * Budget Overview Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form, getIn, FastField } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import { floatRound, toNumber } from 'utils/floatRound';


import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import appMessages from 'containers/Shared/App/messages';
import { buildValues, buildValuesOfArray, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper, Box, CardHeader,
  TextField, InputAdornment, Input, FormControl, InputLabel, Typography,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { injectIntl, intlShape } from 'react-intl';
import DiverstMoneyField from 'components/Shared/DiverstMoneyField';
import { getCurrency, toCurrencyString } from 'utils/currencyHelpers';

const { form: formMessages } = messages;

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function AnnualBudgetFormInner(
  { classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, intl, annualBudgets, ...props }
) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !annualBudgets}>
      <Form>
        { values.map((value, index) => (
          <React.Fragment key={`annual_budget:${annualBudgets[index].id}`}>
            <Card>
              <CardHeader
                title={annualBudgets[index].name}
              />
              <CardContent>
                <DiverstMoneyField
                  label={intl.formatMessage(formMessages.amount)}
                  name={`[${index}].amount`}
                  id={`[${index}].amount`}
                  margin='dense'
                  fullWidth
                  disabled={props.isCommitting}
                  value={value.amount}
                  onChange={value => setFieldValue(`[${index}].amount`, value)}

                  currencyForm
                  currency={getCurrency(value.currency)}
                  currency_name={`[${index}].currency`}
                  currency_id={`[${index}].currency`}
                  onCurrencyChange={value => setFieldValue(`[${index}].currency`, value.value)}
                />
              </CardContent>
              { annualBudgets[index] && (
                <CardContent>
                  <Grid
                    container
                    justify='space-between'
                    spacing={3}
                    alignContent='stretch'
                    alignItems='center'
                  >
                    <Grid item sm={6}>
                      <Typography color='primary' variant='h6' component='h2'>
                        <DiverstFormattedMessage {...formMessages.leftover} />
                      </Typography>
                    </Grid>
                    <Grid item sm={6}>
                      <Typography color='primary' variant='h6' component='h2'>
                        <DiverstFormattedMessage {...formMessages.approved} />
                      </Typography>
                    </Grid>
                  </Grid>
                  <Grid
                    container
                    justify='space-between'
                    spacing={3}
                    alignContent='stretch'
                    alignItems='center'
                  >
                    <Grid item sm={6}>
                      <Typography color='secondary' variant='body1' component='h3'>
                        {toCurrencyString(intl, annualBudgets[index].leftover || 0, annualBudgets[index].currency)}
                      </Typography>
                    </Grid>
                    <Grid item sm={6}>
                      <Typography color='secondary' variant='body1' component='h3'>
                        {toCurrencyString(intl, annualBudgets[index].approved || 0, annualBudgets[index].currency)}
                      </Typography>
                    </Grid>
                  </Grid>
                </CardContent>
              )}
            </Card>
            <Box mb={2} />
          </React.Fragment>
        ))}
        <Card>
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...formMessages.setAnnualBudget} />
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={ROUTES.admin.plan.budgeting.index.path()}
            >
              <DiverstFormattedMessage {...formMessages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Card>
      </Form>
    </DiverstFormLoader>
  );
}

export function AnnualBudgetForm(props) {
  const initialValues = buildValuesOfArray(props.annualBudgets, {
    id: { default: '' },
    amount: { default: '' },
    currency: { default: 'USD' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        values.forEach(value => props.annualBudgetAction(value));
      }}
    >
      {formikProps => <AnnualBudgetFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

AnnualBudgetForm.propTypes = {
  annualBudgetAction: PropTypes.func,
  group: PropTypes.object,
  annualBudgets: PropTypes.array,
  enterpriseId: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

AnnualBudgetFormInner.propTypes = {
  intl: intlShape.isRequired,
  edit: PropTypes.bool,
  group: PropTypes.object,
  annualBudgets: PropTypes.array,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.array,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(AnnualBudgetForm);
